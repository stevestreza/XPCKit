//
//  main.c
//  TestService
//
//  Created by Steve Streza on 7/24/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <xpc/xpc.h>
#include <assert.h>
#import "XPCKit.h"

static void TestService_peer_event_handler(xpc_connection_t peer, xpc_object_t event) 
{
    printf("TestService peer event handler\n");
	xpc_type_t type = xpc_get_type(event);
	if (type == XPC_TYPE_ERROR) {
		if (event == XPC_ERROR_CONNECTION_INVALID) {
			// The client process on the other end of the connection has either
			// crashed or cancelled the connection. After receiving this error,
			// the connection is in an invalid state, and you do not need to
			// call xpc_connection_cancel(). Just tear down any associated state
			// here.
		} else if (event == XPC_ERROR_TERMINATION_IMMINENT) {
			// Handle per-connection termination cleanup.
		}
	} else {
		assert(type == XPC_TYPE_DICTIONARY);
		// Handle the message.

	    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
        xpc_dictionary_set_string(message, "message", "hello thar!");
        xpc_connection_send_message(peer, message);
}
}

static void TestService_event_handler(xpc_connection_t peer) 
{
	// By defaults, new connections will target the default dispatch
	// concurrent queue.
	xpc_connection_set_event_handler(peer, ^(xpc_object_t event) {
		TestService_peer_event_handler(peer, event);
	});
	
	// This will tell the connection to begin listening for events. If you
	// have some other initialization that must be done asynchronously, then
	// you can defer this call until after that initialization is done.
	xpc_connection_resume(peer);
}

int main(int argc, const char *argv[])
{
	NSLog(@"Hello world! XPC Main");
	[XPCListener listenForEvents];
	return 0;
}
