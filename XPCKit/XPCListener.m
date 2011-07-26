//
//  XPCListener.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "XPCListener.h"
#import "XPCExtensions.h"

@interface XPCListener (Private) 
-(id)initWithConnection:(xpc_connection_t)connection;
@end

static XPCEventHandler sStaticEventHandler = NULL;

static void XPCListener_EventHandler(xpc_connection_t handler);
static void XPCListener_EventHandler(xpc_connection_t handler){
	XPCListener *listener = [[XPCListener alloc] initWithConnection:handler];
	[listener setEventHandler:^(NSDictionary *message, XPCConnection *connection){
		if(sStaticEventHandler){
			sStaticEventHandler(message, connection);
		}
	}];
}

@implementation XPCListener

+(void)listenForEventsWithHandler:(XPCEventHandler)eventHandler{
	if(!eventHandler) return;
	
	sStaticEventHandler = [eventHandler copy];
	xpc_main(XPCListener_EventHandler);
}

-(id)initWithConnection:(xpc_connection_t)connection{
	if(!connection){
		[self release];
		return nil;
	}
	
	if(self = [super init]){
		_connection = xpc_retain(connection);
		[self receiveConnection:_connection];
	}
	return self;
}

@end
