# Pusher Titanium Mobile Module for iOS

This is the Pusher module for Titanium Mobile applications on iOS.

Please check the documentation folder for instructions on how to use it.

You should also download the latest version of the module and follow
the instructions here to install http://wiki.appcelerator.org/display/tis/Using+Titanium+Modules

## Building

Before you can build the module, you have to install the Pods from Podfile 
(powered by Cocoapods). To do that, open the terminal inside the project
and enter:

    $ sudo gem install cocoapods
    $ pod install

This will create a new directory `Pods` inside your project, with all the
project dependencies.

Then, assuming you have the latest Titanium Mobile, Xcode (currently 4.4) and
the iOS SDK (currently 5.0), you can build simply by entering

    $ ./build.py

You can also run the included example app by entering,

    $ titanium run
