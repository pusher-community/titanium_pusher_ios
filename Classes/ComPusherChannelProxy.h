//
//  ComPusherPusherChannelProxy.h
//  pusher
//
//  Created by Ruben Fonseca on 02/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TiProxy.h"

#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherEvent.h"

#import "ComPusherModule.h"

@interface ComPusherChannelProxy : TiProxy {
  ComPusherModule *pusherModule;
  
  NSString *channel;
  PTPusherChannel *pusherChannel;
}

-(void)_configureWithPusher:(ComPusherModule *)pusher andChannel:(NSString *)channel;
-(void)_subscribe;

@end
