# dotfiles

mkg's Dotfiles and Setup Scripts

# ToDo

- [ ] more gnome settings
- [ ] .atom config template & packages
- [ ] .gitconfig
- [ ] find way to merge dotfiles from repo with private values, without exposing them
  idea: git hook that "unmerges" files before commit, stores values in .private.d, then "remerges" files

# Structure

- main folder: files as is
- .private.d/: private files and settings
- .sync.d/: also private, but synced files. symlinked.

# Install

```sh
curl https://github.com/mkg20001/dotfiles/raw/master/.bin/_dotfiles_install | bash -
```
