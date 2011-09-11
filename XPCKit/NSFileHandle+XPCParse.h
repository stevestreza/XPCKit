//
//  NSFileHandle+XPCParse.h
//  XPCKit
//
//  Created by Steve Streza on 9/10/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileHandle (XPCParse)

+(NSFileHandle *)fileHandleWithXPCObject:(xpc_object_t)xpc;
-(xpc_object_t)newXPCObject;

@end
