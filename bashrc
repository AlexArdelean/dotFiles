# Define moon colors
BLACK='\[\e[38;2;192;153;233m\]'
RED='\[\e[38;2;255;117;110m\]'
GREEN='\[\e[38;2;195;232;120m\]'
YELLOW='\[\e[38;2;255;199;119m\]'
BLUE='\[\e[38;2;130;170;207m\]'
MAGENTA='\[\e[38;2;252;167;234m\]'
CYAN='\[\e[38;2;137;221;255m\]'
WHITE='\[\e[38;2;200;211;245m\]'
RESET='\[\e[0m\]' # Reset color

# Set prompt colors using moon colors
export PS1="$BLACK\u$RESET@$BLUE\h$RESET:$CYAN\w$RESET\$ "
