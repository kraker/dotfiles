#!/bin/bash
# ----------------------------------------------------------------------
# created by francois scheurer on 20070323
# derivate from mikes handy rotating-filesystem-snapshot utility
# see http://www.mikerubel.org/computers/rsync_snapshots
# ----------------------------------------------------------------------
#rsync note:
#    1) rsync -avz /src/foo  /dest      => ok, creates /dest/foo, like cp -a /src/foo /dest
#    2) rsync -avz /src/foo/ /dest/foo  => ok, creates /dest/foo, like cp -a /src/foo/. /dest/foo (or like cp -a /src/foo /dest)
#    3) rsync -avz /src/foo/ /dest/foo/ => ok, same as 2)
#    4) rsync -avz /src/foo/ /dest      => dangerous!!! overwrite dest content, like cp -a /src/foo/. /dest
#      solution: remove trailing / at /src/foo/ => 1)
#      minor problem: rsync -avz /src/foo /dest/foo => creates /dest/foo/foo, like mkdir /dest/foo && cp -a /src/foo /dest/foo
#    main options:
#      -H --hard-links
#      -a equals -rlptgoD (no -H,-A,-X)
#        -r --recursive
#        -l --links
#        -p --perms
#        -t --times
#        -g --group
#        -o --owner
#        -D --devices --specials
#      -x --one-file-system
#      -S --sparse
#      --numeric-ids
#    useful options:
#      -n --dry-run
#      -z --compress
#      -y --fuzzy
#      --bwlimit=X limit disk IO to X kB/s
#      -c --checksum
#      -I --ignore-times
#      --size-only
#    other options:
#      -v --verbose
#      -P equals --progress --partial
#      -h --human-readable
#      --stats
#      -e'ssh -o ServerAliveInterval=60'
#      --delete
#      --delete-delay
#      --delete-excluded
#      --ignore-existing
#      -i --itemize-changes
#      --stop-at
#      --time-limit
#      --rsh=\"ssh -p ${HOST_PORT} -i /root/.ssh/rsync_rsa -l root\" 
#      --rsync-path=\"/usr/bin/rsync\""
#    quickcheck options:
#      the default behavior is to skip files with same size & mtime on destination
#      mtime = last data write access
#      atime = last data read access (can be ignored with noatime mount option or with chattr +A)
#      ctime = last inode change (write access, change of permission or ownership)
#      note that a checksum is always done after a file synchronization/transfer
#      --modify-window=X ignore mtime differences less or equal to X sec
#      --size-only skip files with same size on destination (ignore mtime)
#      -c --checksum skip files with same MD5 checksum on destination (ignore size & mtime, all files are read once, then the list of files to be resynchronized is read a second time, there is a lot of disk IO but network trafic is minimal if many files are identical; log includes only different files)
#      -I --ignore-times never skip files (all files are resynchronized, all files are read once, there is more network trafic than with --checksum but less disk IO and hence is faster than --checksum if net is fast or if most files are different; log includes all files)
#      --link-dest does the quickcheck on another reference-directory and makes hardlinks if quickcheck succeeds
#        (however, if mtime is different and --perms is used, the reference file is copied in a new inode)
#    see also this link for a rsync tutorial: http://www.thegeekstuff.com/2010/09/rsync-command-examples/
#todo:
#                 'du' slow on many snapshot.X..done
#  autokill after n minutes.
#                 if disk full, its better to replace the snapshot.001 than to cancel and have a very old backup (even if it may fail to create the snapshot and ends with 0 backups)..done
#                 rsync-snapshot for oracle redo logs..old
#                 'find'-list with md5 signatures -> .gz file stored aside rsync.log.gz inside the snapshot.X folder; this file will be move to parent dir /backup/snapshot/localhost/ before deletion of a snapshot; this file will also be used to extract an incremental backup with tape-arch.sh..done (md5sum calculation with rsync-list.sh for acm14=18m58 and only 5m27 with a reference file. speedup is ~250-300%)
#  realtime freedisk display with echo $(($(stat -f -c "%f" /backup/snapshot/) * 4096 / 1024))
#  use authorized_keys with restriction of bash (command=) and set sshd_config with PermitRootLogin=forced-commands-only, see http://troy.jdmz.net/rsync/index.html http://www.snailbook.com/faq/restricted-scp.auto.html
#  note: rsync lists all files in snapshot.X disregarding inclusion patterns, this is slow.




