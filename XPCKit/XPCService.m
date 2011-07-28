//
//  XPCService.m
//  XPCKit
//
//  Created by Steve Streza on 7/27/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "XPCService.h"

static void XPCServiceConnectionHandler(xpc_connection_t handler);
static void XPCServiceConnectionHandler(xpc_connection_t handler){
	XPCConnection *connection = [[XPCConnection alloc] initWithConnection:handler];
	[[NSNotificationCenter defaultCenter] postNotificationName:XPCConnectionReceivedNotification object:connection];
	[connection release];
}

@implementation XPCService

@synthesize connectionHandler, connections=_connections;

-(id)initWithConnectionHandler:(XPCConnectionHandler)aConnectionHandler
{
    self = [super init];
    if (self) {
        // Initialization code here.
		self.connectionHandler = aConnectionHandler;
		[[NSNotificationCenter defaultCenter] addObserverForName:XPCConnectionReceivedNotification
														  object:nil 
														   queue:[NSOperationQueue mainQueue]
													  usingBlock:^(NSNotification *note) {
														  XPCConnection *connection = [note object];
														  [self handleConnection:connection];
													  }];
    }
    
    return self;
}

-(void)run{
	xpc_main(XPCServiceConnectionHandler);
}

-(void)handleConnection:(XPCConnection *)connection{
	if(!_connections){
		_connections = [[NSMutableArray alloc] init];
	}

	[(NSMutableArray *)self.connections addObject:connection];
	
//	[connection _sendLog:@"We got a connection"];
	
	if(self.connectionHandler){
		self.connectionHandler(connection);
	}
}

+(void)runServiceWithConnectionHandler:(XPCConnectionHandler)connectionHandler{
	XPCService *service = [[XPCService alloc] initWithConnectionHandler:connectionHandler];
	
	[service run];
	
	[service release];
}

@end
