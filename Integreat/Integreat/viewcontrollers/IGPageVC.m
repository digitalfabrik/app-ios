//
//  IGPageVC.m
//  Integreat
//
//  Created by Chris Schneider on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import "IGPageVC.h"


@implementation IGPageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.selectedPage.title;
    
    [self.webView loadHTMLString:self.selectedPage.content baseURL:nil];
}

@end
