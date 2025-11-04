//
//  EditOccupationViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 23/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditOccupationViewController : UIViewController
{
   
}

@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *farmBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *choresBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet UIButton *oddJobsBtn;
@property (strong, nonatomic) NSMutableArray *occupationArray;
@property (weak, nonatomic) NSMutableDictionary *profileDict;


@end
