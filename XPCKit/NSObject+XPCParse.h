//
//  NSObject+XPCParse.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

@interface NSObject (XPCParse)

+(id)objectWithXPCObject:(xpc_object_t)xpcObject;

@end
