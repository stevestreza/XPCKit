//
//  NSNumber+XPCParse.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "NSNumber+XPCParse.h"
#import <xpc/xpc.h>

@implementation NSNumber (XPCParse)

+(NSNumber *)numberWithXPCObject:(xpc_object_t)xpc{
    NSNumber * object = nil;
    xpc_type_t type = xpc_get_type(xpc);
    if(type == XPC_TYPE_BOOL){
        object = [NSNumber numberWithBool:xpc_bool_get_value(xpc)];
    }else if(type == XPC_TYPE_UINT64){
        object = [NSNumber numberWithUnsignedLong:xpc_uint64_get_value(xpc)];
    }else if(type == XPC_TYPE_INT64){
        object = [NSNumber numberWithLong:xpc_int64_get_value(xpc)];
    }else if(type == XPC_TYPE_DOUBLE){
        object = [NSNumber numberWithDouble:xpc_double_get_value(xpc)];
    }
	
    return object;
}

-(xpc_object_t)newXPCObject{
    if(self == (NSNumber *)kCFBooleanTrue){
        return xpc_bool_create(true);
    }else if(self == (NSNumber *)kCFBooleanTrue){
        return xpc_bool_create(true);
    }else{
        const char* objCType = [self objCType];
        if(strcmp(objCType, @encode(unsigned long))){
            return xpc_uint64_create([self unsignedLongValue]);
        }else if(strcmp(objCType, @encode(long))){
            return xpc_int64_create([self longValue]);
        }else{
            return xpc_double_create([self doubleValue]);
        }
    }
    return NULL;
}

@end
