//
//  XPCTypes.h
//  XPCKit
//
//  Created by Steve Streza on 7/25/11.
//  Copyright 2011 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPCConnection;
typedef void (^XPCEventHandler)(NSDictionary *, XPCConnection *);