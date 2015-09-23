# Cocoapods::Depend

CocoaPods Plugin which allows to quickly manage your Podfile

## Installation

    $ gem install cocoapods-depend

## Usage

Show podspec dependencies like this:

    pod depend list

Add a podspec dependency like this:

    pod depend add AFNetworking

Add a podspec dependency to a specific target like this:

    pod depend add KIF --target=UITest

Remove a podspec dependency like this:

    pod depend remove AFNetworking

