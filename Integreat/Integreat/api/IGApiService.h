#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"
#import "Language.h"
#import "Page.h"

typedef void(^FetchLocationsCompletionHandler)( NSArray<Location *> * _Nullable locations,  NSError * _Nullable error);
typedef void(^FetchLanguagesCompletionHandler)( NSArray<Language *> * _Nullable languages,  NSError * _Nullable error);
typedef void(^FetchPagesCompletionHandler)( NSArray<Page *> * _Nullable pages, NSError * _Nullable error);
typedef void(^FetchEventsCompletionHandler)( NSArray<Page *> * _Nullable pages, NSError * _Nullable error);



@interface IGApiService : NSObject

@property (nonnull, readonly, strong, nonatomic) NSManagedObjectContext *context;

- (nonnull instancetype)initWithContext:(nonnull NSManagedObjectContext *)context;


/// Updates all locations
- (void)updateLocations;

/// Updates all languages for a specific location
- (void)upateLanguagesForLocation:(nonnull Location *)location;

/// Updates all pages for a specific location and language
- (void)updatePagesForLocation:(nonnull Location *)location
                      language:(nonnull Language *)language;

/// Updates all events for a specific location and language
- (void)updateEventsForLocation:(nonnull Location *)location
                      language:(nonnull Language *)language;

@end
