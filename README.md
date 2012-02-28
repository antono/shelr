# Shelr -- screencasting for [shell ninjas][TV].

## Installation

### From gem

You'll need ruby and rubygems installed.

    gem install shelr

See [shellcast](http://shelr.tv/records/4f49ea4ae557800001000004) for details :)

### From packages

#### Debian/Ubuntu

PPA: https://launchpad.net/~antono/+archive/shelr

#### Archlinux

PKGBUILD: https://aur.archlinux.org/packages.php?ID=56945

## Watching other's records

   shelr play http://shelr.tv/records/4d1c5458905ba77eb7000002

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

You need `script` and `scriptreplay` tools from BSD Utils.
Tey are already installed if You use Debian/Ubuntu/BSD variants.
Not sure about other OSes.

## Copyright

Copyright (c) 2010, 2011, 2012 Antono Vasiljev. See LICENSE.txt for details.

[![endorse](http://api.coderwall.com/antono/endorsecount.png)](http://coderwall.com/antono)

[TV]: http://shelr.tv/ "Shellcasts from shell ninjas"
