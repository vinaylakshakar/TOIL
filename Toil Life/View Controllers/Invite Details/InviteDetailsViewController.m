//
//  InviteDetailsViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "InviteDetailsViewController.h"

@interface InviteDetailsViewController ()
{
    NSMutableArray *ImagesArray;
}

@end

@implementation InviteDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_iPHONE_5){
        
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 700);
    }
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        _imgJobImageHeight.constant = screenRect.size.width;
    
    
    
    // Do any additional setup after loading the view.
    [self setLayout];
}

-(void)setLayout
{
    self.lblTitle.text = [_inviteJobDetailDict valueForKey:@"JobTitle"];
    self.lblJobName.text = [_inviteJobDetailDict valueForKey:@"JobTitle"];
    self.txtViewJobDetails.text = [_inviteJobDetailDict valueForKey:@"JobDescription"];
    self.lblBudget.text = [NSString stringWithFormat:@"$%@",[_inviteJobDetailDict valueForKey:@"Budget"]];
    [self.imgJobImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_inviteJobDetailDict valueForKey:@"Images"] firstObject]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
    ImagesArray = [[_inviteJobDetailDict valueForKey:@"Images"] mutableCopy];
    [_jobImageCollectionView reloadData];
}


#pragma mark - Button action

- (IBAction)actionAcceptBtn:(UIButton *)sender {
    
//    [self.navigationController.tabBarController setSelectedIndex:3];
    
    if (![[USERDEFAULTS objectForKey:@"Stripe_Info"] valueForKey:@"stripe_user_id"])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please add your Stripe Account to accept this job."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
       
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                      message:@"Do you want to accept this job?"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                         [self AcceptRejectInvite:@"true"];
                                    }];
        UIAlertAction* CancelButton = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                       
                                    }];
        
        [alert addAction:yesButton];
        [alert addAction:CancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)actionRejectBtn:(UIButton *)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@"Do you want to reject this job?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                     [self AcceptRejectInvite:@"No"];
                                }];
    UIAlertAction* CancelButton = [UIAlertAction actionWithTitle:@"CANCEL"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
    
    [alert addAction:yesButton];
    [alert addAction:CancelButton];
    [self presentViewController:alert animated:YES completion:nil];
   
}
- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Api method

-(void)AcceptRejectInvite:(NSString*)AcceptReject
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    [dict setObject:[_inviteJobDetailDict valueForKey:@"Id"] forKey:@"jobid"];
    [dict setObject:AcceptReject forKey:@"AcceptReject"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]AcceptRejectInvite:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             if ([AcceptReject isEqualToString:@"true"])
             {
             
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                               message:@"You have Accepted This Job Successfully."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self.acceptBtn setEnabled:NO];
                                                 [self.rejectBtn setEnabled:NO];
                                                 [self.navigationController.tabBarController setSelectedIndex:3];
                                             }];
                 
                 [alert addAction:yesButton];
                 [self presentViewController:alert animated:YES completion:nil];
             }
             else
             {
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                               message:@"Job rejected successfully."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
                 
                 [alert addAction:yesButton];
                 [self presentViewController:alert animated:YES completion:nil];
             }
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken:AcceptReject];
         }
         
         
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)CreateToken:(NSString*)AcceptReject
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];

    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             [self AcceptRejectInvite:AcceptReject];
             
         } else
         {
             [kAppDelegate hideProgressHUD];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                            message:[object valueForKey:@"message"]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
             [alert addAction:cancel];
             [self presentViewController:alert animated:YES completion:nil];
         }
         
         
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


#pragma mark - CollectionView Dalagates and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    return ImagesArray.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BidCollectionViewCell *cell = (BidCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"JobImageCell" forIndexPath:indexPath];
    
    [cell.imgJobImages sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ImagesArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _jobImageCollectionView){
        //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JobImagesViewController *jobImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JobImagesVC"];
        jobImageVC.imageIndex = indexPath.row;
        jobImageVC.jobImagesArray = ImagesArray;
        [self.navigationController pushViewController:jobImageVC animated:YES];
    }
}


@end
