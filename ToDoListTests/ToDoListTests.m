//
//  ToDoListTests.m
//  ToDoListTests
//
//  Created by Rong Yan on 9/3/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SenTestingKit/SenTestingKit.h>
#import "TestToDoItem.h"

@interface ToDoListTests : XCTestCase

@end

@implementation ToDoListTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super tearDown];
}

- (void)testExample
{
    // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    NSString *itemName = @"test1";
    TestToDoItem *item = [[TestToDoItem alloc] init:itemName];
    XCTAssertEqual(item.itemName, itemName, @"matched");
}

- (void)testNegExample
{
    NSString *itemName = @"test1";
    TestToDoItem *item = [[TestToDoItem alloc] init:@"test2"];
    XCTAssertNotEqual(item.itemName, itemName, @"not matched");
}

@end
