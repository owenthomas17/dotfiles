# Quickstart
Copy and paste this into a shell

```bash
LOCAL_GIT_DIRECTORY="${HOME}/repos/github.com/owenthomas17"
DOTFILE_SETUP_DIRECTORY="${LOCAL_GIT_DIRECTORY}/dotfiles"

mkdir -p "${LOCAL_GIT_DIRECTORY}"
git clone git@github.com:owenthomas17/dotfiles.git "${DOTFILE_SETUP_DIRECTORY}"
bash "${DOTFILE_SETUP_DIRECTORY}/setup.sh"
```
