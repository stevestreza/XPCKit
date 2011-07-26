//
//  TestAppAppDelegate.h
//  TestApp
//
//  Created by Steve Streza on 7/24/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XPCConnection.h"

@interface TestAppAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    XPCConnection *connection;
}

@property (assign) IBOutlet NSWindow *window;

@end
