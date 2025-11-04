
#import <UIKit/UIKit.h>

@interface EmployerBidJobDetailsViewController : UIViewController
{
    IBOutlet UIButton *editBtn;
    IBOutlet UIButton *deleteBtn;
    IBOutlet UIButton *viewAllBidBtn;
     IBOutlet UIScrollView *mainScl;
}

@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UITextView *txtViewCurrentBidDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblBudgetAmount;


@property (weak, nonatomic) IBOutlet UICollectionView *topBidCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *jobImagesCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;

@property (weak, nonatomic) NSMutableDictionary *bidJobDetailDict;

- (IBAction)editJobAction:(id)sender;
- (IBAction)deleteJobAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *noBidLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewHeight;


@end
