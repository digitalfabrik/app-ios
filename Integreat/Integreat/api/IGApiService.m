#import "IGApiService.h"
#import "SlimConnectionManager.h"
#import "Integreat-Swift.h"

@interface IGApiService()

@property (nonnull, strong, nonatomic) SlimConnectionManager *connectionManager;

@end


@implementation IGApiService

- (nonnull instancetype)initWithContext:(nonnull NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        _context = context;
        _connectionManager = [[SlimConnectionManager alloc] init];
    }
    return self;
}


- (void)updateLocations
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    typeof(self) weakSelf = self;
    [self.connectionManager getLocationsWithCompletionHandler:^(NSArray *locationsJson, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil || weakSelf == nil){
            return;
        }
        for (NSDictionary *locationJson in locationsJson) {
            if (((NSNumber *)locationJson[@"live"]).boolValue == YES){
                [Location locationWithJson:locationJson inContext:weakSelf.context];
            } else {
                NSString *identifier = locationJson[@"id"];
                [Location deleteLocationWithIdentifier:identifier inContext:weakSelf.context];
            }
        }
        
        NSError *saveError = nil;
        [weakSelf.context save:&saveError];
        if (saveError != nil) {
            NSLog(@"Error saving context: %@", saveError);
        }
    }];
}

- (void)upateLanguagesForLocation:(nonnull Location *)location
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    typeof(self) weakSelf = self;
    [self.connectionManager getLangauges:location.resourceName withCompletionHandler:^(NSArray *languagesJson, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil || weakSelf == nil){
            return;
        }
        for (NSDictionary *languageJson in languagesJson) {
            Language *language = [Language languageWithJson:languageJson inContext:weakSelf.context];
            [[language mutableSetValueForKey:@"locations"] addObject:location];
        }
        
        NSError *saveError = nil;
        [weakSelf.context save:&saveError];
        if (saveError != nil) {
            NSLog(@"Error saving context: %@", saveError);
        }
    }];
}

- (void)updatePagesForLocation:(nonnull Location *)location
                      language:(nonnull Language *)language
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

   typeof(self) weakSelf = self;
    [self.connectionManager getPages:location.resourceName forLanguage:language.resourceName withCompletionHandler:^(NSArray *pagesJson, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil || weakSelf == nil){
            return;
        }
        
        NSArray *pages = [Page pagesWithJson:pagesJson inContext:weakSelf.context];
        [[location mutableSetValueForKey:@"pages"] addObjectsFromArray:pages];
        [[language mutableSetValueForKey:@"pages"] addObjectsFromArray:pages];
        
        NSError *saveError = nil;
        [weakSelf.context save:&saveError];
        if (saveError != nil) {
            NSLog(@"Error saving context: %@", saveError);
        }
    }];
}

- (void)updateEventsForLocation:(nonnull Location *)location
                      language:(nonnull Language *)language
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    typeof(self) weakSelf = self;
    [self.connectionManager getEvents:location.resourceName forLanguage:language.resourceName withCompletionHandler:^(NSArray *pagesJson, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil || weakSelf == nil){
            return;
        }
        
        NSArray *events = [Page pagesWithJson:pagesJson inContext:weakSelf.context];
        for (Event *event in events) {
            event.location = location;
            event.language = language;
        }
        
        NSError *saveError = nil;
        [weakSelf.context save:&saveError];
        if (saveError != nil) {
            NSLog(@"Error saving context: %@", saveError);
        }
    }];
}

@end
