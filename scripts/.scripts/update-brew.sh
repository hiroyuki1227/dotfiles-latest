# !/usr/bin/env bash
#
echo "Updating Homebrew..."
brew update --force --quiet

echo "Upgrading all formula in Homebrew..."
brew upgrade

echo "Upgrading all casks (force refresh)"
brew outdated --cask --greedy | xargs - I{} brew upgrade --cask --greedy -- force {}

echo "Cleaing old versions"
brew cleanup -s

echo "Doctor check"
brew doctor

echo "Done"
