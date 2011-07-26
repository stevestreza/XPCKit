//
//  main.c
//  TestService
//
//  Created by Steve Streza on 7/24/11. Copyright 2011 Mustacheware.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
