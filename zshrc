#!/usr/bin/env bash

getGitDefaultBranch() (
  git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
)

branchAndOpenPR() (
  set -e

  git checkout -b $1
  git add .
  git commit -m "$2"
  git push origin $
  gh pr create --web

  set +e
)


addCommitPush() (
  set -e

  git add .
  git commit -m "$1"
  git push origin "$(git rev-parse --abbrev-ref HEAD)"

  set +e
)

updateMainAndRebaseLastBranch() (
  set -e

  git checkout $(getGitDefaultBranch)
  git pull
  git checkout -
  git rebase $(getGitDefaultBranch)

  set +e
)
