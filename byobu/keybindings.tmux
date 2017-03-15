unbind-key -n C-a

# select window
unbind-key n
bind -r n next-window
unbind-key C-n
bind -r C-n next-window
unbind-key p
bind -r p previous-window
unbind-key C-p
bind -r C-p previous-window

unbind-key k
unbind-key l
unbind-key K
unbind-key L
unbind-key C-h

# select pane
bind -r k display-panes \; select-pane -U
bind -r j display-panes \; select-pane -D
bind -r h display-panes \; select-pane -L
bind -r l display-panes \; select-pane -R
bind -r C-k display-panes \; select-pane -U
bind -r C-j display-panes \; select-pane -D
bind -r C-h display-panes \; select-pane -L
bind -r C-l display-panes \; select-pane -R
unbind-key -n C-s
set -g prefix ^S
set -g prefix2 ^S
bind s send-prefix
