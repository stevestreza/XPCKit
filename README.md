XPCKit is a Cocoa library for wrapping the XPC C APIs in a handy object-oriented model. It is merely meant as an object-oriented wrapper for the C library, and does not attempt to layer any additional semantics on top.

Features
========

- Simplified Objective-C API for interacting with XPC processes
- Auto-boxing and auto-unboxing of objects from xpc_object_t objects to:
 - NSArray *(complete)*
 - NSDictionary *(complete)*
 - NSData *(complete)*
 - NSData, backed by shared memory *(incomplete)*
 - NSString *(complete)*
 - NSNumber *(complete)*
 - UUIDs *(incomplete)*
 - NSFileHandle *(incomplete)*
 - XPCConnection *(incomplete)*
- Block-based callbacks

Authors
=======

- [Steve Streza](https://twitter.com/SteveStreza)

Sample Code
===========

Given [this sample data](https://github.com/amazingsyco/XPCKit/blob/master/TestApp/multiply.json), converted to an NSDictionary, you can see how:

- the [client](https://github.com/amazingsyco/XPCKit/blob/master/TestApp/TestAppAppDelegate.m) sends this command as a message, and
- the [server](https://github.com/amazingsyco/XPCKit/blob/master/TestService/main.m) receives this command, processes it, and sends the response back

Installation
============

You can use XPCKit in the client, server, or both; you just have to include the code. You can include XPCKit in one of three ways:

1. Include the source files yourself (everything in XPCKit)
2. Make a dependency of XPCKit's framework
3. Make a dependency of XPCKit's static library (**note**: you will need to add linker flags `-all_load` and `-ObjC` to make this work properly)

Setting up the Client
---------------------

1. In your app, add the XPCKit source files, library or framework
2. Set up an XPCConnection object with the name of your service
3. Send it a message

Setting up the Server
---------------------

0. If you haven't already, create a new "XPC Service" target (located in Mac OS X > Framework & Library)
1. Add the XPCKit source files, library or framework
2. Link against the Foundation framework
3. Rename "main.c" to "main.m"
4. In your main function, call +[XPCListener listenForEventsWithHandler:] to start listening for messages.

License
=======

Copyright 2011 XPCKit

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.