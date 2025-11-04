//
//  EmployerOnboarding3ViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 11/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Onboarding3ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *farmBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *choresBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet UIButton *oddJobsBtn;
@property (strong, nonatomic) NSMutableDictionary *toilerInfoDict;
@property (strong, nonatomic) UIImageView *toilerImage;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@end
