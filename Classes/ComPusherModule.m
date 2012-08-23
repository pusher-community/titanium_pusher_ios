/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComPusherModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "PTPusherEvent.h"

#import "ComPusherChannelProxy.h"

@implementation ComPusherModule

@synthesize pusher, pusherAPI;

#pragma mark Internal
-(id)init {
  if(self = [super init]) {
    channels = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:PTPusherEventReceivedNotification object:pusher];
  
  RELEASE_TO_NIL(pusher);
  RELEASE_TO_NIL(pusherAPI);
  RELEASE_TO_NIL(channels);
  [super dealloc];
}

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"a1418c5f-8015-41c2-8229-51bd7148436d";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.pusher.pusher";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

#pragma Public APIs
-(void)setup:(id)args {
  ENSURE_UI_THREAD_1_ARG(args)
  ENSURE_SINGLE_ARG(args, NSDictionary);
  
  NSString *key = [TiUtils stringValue:@"key" properties:args];
  BOOL reconnectAutomaticaly = [TiUtils boolValue:@"reconnectAutomaticaly" properties:args def:YES];
	BOOL encrypted = [TiUtils boolValue:@"encrypted" properties:args def:YES];
  NSTimeInterval reconnectDelay = [TiUtils intValue:@"reconnectDelay" properties:args def:5];
  
  if(pusher) {
    [pusher disconnect];
    RELEASE_TO_NIL(pusher);
  }
  
  pusher = [PTPusher pusherWithKey:key connectAutomatically:NO encrypted:encrypted];
  pusher.reconnectAutomatically = reconnectAutomaticaly;
  pusher.reconnectDelay = reconnectDelay;
  pusher.delegate = self;
  [pusher retain];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePusherEvent:) name:PTPusherEventReceivedNotification object:pusher];
  
  NSString *appID = [TiUtils stringValue:@"appID" properties:args];
  NSString *secret = [TiUtils stringValue:@"secret" properties:args];
  if(appID && secret) {
    if(pusherAPI) RELEASE_TO_NIL(pusherAPI);
    
    pusherAPI = [[PTPusherAPI alloc] initWithKey:key appID:appID secretKey:secret];
  }
}

-(void)connect:(id)args {
  ENSURE_UI_THREAD_0_ARGS
  [pusher connect];
}

-(void)disconnect:(id)args {
  ENSURE_UI_THREAD_0_ARGS
  [pusher disconnect];
}

-(id)subscribeChannel:(id)args {
  ENSURE_SINGLE_ARG(args, NSString)
  NSString *channel = args;
  
  ComPusherChannelProxy *channel_object = [[ComPusherChannelProxy alloc] _initWithPageContext:[self executionContext]];
  [channel_object _configureWithPusher:self andChannel:channel];
  [channel_object _subscribe];
  
  if(![channels valueForKey:channel])
    [channels setValue:[[NSMutableSet alloc] init] forKey:channel];
  
  [[channels valueForKey:channel] addObject:channel_object];
  
  return channel_object;
}

-(void)unsubscribeChannel:(id)args {
  ENSURE_SINGLE_ARG(args, NSString)
  NSString *channel = args;
  
  if([pusher channelNamed:channel]) {
    [pusher unsubscribeFromChannel:[pusher channelNamed:channel]];
  }
  
  [channels removeObjectForKey:channel];
}

-(void)sendEvent:(id)args {
  ENSURE_UI_THREAD_1_ARG(args)
  
  enum Args {
    kArgName = 0,
    kArgChannel,
    kArgData,
    kArgCount
  };
  
  ENSURE_ARG_COUNT(args, kArgCount);
  NSString *eventName = [TiUtils stringValue:[args objectAtIndex:kArgName]];
  NSString *channelName = [TiUtils stringValue:[args objectAtIndex:kArgChannel]];
  NSDictionary *data  = [args objectAtIndex:kArgData];
  
  if(pusherAPI)
		[pusherAPI triggerEvent:eventName onChannel:channelName data:data socketID:pusher.connection.socketID];
  else
    [self throwException:@"PusherAPI is not initialized" subreason:@"Please call the setup method with both the appID and the secret" location:CODELOCATION];
}

#pragma mark Notifications
- (void)handlePusherEvent:(NSNotification *)note {
  PTPusherEvent *pusher_event = [note.userInfo objectForKey:PTPusherEventUserInfoKey];
  
  NSMutableDictionary *event = [NSMutableDictionary dictionary];
  [event setValue:NULL_IF_NIL(pusher_event.channel) forKey:@"channel"];
  [event setValue:NULL_IF_NIL(pusher_event.name) forKey:@"name"];
  [event setValue:NULL_IF_NIL(pusher_event.data) forKey:@"data"];
  
  for(ComPusherChannelProxy *proxy in [channels valueForKey:pusher_event.channel]) {
    if([proxy _hasListeners:@"event"])
      [proxy fireEvent:@"event" withObject:event];
  }
  
  if([self _hasListeners:@"event"])
    [self fireEvent:@"event" withObject:event];
}

#pragma mark Listeners
-(void)_listenerAdded:(NSString *)type count:(int)count {
  if(count == 1) {
    [self performSelectorOnMainThread:@selector(_bindEvent:) withObject:type waitUntilDone:YES];
  }
}

-(void)_bindEvent:(NSString*)type {
  [pusher bindToEventNamed:type target:self action:@selector(handleNewEvent:)];
}

-(void)handleNewEvent:(PTPusherEvent *)event {
  if([self _hasListeners:event.name]) {
    [self fireEvent:event.name withObject:event.data];
  }
}

#pragma mark PTPusherDelegate methods
- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection {
  [self fireEvent:@"connected" withObject:nil];
}

- (void)pusher:(PTPusher *)pusher connectionDidDisconnect:(PTPusherConnection *)connection {
  [self fireEvent:@"disconnected" withObject:nil];
}

@end
