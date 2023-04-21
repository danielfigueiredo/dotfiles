#!/usr/bin/env bash

getGitDefaultBranch() (
  (git symbolic-ref refs/remotes/origin/HEAD || true) | sed 's@^refs/remotes/origin/@@'
)

branchAndOpenPR() (
  set -e

  git checkout -b "${1}"
  git add .
  git commit -m "${2}"
  git push origin "${1}"
  gh pr create --web

  set +e
)


addCommitPush() (
  set -e

  git add .
  git commit -m "$1"

  local branchName
  branchName="$(git rev-parse --abbrev-ref HEAD)"

  git push origin "${branchName}"

  set +e
)

updateMainAndRebaseLastBranch() (
  local defaultBranch
  defaultBranch="$(set -e getGitDefaultBranch)"

  git checkout "${defaultBranch}"
  git pull
  git checkout -
  git rebase "${defaultBranch}"
)
