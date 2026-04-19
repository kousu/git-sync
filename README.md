> [!WARNING]
> Migrated to https://codeberg.org/kousu/git-sync

# git-sync

A git subcommmand that makes the current on-disk state equal the remote state in one step.

All changed, added, or deleted files are committed blindly in a batch -- everything except `.gitignore`'d files. But on error, the repository is safely rolled back.

The main advantage of this is that it is safe to run noninteractively. You can set it loose in a cronjob and it will be fine.

## Usage

Just run

```
git -C path/to/repo sync
```

See the [full documentation](docs/git-sync.md)

If you want to get a full Dropbox-like experience, see the [contrib/](./contrib) folder.

## Installation

Build depedencies:

- [go-md2man](https://github.com/cpuguy83/go-md2man)
- make (any version)

User-local:

```
make install
```

or system-wide:

```
sudo make install
```

## Development setup

```
mkdir -p ~/.local/bin
ln -s `pwd`/git-sync ~/.local/bin/git-sync
```

To test the wrapper .service:

```
ln -s `pwd`/contrib/git-sync@.service ~/.config/systemd/user/git-sync@.service
ln -s `pwd`/contrib/service-alert@.service ~/.config/systemd/user/
```

To test the docs:

```
make docs
mkdir -p ~/.local/share/man/man1
ln -s `pwd`/doc/man1/git-sync.1 ~/.local/share/man/man1
git help --sync # or
man git-sync
```

## Related Work

- My [android version](https://gist.github.com/kousu/623b25dbad2d084e4ffea540c65d3ff1)
- [The other git-sync](https://github.com/simonthum/git-sync)
  - what can I say? "there are many like it but this one is mine"
  - that one is longer, requires explicit opt-in via `git config branch.main.sync true`, `git config branch.main.autocommitscript 'git add -A; git commit -m "Sync"'`, and enforces that the remote branch has the same name as the local one.
  - but it's more battle-tested than mine.
- [gitwatch](https://github.com/gitwatch/gitwatch)
  - [163](https://github.com/gitwatch/gitwatch/issues/163)
