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
@property (nonatomic, copy) NSString *serviceName;
-(id)initWithConnection:(xpc_connection_t)connection;
@end

static void XPCListener_EventHandler(xpc_connection_t handler);
static void XPCListener_EventHandler(xpc_connection_t handler){
	XPCListener *listener = [[XPCListener alloc] initWithConnection:handler];
	[listener setEventHandler:[[^(NSDictionary *message){
		[listener sendMessage:(NSDictionary *)[NSString stringWithFormat:@"Hello there! You sent %i items.", [(NSArray *)[message objectForKey:@"contents"] count]]];
	} copy] autorelease]];
}

@implementation XPCListener

+(void)listenForEvents{
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
