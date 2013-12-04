git bzr-remote
==============

Bi-directional git <-> bzr merging plugin for git.

## Feature

- merging in both direction
- support filter to merge only a part of the source, specified by a wildcard
- keep history (only in bzr to git direction)

## Limitations

- you can't have a git branch with the same name than the bzr branch (`git-remote-bzr` failed to push to bzr if
git/bzr branches are not the same)
- from bzr to git, history is preserved but not from git to bzr (`git-remote-bzr` "supposed" limitation)

## Story

Note: this is the "Why" I did this plugin, but you can benefit from it in other situations.

This plugin has been created to help merging GitHub OpenERP modules into Launchpad branches.

Branches on Launchpad OpenERP "official" community projects are not always organized like on GitHub,
so we need a workaround to sync OpenERP modules between CVS repositories.

### different organization

- usually on GitHub: 1 module = 1 repo
- on Launchpad: bunch of modules = 1 repo

Because of this situation, merge are not easy but possible by using `git fast-export` feature to
get only modules we want to sync and `git-remote-bzr` to pull/push from Bazaar repositories.

## Installation

Copy to your ~/bin, or anywhere in your $PATH.

Please check also the [dependencies section](#dependencies).

## Usage

Note: only tested with local bzr repository for now

**pull**

```
$ cd /path/to/git-repo
$ git bzr-merge pull --remember --filter moduleA /path/to/bzr-repo bzr-branch
then later...
$ git bzr-merge pull
```

**push**

```
$ cd /path/to/git-repo
$ git bzr-merge push --remember --filter moduleA /path/to/bzr-repo bzr-branch
then later...
$ git bzr-merge push
```

**help**

```
$ git bzr-merge pull --help
usage: pull [-h] [--remember] [-m MESSAGE] [-r REMOTE_NAME] [-f FILTER]
            [-t TMP_BRANCH]
            repository branch

Pull from a bzr branch into working git branch

positional arguments:
  repository            bzr repository path (lp, ssh, folder)
  branch                bzr branch name

optional arguments:
  -h, --help            show this help message and exit
  --remember            remember parameters (saved by git remote)
  -m MESSAGE, --message MESSAGE
                        merge message
  -r REMOTE_NAME, --remote-name REMOTE_NAME
                        bzr remote name
  -f FILTER, --filter FILTER
                        source filter, support wildcard
  -t TMP_BRANCH, --tmp-branch TMP_BRANCH
                        temporary branch used for filtered merging
```

## Details

Steps described are for a filtered merge but it's optional and merge can be done directly from/to the bzr branch
and the git branch.
However the command without the filter is not so useful cause it's easy to use git-remote-bzr directly
and merge branches manually.

### git to bzr

1. 2 cases
  1.  create a git branch based on bzr target branch (use git-remote-bzr)
  2. already exist, pull bzr sources
2. export the current filtered git branch to a tmp branch
3. merge the tmp branch with the bzr branch
4. push back on bzr
5. remove the tmp branch

**Usage**

```
git bzr-merge push bzr-repository bzr-branch [-m 'merge message'] [--filter source_wildcard]  [--tmp-branch tmp_branch]  [--remote-name bzr_remote]
```

### bzr to git

1. 2 cases
  1. create a git branch based on bzr target branch (use git-remote-bzr)
  2. already exist, pull bzr sources
2. export the filtered bzr branch to a tmp branch
3. merge the tmp branch with the current git branch
4. remove the tmp branch

**Usage**

```
git bzr-pull push bzr-repository bzr-branch [-m 'merge message'] [--filter source_wildcard]  [--tmp-branch tmp_branch] [--remote-name bzr_remote]
```

## Unit Tests

Unit Tested with [bats](https://github.com/sstephenson/bats/).

**Execute test suite**

```
$ bats tests
 ✓ multiple pull without filter
 ✓ multiple pull without filter (remember)
 ✓ multiple pull with filter
 ✓ multiple pull with filter (remember)
 ✓ multiple pull with wildcard filter
 ✓ multiple push without filter
 ✓ multiple push without filter (remember)
 ✓ multiple push with filter
 ✓ multiple push with filter (remember)
 ✓ multiple push with wildcard filter

10 tests, 0 failures
```

## Dependencies

- git >= 1.8.x, should work with lower version too
- bzr >= 2.6.x, required: **doesn't work on 2.5.1**
- bzrlib >= 2.6.x, installable with `sudo apt-get install python-bzrlib`
- [git-remote-bzr](https://github.com/felipec/git/blob/fc/master/git-remote-bzr.py)
- for unit tests: [bats](https://github.com/sstephenson/bats/)

## Contribution

- Created by Michel Meyer
- Inspired by:
  - [git-bzr](https://github.com/termie/git-bzr-ng/blob/master/git-bzr)
  - [git-remote-bzr](https://github.com/felipec/git/blob/fc/master/git-remote-bzr.py)
- Thanks to Raphaël Valyi (from the openerp community) for his ideas and help

