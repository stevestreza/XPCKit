//
//  main.c
//  TestService
//
//  Created by Steve Streza on 7/24/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>
#import "XPCKit.h"

int main(int argc, const char *argv[])
{
	[XPCListener listenForEventsWithHandler:^(NSDictionary *message, XPCConnection *connection) {
		if([[message objectForKey:@"operation"] isEqual:@"multiply"]){
			__block double product = 1.0;
			NSArray *values = [message objectForKey:@"values"];

			[values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				product = product * [(NSNumber *)obj doubleValue];
			}];
			
			[connection sendMessage:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:product] forKey:@"result"]];
		}
	}];
	return 0;
}
