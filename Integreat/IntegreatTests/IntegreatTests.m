#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "SlimConnectionManager.h"
#import "IGApiService.h"


@interface IntegreatTests : XCTestCase

@property (nullable, strong, nonatomic) NSManagedObjectContext *context;
@property (nullable, strong, nonatomic) IGApiService *apiService;

@end


@implementation IntegreatTests

- (void)setUp {
    [super setUp];
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[
        [NSBundle mainBundle]
    ]];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = coordinator;
    
    self.apiService = [[IGApiService alloc] initWithContext:self.context];
}

- (void)tearDown {
    self.context = nil;
    self.apiService = nil;
    
    [super tearDown];
}


-(void)testLocationsRetrieval
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch locations"];
    
    [self.apiService fetchLocationsWithCompletionHandler:^(NSArray<Location *> * _Nullable locations, NSError * _Nullable error) {
        XCTAssert(locations.count > 0);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void)testLanguagesRetrieval
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch languages"];
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.context];
    location.resourceName = @"augsburg";
    
    [self.apiService fetchLanguagesForLocation:location withCompletionHandler:^(NSArray<Language *> * _Nullable languages, NSError * _Nullable error) {
        XCTAssert(languages.count > 0);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void)testPagesRetrieval
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch pages"];
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.context];
    location.resourceName = @"augsburg";

    Language *language = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:self.context];
    language.resourceName = @"en";

    [self.apiService fetchPagesForLocation:location language:language withCompletionHandler:^(NSArray<Page *> * _Nullable pages, NSError * _Nullable error) {
        XCTAssert(pages.count > 0);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
