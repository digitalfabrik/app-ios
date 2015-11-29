#import <UIKit/UIKit.h>
#import "IGApiService.h"
#import "Location.h"
#import "Language.h"


@interface IGPagesListVC : UITableViewController<UISearchBarDelegate>

@property (strong, nonatomic) IGApiService *apiService;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) Language *selectedLanguage;

@property (strong, nonatomic) IBOutlet UISearchBar *pagesSearchBar;

@end
