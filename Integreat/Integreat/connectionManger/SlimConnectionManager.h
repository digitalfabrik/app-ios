//
//  SlimConnectionManager.h
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlimConnectionManager : NSObject


-(void)getPages:(NSString*)location forLanguage:(NSString*)language;

-(void)getCities;

-(void)getLangauges:(NSString*)city;
@end
