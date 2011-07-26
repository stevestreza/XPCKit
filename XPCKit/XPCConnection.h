//
//  XPCConnection.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

typedef void (^XPCHandler)(id object);

@interface XPCConnection : NSObject{
    xpc_connection_t _connection;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, retain)   XPCHandler eventHandler;

-(void)sendMessage:(NSDictionary *)message;

@end
