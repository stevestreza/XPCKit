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

@synthesize serviceName=_serviceName, eventHandler=_eventHandler;

- (id)initWithServiceName:(NSString *)serviceName{
    self = [super init];
    if (self) {
        // Initialization code here.
		_connection  = NULL;
        _serviceName = [serviceName copy];
    }
    
    return self;
}

-(void)dealloc{
	[_serviceName release], _serviceName = nil;
	
	if(_connection){
		xpc_connection_cancel(_connection);
		xpc_release(_connection);
		_connection = NULL;
	}
	
	[super dealloc];
}

-(void)createConnectionIfNecessary{
    if(!_connection){
        _connection = xpc_connection_create([self.serviceName cStringUsingEncoding:NSUTF8StringEncoding], NULL);
		[self receiveConnection:_connection];
	}
};

-(void)receiveConnection:(xpc_connection_t)connection{
    __block XPCConnection *this = self;
    xpc_connection_set_event_handler(connection, ^(xpc_object_t object){
        if (object == XPC_ERROR_CONNECTION_INTERRUPTED){
        }else if (object == XPC_ERROR_CONNECTION_INVALID){    
        }else if (object == XPC_ERROR_KEY_DESCRIPTION){
        }else if (object == XPC_ERROR_TERMINATION_IMMINENT){
        }else{
            id message = [NSObject objectWithXPCObject: object];
            if(this.eventHandler){
                this.eventHandler(message, this);
            }
        }
    });
    
    xpc_connection_resume(_connection);
}

-(void)sendMessage:(NSDictionary *)dictMessage{
    [self createConnectionIfNecessary];
    
	if(![dictMessage isKindOfClass:[NSDictionary class]]){
		dictMessage = [NSDictionary dictionaryWithObject:dictMessage forKey:@"contents"];
	}

	xpc_object_t message = NULL;

	NSDate *date = [NSDate date];
	message = [dictMessage newXPCObject];
	NSLog(@"Message encoding took %gs on average - %@", [[NSDate date] timeIntervalSinceDate:date], dictMessage);
    
	xpc_connection_send_message(_connection, message);
    xpc_release(message);
}

-(NSString *)connectionName{
	[self createConnectionIfNecessary];
	const char* name = xpc_connection_get_name(_connection);
	if(!name) return nil;
	return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

-(NSNumber *)connectionEUID{
	[self createConnectionIfNecessary];
	uid_t uid = xpc_connection_get_euid(_connection);
	return [NSNumber numberWithUnsignedInt:uid];
}

-(NSNumber *)connectionEGID{
	[self createConnectionIfNecessary];
	gid_t egid = xpc_connection_get_egid(_connection);
	return [NSNumber numberWithUnsignedInt:egid];
}

-(NSNumber *)connectionProcessID{
	[self createConnectionIfNecessary];
	pid_t pid = xpc_connection_get_pid(_connection);
	return [NSNumber numberWithUnsignedInt:pid];
}

-(NSNumber *)connectionAuditSessionID{
	[self createConnectionIfNecessary];
	au_asid_t auasid = xpc_connection_get_asid(_connection);
	return [NSNumber numberWithUnsignedInt:auasid];
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