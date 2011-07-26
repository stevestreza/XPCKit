//
//  NSArray+XPCParse.m
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "NSArray+XPCParse.h"
#import "XPCExtensions.h"

@implementation NSArray (XPCParse)

+(NSArray *)arrayWithContentsOfXPCObject:(xpc_object_t)object{
	NSMutableArray *array = [NSMutableArray array];
	xpc_array_apply(object, ^_Bool(size_t index, xpc_object_t value) {
		id nsValue = [NSObject objectWithXPCObject:value];
		if(nsValue){
			[array insertObject:nsValue atIndex:index];
		}
		return true;
	});
	return [[array copy] autorelease];
}

-(xpc_object_t)newXPCObject{
	xpc_object_t array = xpc_array_create(NULL, 0);
	[self enumerateObjectsUsingBlock:^(id value, NSUInteger index, BOOL *stop) {
		if([value respondsToSelector:@selector(newXPCObject)]){
			xpc_object_t xpcValue = [value newXPCObject];
			xpc_array_set_value(array, XPC_ARRAY_APPEND, xpcValue);
		}
	}];
	return array;
}

@end
