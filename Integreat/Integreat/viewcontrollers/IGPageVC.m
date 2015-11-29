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
    
    
    NSString *responsive = @"<meta name='viewport' content='width=device-width' />";
    NSString *styles = @"<style type='text/css'>body {  }</style>";
    NSString *html = [NSString stringWithFormat:@"<html><head>%@%@</head><body>%@</body></html>",
                      responsive, styles, self.selectedPage.content];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

@end