# ------------- the help page ------------------------------------------
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  cat << "EOF"
Version 2.01 2013-01-16

USAGE: rsync-snapshot.sh HOST [--recheck]

PURPOSE: create a snapshot backup of the whole filesystem into the folder
  '/backup/snapshot/HOST/snapshot.001'.
  If HOST is 'localhost' it is replaced with the local hostname.
  If HOST is a remote host then rsync over ssh is used to transfer the files
  with a delta-transfer algorithm to transfer only minimal parts of the files
  and improve speed; rsync uses for this the previous backup as reference.
  This reference is also used to create hard links instead of files when
  possible and thus save disk space. If original and reference file have
  identical content but different timestamps or permissions then no hard link
  is created.
  A rotation of all backups renames snapshot.X into snapshot.X+1 and removes
  backups with X>512. About 10 backups with non-linear distribution are kept
  in rotation; for example with X=1,2,3,4,8,16,32,64,128,256,512.
  The snapshots folders are protected read-only against all users including
  root using 'chattr'.
  The --recheck option forces a sync of all files even if they have same mtime
  & size; it is can verify a backup and fix corrupted files;
  --recheck recalculates also the MD5 integrity signatures without using the
  last signature-file as precalculation.
  Some features like filter rules, MD5, chattr, bwlimit and per server retention
  policy can be configured by modifying the scripts directly.

FILES:
    /backup/snapshot/rsync/rsync-snapshot.sh  the backup script
    /backup/snapshot/rsync/rsync-list.sh      the md5 signature script
    /backup/snapshot/rsync/rsync-exclude.txt  the filter rules

Examples:
  (nice -5 ./rsync-snapshot.sh >log &) ; tail -f log
  cd /backup/snapshot; for i in $(ls -A); do nice -10 /backup/snapshot/rsync/rsync-snapshot.sh $i; done
EOF
  exit 1
fi




# ------------- tuning options, file locations and constants -----------
SRC="$1" #name of backup source, may be a remote or local hostname
OPT="$2" #options (--recheck)
HOST_PORT=22 #port of source of backup
SCRIPT_PATH="/backup/snapshot/rsync"
SNAPSHOT_DST="/backup/snapshot" #destination folder
NAME="snapshot" #backup name
LOG="rsync.log"
MIN_MIBSIZE=5000 # older snapshots (except snapshot.001) are removed if free disk <= MIN_MIBSIZE. the script may exit without performing a backup if free disk is still short.
OVERWRITE_LAST=0 # if free disk space is too small, then this option let us remove snapshot.001 as well and retry once
MAX_MIBSIZE=80000 # older snapshots (except snapshot.001) are removed if their size >= MAX_MIBSIZE. the script performs a backup even if their size is too big.
#old: SPEED=5 # 1 is slow, 100 is fast, 100000 faster and 0 does not use slow-down. this allows to avoid rsync consuming too much system performance
BWLIMIT=100000 # bandwidth limit in KiB/s. 0 does not use slow-down. this allows to avoid rsync consuming too much system performance
BACKUPSERVER="rembk" # this server connects to all other to download filesystems and create remote snapshot backups
MD5LIST=0 #to compute a list of md5 integrity signatures of all backuped files, need 'rsync-list.sh'
CHATTR=1 # to use 'chattr' command and protect the backups again modification and deletion
DU=1 # to use 'du' command and calculate the size of existing backups, disable it if you have many backups and it is getting too slow (for example on BACKUPSERVER)
SOURCE="/" #source folder to backup

HOST_LOCAL="$(hostname -s)" #local hostname
#HOST_SRC="${SRC:-${HOST_LOCAL}}" #explicit source hostname, default is local hostname
if [ -z "${SRC}" ] || [ "${SRC}" == "localhost" ]; then
  HOST_SRC="${HOST_LOCAL}" #explicit source hostname, default is local hostname
