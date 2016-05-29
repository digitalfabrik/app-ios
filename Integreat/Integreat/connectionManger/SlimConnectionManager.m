//
//  SlimConnectionManager.m
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import "SlimConnectionManager.h"


@implementation SlimConnectionManager
NSString* serverURL=@"http://vmkrcmar21.informatik.tu-muenchen.de/wordpress";

-(id)init {
    if ( self = [super init] ) {
    
    }
    return self;
}

-(void)getPages:(NSString*)location forLanguage:(NSString*)language withCompletionHandler:(GetArrayCompletionHandler)completion
{
    //TODO: change since
    NSString* pagesURL=[NSString stringWithFormat:@"%@/%@/%@/wp-json/extensions/v0/modified_content/pages?since=2010-11-15T16:39:45%%2B0000",serverURL,location,language];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:pagesURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError *parseErr;
                id pkg=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseErr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(pkg, nil);
                });
            }] resume];
}

-(void)getLocationsWithCompletionHandler:(GetArrayCompletionHandler)completion
{
    NSString* pagesURL=[NSString stringWithFormat:@"%@/wp-json/extensions/v1/multisites/",serverURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:pagesURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error != nil){
                    completion(nil, error);
                    return;
                }
                NSError *parseErr;
                id pkg = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
                completion(pkg, parseErr);
            }] resume];
}

-(void)getLangauges:(NSString*)city withCompletionHandler:(GetArrayCompletionHandler)completion
{
    NSString* pagesURL=[NSString stringWithFormat:@"%@/%@/de/wp-json/extensions/v0/languages/wpml",serverURL,city];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:pagesURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError *parseErr;
                id pkg=[NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(pkg, nil);
                });
            }] resume];
}

-(void)getEvents:(NSString*)location forLanguage:(NSString*)language withCompletionHandler:(GetArrayCompletionHandler)completion
{
    NSString* pagesURL=[NSString stringWithFormat:@"%@/%@/%@/wp-json/extensions/v0/modified_content/events?since=2010-11-15T16:39:45%%2B0000",serverURL,location,language];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:pagesURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError *parseErr;
                id pkg=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseErr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(pkg, nil);
                });
            }] resume];
}


@end
