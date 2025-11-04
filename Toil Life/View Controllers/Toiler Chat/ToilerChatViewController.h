//
//  ToilerChatViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 22/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToilerChatViewController : UIViewController<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listChatTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noChatLable;
@end
