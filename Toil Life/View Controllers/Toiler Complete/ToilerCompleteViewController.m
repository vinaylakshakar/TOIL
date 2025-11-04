//
//  ToilerCompleteViewController.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerCompleteViewController.h"

@interface ToilerCompleteViewController ()
{
    LOTAnimationView *animationView;
}
@end

@implementation ToilerCompleteViewController

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

#pragma mark - Button Action

- (IBAction)actionDoneBtn:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ToilerTabBarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerTabbarVC"];
    
    toilerTabBarVC.selectedIndex = 2;
    
    [self.navigationController pushViewController:toilerTabBarVC animated:YES];
    
}

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
