

#import <UIKit/UIKit.h>

@interface EmployerMyJobsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myJobsTableVIew;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bidBtn;
@property (weak, nonatomic) IBOutlet UIButton *completedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *activeImgLine;
@property (weak, nonatomic) IBOutlet UIImageView *bidImgLine;
@property (weak, nonatomic) IBOutlet UIImageView *CompletedImgLine;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noJobLable;
@property BOOL isfromEmployerProfile;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectionViewHeight;
@property (strong, nonatomic) IBOutlet UIView *selectionView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@end
