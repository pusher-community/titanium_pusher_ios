var window = Ti.UI.currentWindow;
var Pusher = window.pusher;

var eventNameField = Ti.UI.createTextField({
  hintText: 'Event Name',
  top: 10,
  left: 10,
  right: 10,
  height: 40,
  borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED,
  width: 300
});
window.add(eventNameField);

var channelNameField = Ti.UI.createTextField({
  hintText: 'Channel name',
  top: 50,
  left: 10,
  right: 10,
  height: 40,
  borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED,
  width: 300
});
window.add(channelNameField);

var dataField = Ti.UI.createTextField({
  hintText: 'JSON String',
  top: 90,
  left: 10,
  right: 10,
  height: 40,
  borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED,
  width: 300
});
window.add(dataField);

var submitButton = Ti.UI.createButton({
  title: 'Send',
  top: 150,
  left: 10,
  right: 10,
  width: 300,
  height: 60
});
window.add(submitButton);

submitButton.addEventListener('click', function(e) {
  var event = eventNameField.value;
  var channel = channelNameField.value;
  var data = dataField.value;

  if(!event || !channel || !data) {
    alert("All fields required");
    return;
  }

  try {
    JSON.parse(data);
  } catch(e) {
    alert("Please enter invalid JSON");
    return;
  }

  Pusher.sendEvent(event, channel, data);
  alert("Sent :)");
});
