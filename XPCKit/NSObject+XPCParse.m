//
//  NSObject+XPCParse.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "NSObject+XPCParse.h"
#import <xpc/xpc.h>
#import "XPCExtensions.h"

@implementation NSObject (XPCParse)

+(id)objectWithXPCObject:(xpc_object_t)xpcObject{
    id object = nil;
    xpc_type_t type = xpc_get_type(xpcObject);
    if(type == XPC_TYPE_DICTIONARY){
        object = [NSDictionary dictionaryWithContentsOfXPCObject:xpcObject];
	}else if(type == XPC_TYPE_ARRAY){
		object = [NSArray arrayWithContentsOfXPCObject:xpcObject];
    }else if(type == XPC_TYPE_DATA){
        object = [NSData dataWithXPCObject:xpcObject];
    }else if(type == XPC_TYPE_STRING){
        object = [NSString stringWithXPCObject:xpcObject];
    }else if(type == XPC_TYPE_BOOL || type == XPC_TYPE_UINT64 || type == XPC_TYPE_INT64 || XPC_TYPE_DOUBLE){
        object = [NSNumber numberWithXPCObject:xpcObject];
    }
    return object;
}

@end
