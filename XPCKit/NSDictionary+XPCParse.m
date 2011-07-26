//
//  NSDictionary+XPCParse.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "NSDictionary+XPCParse.h"
#import "NSObject+XPCParse.h"

@implementation NSDictionary (XPCParse)

+(NSDictionary *)dictionaryWithContentsOfXPCObject:(xpc_object_t)object{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    xpc_dictionary_apply(object, ^bool(const char *key, xpc_object_t value){
        NSString *nsKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
        id nsValue = [NSObject objectWithXPCObject:value];
        if(nsKey && nsValue){
            [dict setObject:nsValue forKey:nsKey];
        }
        return true;
    });
    return [[dict copy] autorelease];
}

-(xpc_object_t)newXPCObject{
    xpc_object_t dictionary = xpc_dictionary_create(NULL, NULL, 0);
    for(NSString *key in [self allKeys]){
        id value = [self objectForKey:key];
        if([value respondsToSelector:@selector(newXPCObject)]){
			xpc_object_t xpcValue = [value newXPCObject];
			xpc_dictionary_set_value(dictionary, [key cStringUsingEncoding:NSUTF8StringEncoding], xpcValue);
//        }else{
//            NSLog(@"Error parsing %@: Cannot handle %@ data", key, [value class]);
        }
    }
    return dictionary;
}

@end
