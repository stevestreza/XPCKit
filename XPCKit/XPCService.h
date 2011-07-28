//
//  XPCService.h
//  XPCKit
//
//  Created by Steve Streza on 7/27/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPCTypes.h"
#import "XPCConnection.h"

@interface XPCService : NSObject

@property (nonatomic, copy) XPCConnectionHandler connectionHandler;
@property (nonatomic, readonly) NSArray *connections;

+(void)runServiceWithConnectionHandler:(XPCConnectionHandler)connectionHandler;
-(id)initWithConnectionHandler:(XPCConnectionHandler)connectionHandler;

-(void)handleConnection:(XPCConnection *)connection;

-(void)run;

@end

// You can supply this as the parameter to xpc_main (but you might as
// well just call +[XPService runServiceWithConnectionHandler:])
static void XPCServiceConnectionHandler(xpc_connection_t handler);