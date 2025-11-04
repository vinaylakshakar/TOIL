//
//  InvitesViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *invitesTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noJobLabel;

@end
