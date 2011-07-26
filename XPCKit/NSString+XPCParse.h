//
//  NSString+XPCParse.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPCParse)

+(NSString *)stringWithXPCObject:(xpc_object_t)xpc;
-(xpc_object_t)newXPCObject;

@end
