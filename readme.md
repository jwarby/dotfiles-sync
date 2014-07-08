# Dotfiles

This repo is designed for keeping your personal dotfiles in sync between
different machines.  The core is composed of two bash scripts:

* install - makes a symbolic link to each one of it's sibling files inside the
user's home directory, prepending a dot to the filename
* update - performs a git pull to update the dotfiles, and re-runs the install
script.  Any errors are exported to ./error.log.

# Usage

Usage is simple.  Let's say you have a work machine and a home machine:

* First off, fork the repository.
* Then, clone your fork onto both machines (I like to clone to ~/dotfiles)
* Add your dotfiles into one of the clones, and run `./install` to create the
symbolic links in your home directory
* On the other machine's clone, run `./update`.  This will perform a `git pull`
to fetch your changes, and run `./install` to actually update your dotfiles.

You might also like to add a line to your `.bash_profile` (or equivalent) that
runs `./update`, so that you're always update when you log into one of your
machines and you don't have to remember to manually run the `update` script.

Of course, this doesn't have to be used to keep multiple machines up-to-date -
it's also a nice way of being able to very quickly get hold of your dotfiles on
a new machine - simply clone your repository, and run `./install`!
