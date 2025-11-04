

#import <UIKit/UIKit.h>

@interface EmployerBidListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecent;
@property (weak, nonatomic) IBOutlet UIImageView *imgBid;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *recentBtn;
@property (weak, nonatomic) IBOutlet UIButton *ratingBtn;
@property (weak, nonatomic) IBOutlet UIButton *bidBtn;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIImageView *imgAll;
@property (weak, nonatomic) IBOutlet UIImageView *imgRating;
@property (weak, nonatomic) NSMutableArray *bidlistArray;
@property (weak, nonatomic) NSString *jobTitleStr;
@property (weak, nonatomic) IBOutlet UITableView *toilerBidsTable;
@property (weak, nonatomic) IBOutlet UILabel *noBidLable;
@property BOOL isFromAllBidScreen;


@end
