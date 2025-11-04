//
//  EmployerBidViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerBidViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UITableView *bidTableView;
@property (weak, nonatomic) IBOutlet UIButton *highestRatedBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *lowestBidBtn;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIView *lowestBidView;
@property (weak, nonatomic) IBOutlet UIView *mostRecentView;

@property (weak, nonatomic) IBOutlet UIButton *mostRecentBtn;
@property (weak, nonatomic) IBOutlet UIView *highestRatedView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *noBidLabel;

@end
