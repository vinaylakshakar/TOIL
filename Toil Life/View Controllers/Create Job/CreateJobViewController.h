

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface CreateJobViewController : UIViewController<UICollectionViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSString *latitute;
    NSString *longitude;
    NSMutableArray *searchArr;
    MKCoordinateRegion searchedRegion;
     IBOutlet UIScrollView *mainScl;
}

@property (strong, nonatomic) NSMutableArray *getUserCards;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;
@property (weak, nonatomic) IBOutlet UITableView *addressTblView;

@property (weak, nonatomic) IBOutlet UILabel *lblStrLength;


@property (weak, nonatomic) IBOutlet UIButton *selectCategoryBtn;
@property (weak, nonatomic) IBOutlet UITextView *txtViewJobDescription;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *lblConstruction;
@property (weak, nonatomic) IBOutlet UILabel *lblFarm;
@property (weak, nonatomic) IBOutlet UILabel *lblChores;
@property (weak, nonatomic) IBOutlet UILabel *lblOddJobs;
@property (weak, nonatomic) IBOutlet UILabel *lblDelivery;
@property (weak, nonatomic) IBOutlet UILabel *lblService;


@property (weak, nonatomic) IBOutlet UITextField *txtJobTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtBudget;
@property (weak, nonatomic) IBOutlet UITextField *txtEndJob;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;


@property (weak, nonatomic) IBOutlet UICollectionView *toilerImageCollectionView;

@property (weak, nonatomic) IBOutlet UIView *DeliveryView;
@property (weak, nonatomic) IBOutlet UIView *oddJobView;
@property (weak, nonatomic) IBOutlet UIView *choresView;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *farmView;
@property (weak, nonatomic) IBOutlet UIView *constructionView;
@property (weak, nonatomic) IBOutlet UIView *filterView;



@property (weak, nonatomic) IBOutlet UIButton *tradesBtn;
@property (weak, nonatomic) IBOutlet UIButton *farmBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *choresBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet UIButton *oddJobsBtn;
@property (nonatomic)bool isForEditJob;
@property (weak, nonatomic) NSMutableDictionary *editJobDict;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;

@end
