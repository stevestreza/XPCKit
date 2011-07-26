//
//  XPCKitTests.m
//  XPCKitTests
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

#import "XPCKitTests.h"
#import "XPCKit.h"

@implementation XPCKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testString{
	[self testEqualityOfXPCRoundtripForObject:@""];
	[self testEqualityOfXPCRoundtripForObject:@"Hello world!"];	
}

- (void)testNumbers{
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithInt:0]];
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithInt:1]];
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithInt:-1]];
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithDouble:42.1]];
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithLong:42]];
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithUnsignedLong:42]];
	[self testEqualityOfXPCRoundtripForObject:(id)kCFBooleanTrue];
	[self testEqualityOfXPCRoundtripForObject:(id)kCFBooleanFalse];
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithBool:YES]];
	[self testEqualityOfXPCRoundtripForObject:[NSNumber numberWithBool:NO]];
}

-(void)testArrays{
	[self testEqualityOfXPCRoundtripForObject:[NSArray array]];
	[self testEqualityOfXPCRoundtripForObject:[NSArray arrayWithObject:@"foo"]];
	[self testEqualityOfXPCRoundtripForObject:[NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil]];
}

-(void)testDictionaries{
	[self testEqualityOfXPCRoundtripForObject:[NSDictionary dictionary]];
	[self testEqualityOfXPCRoundtripForObject:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]];
	[self testEqualityOfXPCRoundtripForObject:[NSDictionary dictionaryWithObjectsAndKeys:
											   @"bar", @"foo",
											   @"42", @"baz",
											   [NSNumber numberWithInt:42], @"theAnswerToEverything",
											   nil]];
}

-(void)testUUID{
	// UUIDs are unique, so test a few at random
	STAssertFalse([[XPCUUID uuid] isEqual:[XPCUUID uuid]], @"Two identical UUIDs");
	STAssertFalse([[XPCUUID uuid] isEqual:[XPCUUID uuid]], @"Two identical UUIDs");
	STAssertFalse([[XPCUUID uuid] isEqual:[XPCUUID uuid]], @"Two identical UUIDs");
	
	[self testEqualityOfXPCRoundtripForObject:[XPCUUID uuid]];
	[self testEqualityOfXPCRoundtripForObject:[XPCUUID uuid]];
	[self testEqualityOfXPCRoundtripForObject:[XPCUUID uuid]];
}

-(void)testEqualityOfXPCRoundtripForObject:(id)object{
	STAssertNotNil(object, @"Source object is nil");
	
	xpc_object_t xpcObject = [object newXPCObject];
	STAssertNotNil(xpcObject, @"XPC Object is nil");
	
	id outObject = [NSObject objectWithXPCObject:xpcObject];
	STAssertNotNil(outObject, @"XPC-converted object is nil");
	
	STAssertEqualObjects(object, outObject, @"Object %@ was not equal to result %@", outObject);
	
	xpc_release(xpcObject);
}

@end
