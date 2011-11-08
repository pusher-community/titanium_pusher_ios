# pusher Module

## Description

This module allows you to tap into the [pusher](http://pusher.com)
service directly into your Titanium Mobile applications.

## Installation

Please follow the guide [here](http://wiki.appcelerator.org/display/tis/Using+Titanium+Modules).

## Changelog

Please see the [changelog file](changelog.html).

## Accessing the pusher Module

To access this module from JavaScript, you would do the following:

	var Pusher = require("com.pusher");

The Pusher variable is a reference to the Module object.	

## Reference

### Pusher.setup({...})

This should be the first function you should call on the module, and it will
configure the Pusher module with the appropriate credentials. It accepts
a single argument with a dictionary of the following arguments:

- **key** [string, required]: The Pusher key credential for your application
- **appID** [string, optional]: The Pusher appID. Only required if you want
  to send events to channels
- **secret** [string, optional]: The Pusher secret. Only required if you want
  to send events to channels
- **reconnectAutomatically** [boolean, optional]: Set to `false` if you don't
  want the module to automatically reconnect to the Pusher servers when
  the connection goes down. Default value is `true`
- **reconnectDelay** [integer, optional]: The number of seconds this module will
  wait before it tries to reconnect with the Pusher servers. Default value is
  5 seconds

Example:

    Pusher.configure({
      key: 'your key',
      appID: 'your app ID',
      secret: 'your secret',
      reconnectAutomatically: true,
      reconnectDelay: 5
    });

### Pusher.connect()

Initiate the connection with the Pusher servers. Please notice that the 
connection doesn't become immediately ready! You should wait for the
"connected" event (see below) before you start subscribing and/or sending
messages to Pusher.

Example:

    Pusher.connect();

### Pusher.disconnect()

Manually disconnects from the Pusher server.

Example:

    Pusher.disconnect();

### Pusher.subscribeChannel(channelName)

Subscribes to a channel. The first and only argument is a String, required,
and corresponds to the channel name you want to subscribe.

Example:

    var channel = Pusher.subscribeChannel('test');

Please notice that this method returns a `Channel` object. For more 
information about that object see the [Channel documentation](channel.html).

### Pusher.addEventListener('event', callback);

If you want to bind to an event, regardless of the channel, you should
use this function. You enter the event name as the first argument, and
a callback function on the second argument.

The event parameter passed on the callback function as the following three
properties defined:

- **name** [string]: the name of the event
- **channel** [string]: the name of the channel where the event was fired
- **data** [dictionary]: the payload of the message, already parsed and ready
  to use

Example:

    Pusher.addEventListener('testingevent', function(e) {
      Ti.API.warn("Received test event on channel " + e.channel);
      Ti.API.warn("DATA: " + e.data);
    });

Please notice that to stop receiving events on that callback, you should
use the standard `removeEventListener` function.


### Pusher.sendEvent(eventName, channelName, data)

Sends an event to a channel.

- **eventName** [string, required] is the name of the event to fire
- **channelName** [string, required] is the name of channel to send the event
- **data** [dictionary, required] is the payload you want to send with the message

Example:

    Pusher.sendEvent('eventname', 'test', {foo: 'bar', zbr: 123});

Please notice that, to use this method, you have to provide both the **appID**
and the **secret** on the configure function above.

## Events

### connected

Fired when the Pusher module successfully connects and handshakes with the
Pusher servers.

### disconnected

Fired when Pusher disconnects from the server. If `reconnectAutomatically` was
`true`, Pusher will automatically try to call the server again.

### event

If you bind the event named 'event' you will automatically receive all
the events that your device receives, regardless of the event name or the
channel where it was fired. Useful for debugging purposes.

## Usage

Please see the `example/app.js` file included with this module.

## Author

Ruben Fonseca <fonseka@gmail.com>