else
  HOST_SRC="${SRC}" #explicit source hostname
fi

if [ "${HOST_LOCAL}" == "${BACKUPSERVER}" ]; then #if we are on BACKUPSERVER then do some fine tuning
  MD5LIST=1
  MIN_MIBSIZE=35000 #needed free space for chunk-file tape-arch.sh
  MAX_MIBSIZE=12000
  DU=0 # NB: 'du' is currently disabled on BACKUPSERVER for performance reasons
elif [ "${HOST_LOCAL}" == "${HOST_SRC}" ]; then #else if we are on a generic server then do other some fine tuning
  if [ "${HOST_SRC}" == "ZRHSV-TST01" ]; then
    MIN_MIBSIZE=500; CHATTR=0; DU=0; MD5LIST=0
  fi
fi




# ------------- initialization -----------------------------------------
shopt -s extglob                                            #enable extended pattern matching operators

OPTION="--stats \
  --recursive \
  --links \
  --perms \
  --times \
  --group \
  --owner \
  --devices \
  --hard-links \
  --numeric-ids \
  --delete \
  --delete-excluded \
  --bwlimit=${BWLIMIT}"
#  --progress
#  --size-only
#  --stop-at
#  --time-limit
#  --sparse

if [ "${HOST_SRC}" != "${HOST_LOCAL}" ]; then #option for a remote server
  SOURCE="${HOST_SRC}:${SOURCE}"
  OPTION="${OPTION} \
  --compress \
  --rsh=\"ssh -p ${HOST_PORT} -i /root/.ssh/rsync_rsa -l root\" \
  --rsync-path=\"/usr/bin/rsync\""
fi
if [ "${OPT}" == "--recheck" ]; then
  OPTION="${OPTION} \
  --ignore-times"
elif [ -n "${OPT}" ]; then
  echo "Try rsync-snapshot.sh --help ."
  exit 2
fi




# ------------- check conditions ---------------------------------------
echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot backup is created into ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.001 ==="
STARTDATE=$(date +%s)

# make sure we're running as root
if (($(id -u) != 0)); then
  echo "Sorry, must be root. Exiting..."
  echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot failed. ==="
  exit 2
fi

# make sure we have a correct snapshot folder
if [ ! -d "${SNAPSHOT_DST}/${HOST_SRC}" ]; then
  echo "Sorry, folder ${SNAPSHOT_DST}/${HOST_SRC} is missing. Exiting..."
  echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot failed. ==="
  exit 2
fi

# make sure we do not have started already rsync-snapshot.sh or rsync process (started by rsync-cp.sh or by a remote rsync-snapshot.sh) in the background.
if [ "${HOST_LOCAL}" != "${BACKUPSERVER}" ]; then #because BACKUPSERVER need sometimes to perform an rsync-cp.sh it must disable the check of "already started".
  #RSYNCPID=$(pgrep -f "/bin/bash .*rsync-snapshot.sh")
  #if ([ -n "${RSYNCPID}" ] && [ "${RSYNCPID}" != "$$" ]) #|| pgrep -x "rsync"
  if pgrep -f "/bin/\w*sh \w*rsync-snapshot\.sh" | grep -qv "$$"; then
    echo "Sorry, rsync is already running in the background. Exiting..."
    echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot failed. ==="
    exit 2
  fi
fi




# ------------- remove some old backups --------------------------------
# remove certain snapshots to achieve an exponential distribution in time of the backups (1,2,4,8,...)
for b in 512 256 128 64 32 16 8 4; do
  let a=b/2+1
  let f=0 #this flag is set to 1 when we find the 1st snapshot in the range b..a
  for i in $(seq -f'%03g' "${b}" -1 "${a}"); do
    if [ -d "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" ]; then
      if [ "${f}" -eq 0 ]; then
        let f=1
      else
        echo "$(date +%Y-%m-%d_%H:%M:%S) Removing ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i} ..."
        [ "${CHATTR}" -eq 1 ] && chattr -R -i "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" &>/dev/null
        rm -rf "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}"
      fi
    fi
  done
