//
//  NSDictionary+XPCParse.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

@interface NSDictionary (XPCParse)

+(NSDictionary *)dictionaryWithContentsOfXPCObject:(xpc_object_t)object;
-(xpc_object_t)newXPCObject;

@end
