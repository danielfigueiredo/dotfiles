#!/usr/bin/env bash

getGitDefaultBranch() (
  (git remote show origin || true) | sed -n '/HEAD branch/s/.*: //p'
)

branchAndOpenPR() (
  git checkout -b "${1}"
  git add .
  git commit -S -m "${2}"
  git push origin "${1}"
  gh pr create --web
)

checkoutDefaultBranch() (
  local defaultBranch
  defaultBranch=$(getGitDefaultBranch)

  git checkout "${defaultBranch}"
)

checkoutRemoteBranch() (
  local defaultBranch
  defaultBranch=$(getGitDefaultBranch)

  checkoutDefaultBranch
  git pull
  git checkout -b "${1}" "origin/${1}"
)

addCommitPush() (
  git add .
  git commit -S -m "$1"

  local branchName
  branchName="$(git rev-parse --abbrev-ref HEAD)"

  git push origin "${branchName}"
)

updateMainAndRebaseLastBranch() (
  local defaultBranch
  defaultBranch=$(getGitDefaultBranch)

  git checkout "${defaultBranch}"
  git pull origin "${defaultBranch}"
  git checkout -
  git rebase "${defaultBranch}"
)

cloneWSRepository() (
  if [[ ! -d ~/code/ws ]]; then
    mkdir ~/code/ws
  fi
  pushd ~/code/ws || exit

  gh repo clone "git@github.com:wealthsimple/${1}.git"

  popd || exit
)

stashPullPop() (
  git stash
  checkoutDefaultBranch
  git pull
  git stash pop
)
