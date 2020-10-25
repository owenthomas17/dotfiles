#! /bin/sh

# Start tmux session
# Name it dev (-s)
# Call the first window shell (-n)
# Start it in the background (-d)
tmux new-session -s dev -n shell -d

# Create additional windows
# Window name (-n)
# Change working directory (-c)
tmux new-window -n vim -c ${HOME}/repos

# Attach to the created session
# Attach to session name (-t)
tmux attach -t dev
