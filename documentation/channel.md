# Channel

## Description

This class encapsulates the behaviour on a subscribed message.

## Reference

### channel.unsubscribe()

Unsubscribes from the channel. After this you should not receive any more
event on this channel.

Example:

    channel.unsubscribe();

### channel.sendEvent(eventName, data)

Sends an event to this channel.

- **eventName** [string, required] is the name of the event to fire
- **data** [dictionary, required] is the payload you want to send with the message

Example:

    channel.sendEvent('eventname', {foo: 'bar', zbr: 123});

Please notice that, to use this method, you have to provide both the **appID**
and the **secret** on the Pusher.configure() function. Please refer to the 
documentation of that function [here](index.html).

### channel.addEventListener(eventName, callback)

Binds to an event on this channel. You should enter the event name as the first
argument, and a callback function on the second argument.

The event parameter passed on the callback function as the following three
properties defined:

- **name** [string]: the name of the event
- **channel** [string]: the name of the channel where the event was fired
- **data** [dictionary]: the payload of the message, already parsed and ready
  to use

Example:

    channel.addEventListener('testingevent', function(e) {
      Ti.API.warn("RECEIVED EVENT DATA: " + e.data);
    });

Please notice that to stop receiving events on that callback, you should
use the standard `removeEventListener` function.

## Events

### event

If you bind the event named 'event' you will automatically receive all
the events that your device receives **on this channel**, regardless of the event name.
Useful for debugging purposes.

## Example

See the `example/app.js` provided with this module.

