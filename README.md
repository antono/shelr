# Shelr -- [tool for terminal screencasting][TV].

[![Build Status](https://secure.travis-ci.org/antono/shelr.png?branch=master)](http://travis-ci.org/antono/shelr)

`shelr` allows you to record/replay and publish your terminal on [http://shelr.tv](http://shelr.tv).
[Code for Shelr.tv](https://github.com/antono/shelr.tv) service is also available on github.


## Installation

### From gem

You'll need ruby and rubygems installed.

    gem install shelr

See [shellcast](http://shelr.tv/records/4f49ea4ae557800001000004) for details :)

### From packages

- [PPA](https://launchpad.net/~antono/+archive/shelr) for Debian/Ubuntu
- [PKGBUILD](https://aur.archlinux.org/packages.php?ID=56945) for Arch Linux
- [EBUILD](http://overlays.gentoo.org/proj/sunrise/browser/app-misc/shelr) for Gentoo Linux

## Watching other's records

    shelr play http://shelr.tv/records/4f4ca2a43cd1090001000002.json

You can watch them online at [http://shelr.tv/][TV]

## Recording

    shelr record
    ...
    do something in your shell
    ..
    exit

## Publishing

    shelr list
    <select id of your record>
    shelr push <ID>

## Dependencies

### Linux/BSD/Hurd/etc...

You need `script` and `scriptreplay` tools from BSD Utils.
Tey are already installed if You use Debian/Ubuntu/BSD variants.

### OSX

If You use OS X - install `ttyrec` via homebrew and setup it as recording backend.

     brew install ttyrec
     shelr backend ttyrec
     
Also put the scriptreplay script somewhere in your PATH, e.g. /usr/local/bin

    curl https://raw.github.com/gist/2343833/0287752171cb045205e88664a32f63bf3a45565f/scriptreplay > /usr/local/bin/scriptreplay
    chmod +x /usr/local/bin/scriptreplay

## Copyright

(Э) 2010, 2011, 2012 Antono Vasiljev and
[contributors](https://github.com/antono/shelr/contributors).

See LICENSE.txt for details.

[![endorse](http://api.coderwall.com/antono/endorsecount.png)](http://coderwall.com/antono)

[TV]: http://shelr.tv/ "Shellcasts from shell ninjas"
