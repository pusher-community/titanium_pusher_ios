//
//  ComPusherPusherChannelProxy.m
//  pusher
//
//  Created by Ruben Fonseca on 02/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ComPusherChannelProxy.h"

#import "TiUtils.h"

@implementation ComPusherChannelProxy

-(void)dealloc {
  RELEASE_TO_NIL(pusherModule)
  RELEASE_TO_NIL(channel)
  [super dealloc];
}

-(void)_configureWithPusher:(ComPusherModule *)aPusherModule andChannel:(NSString *)aChannel {
  RELEASE_TO_NIL(pusherModule)
  pusherModule = [aPusherModule retain];
  
  [channel release];
  channel = [aChannel retain];
}

-(void)_subscribe {
  // Subscribe the channel!
  ENSURE_UI_THREAD_0_ARGS
  pusherChannel = [pusherModule.pusher subscribeToChannelNamed:channel];
  [pusherChannel retain];
}

#pragma mark Methods
-(void)unsubscribe:(id)args {
  [pusherModule unsubscribeChannel:channel];
}

-(void)sendEvent:(id)args {
  ENSURE_UI_THREAD_1_ARG(args)
  
  enum Args {
    kArgName = 0,
    kArgData,
    kArgCount
  };
  
  ENSURE_ARG_COUNT(args, kArgCount);
  NSString *eventName = [TiUtils stringValue:[args objectAtIndex:kArgName]];
  NSDictionary *data  = [args objectAtIndex:kArgData];
  
  if(pusherModule.pusherAPI)
		[pusherModule.pusherAPI triggerEvent:eventName onChannel:channel data:data socketID:pusherModule.pusher.connection.socketID];
  else
    [self throwException:@"PusherAPI is not initialized" subreason:@"Please call the setup method with both the appID and the secret" location:CODELOCATION];
}

#pragma mark Listeners
-(void)_listenerAdded:(NSString *)type count:(int)count {
  if(count == 1) {
    [self performSelectorOnMainThread:@selector(_bindToEvent:) withObject:type waitUntilDone:YES];
  }
}

-(void)_bindToEvent:(NSString*)type {
  [pusherChannel bindToEventNamed:type target:self action:@selector(handleEvent:)];
}

-(void)handleEvent:(PTPusherEvent *)pusher_event {
  NSMutableDictionary *event = [NSMutableDictionary dictionary];
  [event setValue:NULL_IF_NIL(pusher_event.channel) forKey:@"channel"];
  [event setValue:NULL_IF_NIL(pusher_event.name) forKey:@"name"];
  [event setValue:NULL_IF_NIL(pusher_event.data) forKey:@"data"];
  
  [self fireEvent:pusher_event.name withObject:event];
}

@end
