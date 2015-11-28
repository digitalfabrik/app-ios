//
//  SlimConnectionManager.h
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetArrayCompletionHandler)(NSArray *resut, NSError *error);


@interface SlimConnectionManager : NSObject

-(void)getPages:(NSString*)location forLanguage:(NSString*)language withCompletionHandler:(GetArrayCompletionHandler)completion;

-(void)getLocationsWithCompletionHandler:(GetArrayCompletionHandler)completion;

-(void)getLangauges:(NSString*)city withCompletionHandler:(GetArrayCompletionHandler)completion;

@end
