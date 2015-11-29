#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface SlimConnectionManager: NSObject

/// Gets locations as JSON dictionaries
-(RACSignal *)getLocations;

/// Gets languages as JSON dictionaries
-(RACSignal *)getLanguagesForCity:(NSString *)city;

/// Gets pages as JSON dictionaries
- (RACSignal *)getPagesForLocation:(NSString *)location language:(NSString *)language sinceDate:(NSDate *)date;

@end
