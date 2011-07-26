//
//  NSString+XPCParse.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "NSString+XPCParse.h"

@implementation NSString (XPCParse)

+(NSString *)stringWithXPCObject:(xpc_object_t)xpc{
    return [NSString stringWithUTF8String:xpc_string_get_string_ptr(xpc)];
}

-(xpc_object_t)newXPCObject{
    return xpc_string_create([self cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
