#import <UIKit/UIKit.h>
#import "Page.h"


@interface IGPageVC : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) Page *selectedPage;

@end
