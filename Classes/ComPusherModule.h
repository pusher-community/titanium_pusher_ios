/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

#import "PTPusher.h"
#import "PTPusherAPI.h"
#import "PTPusherDelegate.h"

@interface ComPusherModule : TiModule <PTPusherDelegate> {
  PTPusher *pusher;
  PTPusherAPI *pusherAPI;
}

@property (nonatomic,readonly) PTPusher *pusher;
@property (nonatomic,readonly) PTPusherAPI *pusherAPI;

@end
