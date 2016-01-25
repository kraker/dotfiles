#### Fish Configs ####

# Environment Variables
set PATH ~/bin $PATH
set GIT_EDITOR nvim

# Set vi mode
fish_vi_mode

# Path to Oh My Fish install.
set -gx OMF_PATH "/home/akraker/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/home/akraker/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish
