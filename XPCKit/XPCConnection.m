//
//  XPCConnection.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "XPCConnection.h"
#import <xpc/xpc.h>
#import "NSObject+XPCParse.h"
#import "NSDictionary+XPCParse.h"

@implementation XPCConnection

@synthesize name=_name, eventHandler=_eventHandler;

- (id)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        // Initialization code here.
        _name = [name copy];
    }
    
    return self;
}

-(void)createConnectionIfNecessary{
    if(!_connection){
        _connection = xpc_connection_create([self.name cStringUsingEncoding:NSUTF8StringEncoding], NULL);
        
        __block XPCConnection *this = self;
        xpc_connection_set_event_handler(_connection, ^(xpc_object_t object){
            NSLog(@"Event handler");
            if (object == XPC_ERROR_CONNECTION_INTERRUPTED){
                NSLog(@"XPC_ERROR_CONNECTION_INTERRUPTED");
            }else if (object == XPC_ERROR_CONNECTION_INVALID){    
                NSLog(@"XPC_ERROR_CONNECTION_INVALID");
            }else if (object == XPC_ERROR_KEY_DESCRIPTION){
                NSLog(@"XPC_ERROR_KEY_DESCRIPTION");
            }else if (object == XPC_ERROR_TERMINATION_IMMINENT){
                NSLog(@"XPC_ERROR_TERMINATION_IMMINENT");   
            }else{
                id message = [NSObject objectWithXPCObject: object];
                if(this.eventHandler){
                    this.eventHandler(message);
                }
            }
        });
        
        xpc_connection_resume(_connection);

    }
}

-(void)sendMessage:(NSDictionary *)dictMessage{
    [self createConnectionIfNecessary];
    
	if(![dictMessage isKindOfClass:[NSDictionary class]]){
		dictMessage = [NSDictionary dictionaryWithObject:dictMessage forKey:@"contents"];
	}

	xpc_object_t message = NULL;

	NSDate *date = [NSDate date];
	message = [dictMessage newXPCObject];
	NSLog(@"Message encoding took %gs on average", [[NSDate date] timeIntervalSinceDate:date] / 1000.);
    
	xpc_connection_send_message(_connection, message);
    xpc_release(message);
}

@end

/*

 xpc_connection_set_event_handler(connection,
 ^(xpc_object_t object)
 {
 NSLog(@"Event Handler");
 
 xpc_type_t type = xpc_get_type(object);
 if(type == XPC_TYPE_DICTIONARY){
 NSLog(@"We got a message! %s", xpc_dictionary_get_string(object, "message"));;
 return;
 }
 if (object == XPC_ERROR_CONNECTION_INTERRUPTED)
 {
 NSLog(@"XPC_ERROR_CONNECTION_INTERRUPTED");
 }
 if (object == XPC_ERROR_CONNECTION_INVALID)
 {    
 NSLog(@"XPC_ERROR_CONNECTION_INVALID");
 }
 if (object == XPC_ERROR_KEY_DESCRIPTION)
 {
 NSLog(@"XPC_ERROR_KEY_DESCRIPTION");
 }
 if (object == XPC_ERROR_TERMINATION_IMMINENT)
 {
 NSLog(@"XPC_ERROR_TERMINATION_IMMINENT");   
 }
 
 });
 


*/