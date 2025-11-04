//
//  ToilerDashboardViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ToilerDashboardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *choresView;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *farmView;
@property (weak, nonatomic) IBOutlet UIView *constructionView;
@property (weak, nonatomic) IBOutlet UILabel *lblConstruction;
@property (weak, nonatomic) IBOutlet UILabel *lblFarm;
@property (weak, nonatomic) IBOutlet UILabel *lblChores;
@property (weak, nonatomic) IBOutlet UILabel *lblOddJobs;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;

@property (weak, nonatomic) IBOutlet UILabel *lblDelivery;

@property (weak, nonatomic) IBOutlet UILabel *numberCount;
@property (weak, nonatomic) IBOutlet UILabel *lblService;

@property (weak, nonatomic) IBOutlet UIView *DeliveryView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *oddJobView;

@property (weak, nonatomic) IBOutlet UIButton *mapViewBtn;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *tradesBtn;
@property (weak, nonatomic) IBOutlet UIButton *farmBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *choresBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet UIButton *oddJobsBtn;
@property (weak, nonatomic) IBOutlet UIButton *listViewBtn;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *noJobLabel;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *alertEffectView;
@property (weak, nonatomic) IBOutlet UIView *customAlertView;
@property (weak, nonatomic) IBOutlet UILabel *alertTextLable;
- (IBAction)closeAlertAction:(id)sender;
- (IBAction)registerUserAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *jobNumberView;


@end
