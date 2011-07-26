//
//  NSNumber+XPCParse.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (XPCParse)

+(NSNumber *)numberWithXPCObject:(xpc_object_t)xpc;
-(xpc_object_t)newXPCObject;

@end
