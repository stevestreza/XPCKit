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
    mathConnection = [[XPCConnection alloc] initWithServiceName:@"com.mustacheware.TestService"];
	mathConnection.errorHandler = ^(xpc_object_t object, NSString *description, XPCConnection *inConnection) {
		if (object == XPC_ERROR_CONNECTION_INTERRUPTED) {
			// test by adding abort() or assert() to TestService's main.m file
			NSLog(@"XPC_ERROR_CONNECTION_INTERRUPTED: %@", description);
	 	} else if (object == XPC_ERROR_CONNECTION_INVALID) {
			// test by using invalid name in initWithServiceName: above
			NSLog(@"XPC_ERROR_CONNECTION_INVALID: %@", description);
		} else if (object == XPC_ERROR_TERMINATION_IMMINENT) {
			// Not really an error, but more like a message that the app/service is terminating AFAIK, not sure how to test it or if it even needs to be handled, but it's here for the sake of completness...
			NSLog(@"XPC_ERROR_TERMINATION_IMMINENT: %@", description);
		} else {
			NSLog(@"ERROR: %@", description);
		}
	};	
    mathConnection.eventHandler = ^(NSDictionary *message, XPCConnection *inConnection){
		NSNumber *result = [message objectForKey:@"result"];
		NSData *data = [message objectForKey:@"data"];
		NSFileHandle *fileHandle = [message objectForKey:@"fileHandle"];
		NSDate *date = [message objectForKey:@"date"];
		if(result){
			NSLog(@"We got a calculation result! %@", result);
		}else if(data || fileHandle){
			NSData *newData = [fileHandle readDataToEndOfFile];
			NSLog(@"We got a file handle! Read %i bytes - %@", newData.length, fileHandle);
		}else if(date){
			NSLog(@"It is now %@", date);
		}
    };
	
	readConnection = [[XPCConnection alloc] initWithServiceName:@"com.mustacheware.TestService"];
    readConnection.eventHandler = ^(NSDictionary *message, XPCConnection *inConnection){
		NSData *data = [message objectForKey:@"data"];
		NSFileHandle *fileHandle = [message objectForKey:@"fileHandle"];
		if(data || fileHandle){
			NSData *newData = [fileHandle readDataToEndOfFile];
			if(newData){
				NSLog(@"We got maybe mapped data! %i bytes - Equal? %@", data.length, ([newData isEqualToData:data] ? @"YES" : @"NO"));
			}
				NSLog(@"We got a file handle! Read %i bytes - %@", newData.length, fileHandle);
		}
    };
	
	
	NSDictionary *multiplyData = 
	[NSDictionary dictionaryWithObjectsAndKeys: 
	 @"multiply", @"operation",
	 [NSArray arrayWithObjects:
	  [NSNumber numberWithInt:7],
	  [NSNumber numberWithInt:6],
	  [NSNumber numberWithDouble: 1.67], 
	  nil], @"values",
	 nil];
	
	NSDictionary *readData = [NSDictionary dictionaryWithObjectsAndKeys:
			@"read", @"operation",
			@"/Users/syco/Library/Safari/Bookmarks.plist", @"path",
			nil];
	NSData *loadedData = [[NSFileManager defaultManager] contentsAtPath:[readData objectForKey:@"path"]];
	NSFileHandle *loadedHandle = [NSFileHandle  fileHandleForReadingAtPath:[readData objectForKey:@"path"]];
	NSLog(@"Sandbox is %@ at path %@, got %i bytes and a file handle %@",((loadedData.length == 0 && loadedHandle == nil) ? @"working" : @"NOT working"), [readData objectForKey:@"path"], loadedData.length, loadedHandle);

    [mathConnection sendMessage:multiplyData];
	[readConnection sendMessage:readData];
	
	[mathConnection sendMessage:[NSDictionary dictionaryWithObject:@"whatTimeIsIt" forKey:@"operation"]];
}

@end
