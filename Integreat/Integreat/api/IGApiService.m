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


- (void)fetchLocationsWithCompletionHandler:(FetchLocationsCompletionHandler)completion
{
    typeof(self) weakSelf = self;
    [self.connectionManager getLocationsWithCompletionHandler:^(NSArray *locationsJson, NSError *error) {
        if (error != nil){
            completion(nil, error);
            return;
        }
        if (weakSelf == nil){
            completion(nil, nil);
            return;
        }
        
        NSMutableArray *locations = [NSMutableArray arrayWithCapacity:locationsJson.count];
        for (NSDictionary *locationJson in locationsJson) {
            Location *location = [Location locationWithJson:locationJson inContext:weakSelf.context];
            [locations addObject:location];
        }
                
        completion(locations, nil);
    }];
}

- (void)fetchLanguagesForLocation:(Location *)location
            withCompletionHandler:(FetchLanguagesCompletionHandler)completion
{
    typeof(self) weakSelf = self;
    [self.connectionManager getLangauges:location.resourceName withCompletionHandler:^(NSArray *languagesJson, NSError *error) {
        if (error != nil){
            completion(nil, error);
            return;
        }
        if (weakSelf == nil){
            completion(nil, nil);
            return;
        }
        
        NSMutableArray *languages = [NSMutableArray arrayWithCapacity:languagesJson.count];
        for (NSDictionary *languageJson in languagesJson) {
            Language *language = [Language languageWithJson:languageJson inContext:weakSelf.context];
            [languages addObject:language];
        }
        
        completion(languages, nil);
    }];
}

- (void)fetchPagesForLocation:(Location *)location
                     language:(Language *)language
        withCompletionHandler:(FetchPagesCompletionHandler)completion
{
    typeof(self) weakSelf = self;
    [self.connectionManager getPages:location.resourceName forLanguage:language.resourceName withCompletionHandler:^(NSArray *pagesJson, NSError *error) {
        if (error != nil){
            completion(nil, error);
            return;
        }
        if (weakSelf == nil){
            completion(nil, nil);
            return;
        }
        NSArray *pages = [Page pagesWithJson:pagesJson inContext:weakSelf.context];
        completion(pages, nil);
    }];
}

@end
