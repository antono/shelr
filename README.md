# Shelr -- screencasting for [shell ninjas](TV).

## Installation

You'll need ruby and rubygems installed.

    gem install shelr

See [shellcast](http://shelr.tv/records/4d1c5458905ba77eb7000002) for details :)

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

Copyright (c) 2010 Antono Vasiljev. See LICENSE.txt for further details.

[TV]: http://shelr.tv/ "Shell records from shell ninjas"
