//
//  EmployerCompleteViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 12/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EmployerCompleteViewController.h"

@interface EmployerCompleteViewController ()
{
    LOTAnimationView *animationView;
}
@end

@implementation EmployerCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    animationView = [[LOTAnimationView alloc]init];
    animationView = [LOTAnimationView animationNamed:@"data1"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    double newWidth = self.imgComplete.frame.size.width;
    animationView.frame = CGRectMake(0, 0,newWidth, newWidth);
    [self.imgComplete addSubview:animationView];
    [animationView setAnimationSpeed:0.30];
    animationView.loopAnimation = YES;
    [animationView playFromProgress:0.425 toProgress:0.53 withCompletion:nil];

    // Do any additional setup after loading the view.
}

#pragma mark - Button action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDoneButton:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmployerTabbarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerTabbarVC"];
    
    toilerTabBarVC.selectedIndex = 2;
    
    [self.navigationController pushViewController:toilerTabBarVC animated:YES];
    
}


@end
