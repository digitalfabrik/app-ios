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
//http://vmkrcmar21.informatik.tu-muenchen.de/wordpress

-(id)init {
    if ( self = [super init] ) {
    
    }
    return self;
}

-(void)getPages:(NSString*)location forLanguage:(NSString*)language
{
    NSString* pagesURL=[NSString stringWithFormat:@"%@/%@/%@/wp-json/extensions/v0/modified_content/pages",serverURL,location,language];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:pagesURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError *parseErr;
                id pkg=[NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];

                
            }] resume];
}

-(void)getCities
{
    NSString* pagesURL=[NSString stringWithFormat:@"%@/wp-json/extensions/v0/multisites/",serverURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:pagesURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError *parseErr;
                id pkg=[NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];

                
            }] resume];
}

-(void)getLangauges:(NSString*)city
{
    NSString* pagesURL=[NSString stringWithFormat:@"%@/%@/de/wp-json/extensions/v0/languages/wpml",serverURL,city];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:pagesURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError *parseErr;
                id pkg=[NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
                //[self.delegate processCompleted];
                
            }] resume];
}


@end
