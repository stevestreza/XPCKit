//
//  TestAppAppDelegate.m
//  TestApp
//
//  Created by Steve Streza on 7/24/11. Copyright 2011 XPCKit.
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

#import "TestAppAppDelegate.h"
#import <xpc/xpc.h>
#import <dispatch/dispatch.h>

@implementation TestAppAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    connection = [[XPCConnection alloc] initWithServiceName:@"com.mustacheware.TestService"];
    connection.eventHandler = ^(NSDictionary *message, XPCConnection *inConnection){
		NSNumber *result = [message objectForKey:@"result"];
        NSLog(@"We got a calculation result! %@", result);
    };
	
	NSDictionary *data = 
	[NSDictionary dictionaryWithObjectsAndKeys: 
	 @"multiply", @"operation",
	 [NSArray arrayWithObjects:
	  [NSNumber numberWithInt:7],
	  [NSNumber numberWithInt:6],
	  [NSNumber numberWithDouble: 1.67], 
	  nil], @"values",
	 nil];
	
    [connection sendMessage:data];
}

@end
