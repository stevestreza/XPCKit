//
//  XPCConnection.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11. Copyright 2011 XPCKit.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "XPCConnection.h"
#import <xpc/xpc.h>
#import "NSObject+XPCParse.h"
#import "NSDictionary+XPCParse.h"

#define XPCSendLogMessages 1

@implementation XPCConnection

@synthesize eventHandler=_eventHandler;

- (id)initWithServiceName:(NSString *)serviceName{
	xpc_connection_t connection = xpc_connection_create([serviceName cStringUsingEncoding:NSUTF8StringEncoding], NULL);
	self = [self initWithConnection:connection];
	xpc_release(connection);
	return self;
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

-(void)dealloc{
	if(_connection){
		xpc_connection_cancel(_connection);
		xpc_release(_connection);
		_connection = NULL;
	}
	
	[super dealloc];
}

-(void)receiveConnection:(xpc_connection_t)connection{
    __block XPCConnection *this = self;
    xpc_connection_set_event_handler(connection, ^(xpc_object_t object){
        if (object == XPC_ERROR_CONNECTION_INTERRUPTED){
        }else if (object == XPC_ERROR_CONNECTION_INVALID){    
        }else if (object == XPC_ERROR_KEY_DESCRIPTION){
        }else if (object == XPC_ERROR_TERMINATION_IMMINENT){
        }else{
            id message = [NSObject objectWithXPCObject: object];
			
#if XPCSendLogMessages
			if([message objectForKey:@"XPCDebugLog"]){
				NSLog(@"LOG: %@", [message objectForKey:@"XPCDebugLog"]);
				return;
			}
#endif
			
            if(this.eventHandler){
                this.eventHandler(message, this);
            }
        }
    });
    
    xpc_connection_resume(_connection);
}

-(void)sendMessage:(NSDictionary *)dictMessage{
	if(![dictMessage isKindOfClass:[NSDictionary class]]){
		dictMessage = [NSDictionary dictionaryWithObject:dictMessage forKey:@"contents"];
	}

	xpc_object_t message = NULL;

//	NSDate *date = [NSDate date];
	message = [dictMessage newXPCObject];
//	NSLog(@"Message encoding took %gs on average - %@", [[NSDate date] timeIntervalSinceDate:date], dictMessage);
    
	xpc_connection_send_message(_connection, message);
    xpc_release(message);
}

-(NSString *)connectionName{
	const char* name = xpc_connection_get_name(_connection);
	if(!name) return nil;
	return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

-(NSNumber *)connectionEUID{
	uid_t uid = xpc_connection_get_euid(_connection);
	return [NSNumber numberWithUnsignedInt:uid];
}

-(NSNumber *)connectionEGID{
	gid_t egid = xpc_connection_get_egid(_connection);
	return [NSNumber numberWithUnsignedInt:egid];
}

-(NSNumber *)connectionProcessID{
	pid_t pid = xpc_connection_get_pid(_connection);
	return [NSNumber numberWithUnsignedInt:pid];
}

-(NSNumber *)connectionAuditSessionID{
	au_asid_t auasid = xpc_connection_get_asid(_connection);
	return [NSNumber numberWithUnsignedInt:auasid];
}

-(void)_sendLog:(NSString *)string{
#if XPCSendLogMessages
	[self sendMessage:[NSDictionary dictionaryWithObject:string forKey:@"XPCDebugLog"]];
#endif
}

@end
