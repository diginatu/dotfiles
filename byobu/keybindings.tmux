# prefix
unbind-key -n C-s
unbind-key -n C-a
set -g prefix ^S
set -g prefix2 ^S
bind Enter send-prefix

# new window
unbind-key t
bind t new-window -c '#{pane_current_path} ; rename-window -'

# separate window
bind v display-panes ; split-window -h -c '#{pane_current_path}'
bind s display-panes ; split-window -v -c '#{pane_current_path}'

# select window
unbind-key n
bind -r n next-window
unbind-key C-n
bind -r C-n next-window
unbind-key p
bind -r p previous-window
unbind-key C-p
bind -r C-p previous-window

# select pane
unbind-key k
unbind-key l
unbind-key K
unbind-key L
unbind-key C-h
bind -r k display-panes \; select-pane -U
bind -r j display-panes \; select-pane -D
bind -r h display-panes \; select-pane -L
bind -r l display-panes \; select-pane -R
bind -r C-k display-panes \; select-pane -U
bind -r C-j display-panes \; select-pane -D
bind -r C-h display-panes \; select-pane -L
bind -r C-l display-panes \; select-pane -R
