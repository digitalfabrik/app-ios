//
//  Event.m
//  Integreat
//
//  Created by Hazem Safetli on 29/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import "Event.h"
#import "Language.h"
#import "Location.h"

@implementation Event

+ (nullable instancetype)findEventWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES] ];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *fetchResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil){
        NSLog(@"Error fetching event for identifier %@: %@", identifier, error);
        return nil;
    }
    return fetchResult.firstObject;
}

@end
