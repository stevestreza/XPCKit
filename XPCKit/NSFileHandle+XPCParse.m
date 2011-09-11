//
//  NSFileHandle+XPCParse.m
//  XPCKit
//
//  Created by Steve Streza on 9/10/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import "NSFileHandle+XPCParse.h"

@implementation NSFileHandle (XPCParse)

+(NSFileHandle *)fileHandleWithXPCObject:(xpc_object_t)xpc{
	int fd = xpc_fd_dup(xpc);
	NSFileHandle *handle = [[[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc:YES] autorelease];
	return handle;
}

-(xpc_object_t)newXPCObject{
	int fd = [self fileDescriptor];
	xpc_object_t object = xpc_fd_create(fd);
	return object;
}

@end
