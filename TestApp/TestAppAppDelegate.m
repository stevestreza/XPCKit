//
//  TestAppAppDelegate.m
//  TestApp
//
//  Created by Steve Streza on 7/24/11.
//  Copyright 2011 Mustacheware. All rights reserved.
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
    connection.eventHandler = ^(id object){
        NSLog(@"Received an object! %@",object);
    };
	
	NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"justsome" ofType:@"json"];
	NSLog(@"JSON path: %@",jsonPath);
	id data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath]
											  options:0
												error:nil];
    [connection sendMessage:data];
}

@end
