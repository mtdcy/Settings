#!/bin/bash 

# Install command-line tools using Homebrew.

source cbox.sh 

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install brew
which brew > /dev/null 
if [ $? -ne 0 ]; then 
info "Install brew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap Homebrew/dupes
else
info "Update brew..."
# Make sure we’re using the latest Homebrew.
#brew update

# Upgrade any already-installed formulae.
#brew upgrade 
fi

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed 

# Install `wget` with IRI support.
brew install wget 

# Install MacVim 
brew install MacVim 

# Install binutils 
brew install binutils

brew install git 
brew install lua
brew install p7zip
brew install tree
brew install grep 
brew install make   # Android need gmake
brew install gnupg

# Develop libraries 
#brew install sdl
#brew install zlib

# Remove outdated versions from the cellar.
brew cleanup
