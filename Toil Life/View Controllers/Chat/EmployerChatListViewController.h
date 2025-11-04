//
//  EmployerChatViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerChatListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *listChatTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noChatLable;

@end