done

# remove additional backups if free disk space is short
remove_snapshot() {
  local MIN_MIBSIZE2=$1
  local MAX_MIBSIZE2=$2
  for i in $(seq -f'%03g' 512 -1 001); do
    if [ -d "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" ] || [ ${i} -eq 1 ]; then
      [ ! -h "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last" ] && [ -d "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" ] && ln -s "${NAME}.${i}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last"
      let d=0 #disk space used by snapshots and free disk space are ok
      echo -n "$(date +%Y-%m-%d_%H:%M:%S) Checking free disk space... "
      FREEDISK=$(df -m ${SNAPSHOT_DST} | tail -1 | sed -e 's/  */ /g' | cut -d" " -f4 | sed -e 's/M*//g')
      echo -n "${FREEDISK} MiB free. "
      if [ ${FREEDISK} -ge ${MIN_MIBSIZE2} ]; then
        echo "Ok, bigger than ${MIN_MIBSIZE2} MiB."
        if [ "${DU}" -eq 0 ]; then #avoid slow 'du'
          break
        else
          echo -n "$(date +%Y-%m-%d_%H:%M:%S) Checking disk space used by ${SNAPSHOT_DST}/${HOST_SRC} ... "
          USEDDISK=$(du -ms "${SNAPSHOT_DST}/${HOST_SRC}/" | cut -f1)
          echo -n "${USEDDISK} MiB used. "
          if [ ${USEDDISK} -le ${MAX_MIBSIZE2} ]; then
            echo "Ok, smaller than ${MAX_MIBSIZE2} MiB."
            break
          else
            let d=2 #disk space used by snapshots is too big
          fi
        fi
      else
        let d=1 #free disk space is too small
      fi
      if [ ${d} -ne 0 ]; then #we need to remove snapshots
        if [ ${i} -ne 1 ]; then
          echo "Removing ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i} ..."
          [ "${CHATTR}" -eq 1 ] && chattr -R -i "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" &>/dev/null
          rm -rf "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}"
          [ -h "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last" ] && rm -f "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last"
        else #all snapshots except snapshot.001 are removed
          if [ ${d} -eq 1 ]; then #snapshot.001 causes that free space is too small
            if [ "${OVERWRITE_LAST}" -eq 1 ]; then #last chance: remove snapshot.001 and retry once
              OVERWRITE_LAST=0
              echo "Warning, free disk space will be smaller than ${MIN_MIBSIZE} MiB."
              echo "$(date +%Y-%m-%d_%H:%M:%S) OVERWRITE_LAST enabled. Removing ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.001 ..."
              rm -rf "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.001"
              [ -h "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last" ] && rm -f "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last"
            else
              for j in ${LNKDST//--link-dest=/}; do
                if [ -d "${j}" ] && [ "${CHATTR}" -eq 1 ] && [ $(lsattr -d "${j}" | cut -b5) != "i" ]; then
                  chattr -R +i "${j}" &>/dev/null #undo unprotection that was needed to use hardlinks
                fi
              done
              [ ! -h "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last" ] && ln -s "${NAME}.${j}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last"
              echo "Sorry, free disk space will be smaller than ${MIN_MIBSIZE} MiB. Exiting..."
              echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot failed. ==="
              exit 2
            fi
          elif [ ${d} -eq 2 ]; then #snapshot.001 causes that disk space used by snapshots is too big
            echo "Warning, disk space used by ${SNAPSHOT_DST}/${HOST_SRC} will be bigger than ${MAX_MIBSIZE} MiB. Continuing anyway..."
          fi
        fi
      fi
    fi
  done
}

# perform an estimation of required disk space for the new backup
while :; do #this loop is executed a 2nd time if OVERWRITE_LAST was ==1 and snapshot.001 got removed
  OOVERWRITE_LAST="${OVERWRITE_LAST}"
  echo -n "$(date +%Y-%m-%d_%H:%M:%S) Testing needed free disk space ..."
  mkdir -p "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.test-free-disk-space"
  chmod -R 775 "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.test-free-disk-space"
  cat /dev/null >"${SNAPSHOT_DST}/${HOST_SRC}/${LOG}"
  LNKDST=$(find "${SNAPSHOT_DST}/" -maxdepth 2 -type d -name "${NAME}.001" -printf " --link-dest=%p")
  for i in ${LNKDST//--link-dest=/}; do
    if [ -d "${i}" ] && [ "${CHATTR}" -eq 1 ] && [ $(lsattr -d "${i}" | cut -b5) == "i" ]; then
      chattr -R -i "${i}" &>/dev/null #unprotect last snapshots to use hardlinks
    fi
  done
  eval rsync \
    --dry-run \
    ${OPTION} \
    --include-from="${SCRIPT_PATH}/rsync-include.txt" \
    ${LNKDST} \
    "${SOURCE}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.test-free-disk-space" >>"${SNAPSHOT_DST}/${HOST_SRC}/${LOG}"
  RES=$?
  if [ "${RES}" -ne 0 ] && [ "${RES}" -ne 23 ] && [ "${RES}" -ne 24 ]; then
    echo "Sorry, error in rsync execution (value ${RES}). Exiting..."
    echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot failed. ==="
    exit 2
  fi
  let i=$(tail -100 "${SNAPSHOT_DST}/${HOST_SRC}/${LOG}" | grep 'Total transferred file size:' | cut -d " " -f5)/1048576
  echo " ${i} MiB needed."
  rm -rf "${SNAPSHOT_DST}/${HOST_SRC}/${LOG}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.test-free-disk-space"
  remove_snapshot $((${MIN_MIBSIZE} + ${i})) $((${MAX_MIBSIZE} - ${i}))
  if [ "${OOVERWRITE_LAST}" == "${OVERWRITE_LAST}" ]; then #no need to retry
    break
  fi
done




# ------------- create the snapshot backup -----------------------------
# perform the filesystem backup using rsync and hard-links to the latest snapshot
# Note:
#   -rsync behaves like cp --remove-destination by default, so the destination
#    is unlinked first.  If it were not so, this would copy over the other
#    snapshot(s) too!
#   -use --link-dest to hard-link when possible with previous snapshot,
#    timestamps, permissions and ownerships are preserved
echo "$(date +%Y-%m-%d_%H:%M:%S) Creating folder ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000 ..."
mkdir -p "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000"
chmod 775 "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000"
cat /dev/null >"${SNAPSHOT_DST}/${HOST_SRC}/${LOG}"
echo -n "$(date +%Y-%m-%d_%H:%M:%S) Creating backup of ${HOST_SRC} into ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000"
if [ -n "${LNKDST}" ]; then
  echo " hardlinked with${LNKDST//--link-dest=/} ..."
else
  echo " not hardlinked ..."
fi
eval rsync \
  -vv \
  ${OPTION} \
  --exclude-from="${SCRIPT_PATH}/rsync-exclude.txt" \
  ${LNKDST} \
  "${SOURCE}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000" >>"${SNAPSHOT_DST}/${HOST_SRC}/${LOG}"
RES=$?
if [ "${RES}" -ne 0 ] && [ "${RES}" -ne 23 ] && [ "${RES}" -ne 24 ]; then
  echo "Sorry, error in rsync execution (value ${RES}). Exiting..."
  echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot failed. ==="
  exit 2
fi
for i in ${LNKDST//--link-dest=/}; do
  if [ -d "${i}" ] && [ "${CHATTR}" -eq 1 ] && [ $(lsattr -d "${i}" | cut -b5) != "i" ]; then
    chattr -R +i "${i}" &>/dev/null #undo unprotection that was needed to use hardlinks
  fi
done
mv "${SNAPSHOT_DST}/${HOST_SRC}/${LOG}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000/${LOG}"
gzip -f "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000/${LOG}"




# ------------- create the MD5 integrity signature ---------------------
# create a gziped 'find'-list of all snapshot files (including md5 signatures)
if [ "${MD5LIST}" -eq 1 ]; then
  echo "$(date +%Y-%m-%d_%H:%M:%S) Computing filelist with md5 signatures of ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000 ..."
  OWD="$(pwd)"
  cd "${SNAPSHOT_DST}"
#  NOW=$(date "+%s")
#  MYTZ=$(date "+%z")
#  let NOW${MYTZ:0:1}=3600*${MYTZ:1:2}+60*${MYTZ:3:2} # convert localtime to UTC
#  DATESTR=$(date -d "1970-01-01 $((${NOW} - 1)) sec" "+%Y-%m-%d_%H:%M:%S") # 'now - 1s' to avoid missing files
  DATESTR=$(date -d "1970-01-01 UTC $(($(date +%s) - 1)) seconds" "+%Y-%m-%d_%H:%M:%S") # 'now - 1s' to avoid missing files
  REF_LIST="$(find ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.001/ -maxdepth 1 -type f -name 'snapshot.*.list.gz' 2>/dev/null)"
  if [ -n "${REF_LIST}" ] && [ "${OPT}" != "--recheck" ]; then
    REF_LIST2="/tmp/rsync-reflist.tmp"
    gzip -dc "${REF_LIST}" >"${REF_LIST2}"
    touch -r "${REF_LIST}" "${REF_LIST2}"
    ${SCRIPT_PATH}/rsync-list.sh "${HOST_SRC}/${NAME}.000" 0 "${REF_LIST2}" | sort -u | gzip -c >"${HOST_SRC}/${NAME}.${DATESTR}.list.gz"
    rm -f "${REF_LIST2}"
  else
    ${SCRIPT_PATH}/rsync-list.sh "${HOST_SRC}/${NAME}.000" 0 | sort -u | gzip -c >"${HOST_SRC}/${NAME}.${DATESTR}.list.gz"
  fi
  touch -d "${DATESTR/_/ }" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${DATESTR}.list.gz"
  cd "${OWD}"
  [ ! -d "${SNAPSHOT_DST}/${HOST_SRC}/md5-log" ] && mkdir -p "${SNAPSHOT_DST}/${HOST_SRC}/md5-log"
  cp -al "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${DATESTR}.list.gz" "${SNAPSHOT_DST}/${HOST_SRC}/md5-log/${NAME}.${DATESTR}.list.gz"
  mv "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${DATESTR}.list.gz" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000/${NAME}.${DATESTR}.list.gz"
  touch -d "${DATESTR/_/ }" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000"
fi




# ------------- finish and clean up ------------------------------------
# protect the backup against modification with chattr +immutable
if [ "${CHATTR}" -eq 1 ]; then
  echo "$(date +%Y-%m-%d_%H:%M:%S) Setting recursively immutable flag of ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000 ..."
  chattr -R +i "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.000" &>/dev/null
fi

# rotate the backups
if [ -d "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.512" ]; then #remove snapshot.512
  echo "Removing ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.512 ..."
  [ "${CHATTR}" -eq 1 ] && chattr -R -i "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.512" &>/dev/null
  rm -rf "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.512"
fi
[ -h "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last" ] && rm -f "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last"
for i in $(seq -f'%03g' 511 -1 000); do
  if [ -d "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" ]; then
    let j=${i##+(0)}+1
    j=$(printf "%.3d" "${j}")
    echo "Renaming ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i} into ${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${j} ..."
    [ "${CHATTR}" -eq 1 ] && chattr -i "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" &>/dev/null
    mv "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${i}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${j}"
    [ "${CHATTR}" -eq 1 ] && chattr +i "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.${j}" &>/dev/null
    [ ! -h "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last" ] && ln -s "${NAME}.${j}" "${SNAPSHOT_DST}/${HOST_SRC}/${NAME}.last"
  fi
done

# remove additional backups if free disk space is short
OVERWRITE_LAST=0 #next call of remove_snapshot() will not remove snapshot.001
remove_snapshot ${MIN_MIBSIZE} ${MAX_MIBSIZE}
echo "$(date +%Y-%m-%d_%H:%M:%S) ${HOST_SRC}: === Snapshot backup successfully done in $(($(date +%s) - ${STARTDATE})) sec. ==="
exit 0
#eof

