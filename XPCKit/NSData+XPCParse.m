//
//  NSData+XPCParse.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "NSData+XPCParse.h"

@implementation NSData (XPCParse)

+(NSData *)dataWithXPCObject:(xpc_object_t)xpcObject{
    return [NSData dataWithBytes:xpc_data_get_bytes_ptr(xpcObject)
                          length:xpc_data_get_length(xpcObject)];
}

-(xpc_object_t)newXPCObject{
    return xpc_data_create([self bytes], [self length]);
}

@end
