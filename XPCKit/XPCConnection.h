//
//  XPCConnection.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPCTypes.h"

@interface XPCConnection : NSObject{
    xpc_connection_t _connection;
}

- (id)initWithServiceName:(NSString *)serviceName;

@property (nonatomic, readonly) NSString  *serviceName;
@property (nonatomic, retain)   XPCEventHandler eventHandler;

// connection properties
@property (nonatomic, readonly) NSString *connectionName;
@property (nonatomic, readonly) NSNumber *connectionEUID;
@property (nonatomic, readonly) NSNumber *connectionEGID;
@property (nonatomic, readonly) NSNumber *connectionProcessID;
@property (nonatomic, readonly) NSString *connectionAuditSessionID;

-(void)sendMessage:(NSDictionary *)message;

// handling connections
-(void)createConnectionIfNecessary;
-(void)receiveConnection:(xpc_connection_t)connection;
@end
