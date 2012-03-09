# Shelr -- screencasting for [shell ninjas][TV].

## Installation

### From gem

You'll need ruby and rubygems installed.

    gem install shelr

See [shellcast](http://shelr.tv/records/4f49ea4ae557800001000004) for details :)

### From packages

- [PPA](https://launchpad.net/~antono/+archive/shelr) for Debian/Ubuntu
- [PKGBUILD](https://aur.archlinux.org/packages.php?ID=56945) for Arch Linux

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

## Copyright

(Э) 2010, 2011, 2012 Antono Vasiljev and
[contributors](https://github.com/antono/shelr/contributors).

See LICENSE.txt for details.

[![endorse](http://api.coderwall.com/antono/endorsecount.png)](http://coderwall.com/antono)

[TV]: http://shelr.tv/ "Shellcasts from shell ninjas"
