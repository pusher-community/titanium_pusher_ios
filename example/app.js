// Initialization

var Pusher = require('com.pusher');
Pusher.setup({
  key: '437c8bf5d9d5529460e9',     // CHANGEME
  appID: '1305',                   // CHANGEME
  secret: '0750515631c6e8300b03',  // CHANGEME
  reconnectAutomaticaly: true
});

var navigationWindow = Ti.UI.createWindow();

var window = Ti.UI.createWindow({
	backgroundColor:'white',
  title: 'Pusher'
});

var nav = Ti.UI.iPhone.createNavigationGroup({
  window: window
});
navigationWindow.add(nav);
navigationWindow.open();

// Handlers
var handleConnected = function() {
  connect_button.enabled = false;
  add_message_button.enabled = true;

  Pusher.addEventListener('connected', function(e) {
    Ti.API.warn("PUSHER CONNECTED");
    connect_button.title = 'Disconnect';
    connect_button.enabled = true;

    // Connect to channel
    window.channel = Pusher.subscribeChannel('test');

    // Bind to all events on this channel
    window.channel.addEventListener('event', handleEvent);

    // Bind to a specific event on this channel
    window.channel.addEventListener('alert', handleAlertEvent);
  });
  Pusher.connect();
};

var handleDisconnected = function() {
  connect_button.title = 'Connect';
  add_message_button.enabled = false;

  if(window.channel) {
    window.channel.removeEventListener('event', handleEvent);
    window.channel.removeEventListener('alert', handleAlertEvent);
  }

  Pusher.disconnect();
}

var handleEvent = function(e) {
  var label = Ti.UI.createLabel({
    text: "channel:" + e.channel + " event: " + e.name,
    top: 3,
    left: 10,
    height: '20',
    font: {fontSize: 20}
  });

  var sublabel = Ti.UI.createLabel({
    text: JSON.stringify(e.data),
    top: 25,
    left: 10,
    height: '12',
    font: {fontSize:12}
  });

  var tableViewRow = Ti.UI.createTableViewRow({});
  tableViewRow.add(label);
  tableViewRow.add(sublabel);

  tableview.appendRow(tableViewRow, {animated:true});
};

var handleAlertEvent = function(e) {
  alert(JSON.stringify(e.data));
}

var connect_button = Ti.UI.createButton({
  title: 'Connect'
});
connect_button.addEventListener('click', function(e) {
  if(connect_button.title == 'Connect')
    handleConnected();
  else
    handleDisconnected();
});
window.leftNavButton = connect_button;

var add_message_button = Ti.UI.createButton({
  title: 'Add',
  enabled: false
});
add_message_button.addEventListener('click', function(e) {
  var new_window = Ti.UI.createWindow({
    url: 'channel.js',
    backgroundColor: 'white',
    title: 'Send event to channel'
  });
  new_window.pusher = Pusher;
  nav.open(new_window, {animated:true});
});
window.rightNavButton = add_message_button;

var tableview = Ti.UI.createTableView({
  data: [],
  headerTitle: 'Send events to the test channel'
});
window.add(tableview);

