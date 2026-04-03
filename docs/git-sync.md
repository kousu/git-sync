# git-sync 1 🔁

## NAME

git-sync - noninteractive bidirectional folder sync

## SYNOPSIS

git [-C path/to/repo] sync [-v] [-h] [--able] [--reset]

## DESCRIPTION

A git subcommmand that makes the current on-disk state equal the remote state in one step.

All changed, added, or deleted files are committed blindly in a batch -- everything except `.gitignore`'d files. But on error, the repository is safely rolled back.

The process is essentially

1. `git commit`
2. `git pull`
3. `git push`

but the main advantage of having a single command is that _this_ version is safe to run noninteractively: you can set it loose in a cronjob without worrying about corruption from accidentally committing merge conflicts.

## OPTIONS

<!-- beware of linters here: go-md2man REQUIRES the hanging indent to do the
    right thing, but linters see this as all one paragraph and squash it away -->
-v, --version
    Show the version (tip! this doubles as checking for installation).

--able
    check if the repo is capable of being synchronized; folders without a .git or repos with no remotes don't make any sense to sync! Returns 0 on success. Prints suggestions on failure.

--reset
    Put the repository back to the state before the last sync.

## CONFIGURATION

Syncing is done as a standard `git pull`, so in most cases it makes fast-forward merges, and in the case of divergence, makes merge commits. If you want linear history:

- `git -C path/to/folder config pull.rebase true`
- `git -C path/to/folder config --global pull.rebase true`, to use it on all your repos
- `git -C path/to/folder config branch.trunk.rebase true`, if you only want to enforce linear history on a specific branch but note that only the active branch is ever synchronized. git-sync isn't really that useful for a repo with multiple branches anyway.

## USAGE

### Central-Server 📡💻

The easiest way to use this is to set up a git server in the middle and have every device you want synced. This is the simplest, and most secure, but it means finding storage and if you're trying to sync _large_ files you might have a bad time.

### Peer-to-Peer 👥

You can also use it peer-to-peer, more directly like Dropbox/Syncthing.

First, make sure all your devices can see each other regularly. If you're using any devices not on the same LAN together, it's best to make one by setting up a virtual mesh network via [Headscale](https://headscale.net/stable/) or [innernet](https://blog.tonari.no/introducing-innernet) or even something more exotic like [Yggdrasil](https://yggdrasil-network.github.io/). This gives each device a stable hostname like laptop.tail1234ab.ts.net, workstation.tail1234ab.ts.net for Headscale, or laptop1.lan.wg, phone2.lan.wg for innernet.

Give each device ssh keys to each other (this is why this is less secure).

Create/pick a repository on one machine and clone it to each other device.

```
phone2$ git clone laptop1.lan.wg:"My Documents" ~/sync/docs
```

Set this on each copy:

```
laptop1$ git -C ~"My Documents" config receive.denyCurrentBranch updateInstead
phone2$ git -C ~/sync/docs config receive.denyCurrentBranch updateInstead
```

This allows pushing _back_ into non-bare repositories -- meaning updates happen immediately, but only if the target repository is clean of uncommitted changes at the time.

Optionally, add the reverse remote(s). You only actually need one but the symmetry is easier to remember.

```
laptop1$ git -C ~"My Documents" remote add phone2 phone2.lan.wg:sync/My\ Documents
laptop1$  git -C ~"My Documents" -u phone2
```

Then syncing should work the same from either side, and it should immediately update the files on either side:

```
laptop1$ git -C ~"My Documents" sync
phone2$  git -C ~/sync/docs sync
```

## CONFLICTS

git-sync doesn't save you from genuine conflicts. Unlike, say, Dropbox, it warns when a conflict happens, and then you can use git to figure it out. To learn how to handle conflicts, see git's [documentation](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging#_basic_merge_conflicts), or better, [@jvns's](https://ohshitgit.com/).

Unlike a normal `git pull`, `git sync` undoes the merge and its conflicts, so your files keep working. If `git sync` reports a conflict you need to manually run `git pull` and examine the conflict.

While fixing a conflict, `git sync` will refuse to operate, so it is safe to leave it running in the background while you fix the problem. And of course, if it does commit something you don't like you can always use `git reset` (particularly `git reset --mixed`) and `git reflog` to restore the version you need.

## ERROR HANDLING

...

# COPYRIGHT

Copyright (c) 2026 nick@kousu.ca.

This software is distributed under the MIT License. See LICENSE file for details.

# SEE ALSO

**git(1)**, **syncthing(1)**
