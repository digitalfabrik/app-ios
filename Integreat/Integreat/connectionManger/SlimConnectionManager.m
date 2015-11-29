#import "SlimConnectionManager.h"


@implementation SlimConnectionManager

NSString* serverURL=@"http://vmkrcmar21.informatik.tu-muenchen.de/wordpress";
//http://vmkrcmar21.informatik.tu-muenchen.de/wordpress

-(id)init {
    if ( self = [super init] ) {
    
    }
    return self;
}

- (RACSignal *)getJsonForURL:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil){
                [subscriber sendError:error];
                return;
            }
            
            NSError *parseErr;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseErr];
            if (parseErr != nil){
                [subscriber sendError:parseErr];
                return;
            }
            for (NSDictionary *json in jsonArray) {
                [subscriber sendNext:json];
            }
            [subscriber sendCompleted];
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)getLocations
{
    NSString *urlString = [NSString stringWithFormat:@"%@/wp-json/extensions/v0/multisites/",serverURL];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    return [self getJsonForURL:url];
}

- (RACSignal *)getLanguagesForCity:(NSString*)city
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/de/wp-json/extensions/v0/languages/wpml",serverURL,city];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    return [self getJsonForURL:url];
}

- (RACSignal *)getPagesForLocation:(NSString*)location language:(NSString*)language sinceDate:(NSDate *)date
{
    // TODO: Add date!
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/wp-json/extensions/v0/modified_content/pages?since=2010-11-15T16:39:45%%2B0000",
                           serverURL,location,language];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    return [self getJsonForURL:url];
}

@end
