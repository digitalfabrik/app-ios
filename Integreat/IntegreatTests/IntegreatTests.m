//
//  IntegreatTests.m
//  IntegreatTests
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SlimConnectionManager.h"
@interface IntegreatTests : XCTestCase

@end

@implementation IntegreatTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testConnection
{
    SlimConnectionManager *connMnager=[[SlimConnectionManager alloc]init];
    [connMnager getCities];
    [connMnager getLangauges:@"augsburg"];
    [connMnager getPages:@"augsburg" forLanguage:@"de"];
}

@end
