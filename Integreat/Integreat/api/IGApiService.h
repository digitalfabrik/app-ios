#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"
#import "Language.h"
#import "Page.h"

typedef void(^FetchLocationsCompletionHandler)( NSArray<Location *> * _Nullable locations,  NSError * _Nullable error);
typedef void(^FetchLanguagesCompletionHandler)( NSArray<Language *> * _Nullable languages,  NSError * _Nullable error);
typedef void(^FetchPagesCompletionHandler)( NSArray<Page *> * _Nullable pages, NSError * _Nullable error);


@interface IGApiService : NSObject

@property (nonnull, readonly, strong, nonatomic) NSManagedObjectContext *context;

- (nonnull instancetype)initWithContext:(nonnull NSManagedObjectContext *)context;


/// Fetches all locations
- (void)fetchLocationsWithCompletionHandler:(nonnull FetchLanguagesCompletionHandler)completion;

/// Fetches all languages for a specific location
- (void)fetchLanguagesForLocation:(nonnull Location *)location
            withCompletionHandler:(nonnull FetchLanguagesCompletionHandler)completion;

/// Fetches pages for a specific location and language
- (void)fetchPagesForLocation:(nonnull Location *)location
                     language:(nonnull Language *)language
        withCompletionHandler:(nonnull FetchLanguagesCompletionHandler)completion;

@end
