//
//  XPCListener.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "XPCConnection.h"

@interface XPCListener : XPCConnection

+(void)listenForEventsWithHandler:(XPCEventHandler)eventHandler;

@end
