

#import "ToilerActiveJobDetailsViewController.h"

@interface ToilerActiveJobDetailsViewController ()
{
    NSMutableArray *ImagesArray;
}

@end

@implementation ToilerActiveJobDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    _imgJobImageHeight.constant = screenRect.size.width;
    
    _fileDesputeView.hidden = YES;
    if(IS_iPHONE_5){
        
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 800);
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _fileDesputeView.layer.borderColor = [Grey_COLOR CGColor];
    _fileDesputeView.layer.borderWidth = 1.0f;
    
    _fileDesputeView.layer.cornerRadius = 12;
    _fileDesputeView.clipsToBounds =YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [self.blurView addGestureRecognizer:singleFingerTap];
    
    CALayer *imageLayer = _txtViewFileDespute.layer;
    [imageLayer setCornerRadius:10];
    [imageLayer setBorderWidth:1];
    imageLayer.borderColor=[Grey_COLOR CGColor];
    _blurView.hidden = YES;
    
    //Comment View
    
    _txtViewFileDespute.text = @"What bothering you?";
    _txtViewFileDespute.textColor = Grey_COLOR;
    
    // Do any additional setup after loading the view.
    [self setLayout];
}

-(void)setLayout
{
    self.lblTitle.text = [self.activejobDetailDict valueForKey:@"JobTitle"];
    self.lblJobName.text = [self.activejobDetailDict valueForKey:@"JobTitle"];
    self.txtViewJobDetails.text = [self.activejobDetailDict valueForKey:@"JobDescription"];
    
    CGSize sizeThatFitsTextView = [self.txtViewJobDetails sizeThatFits:CGSizeMake(self.txtViewJobDetails.frame.size.width, MAXFLOAT)];
    
    // self.TextViewHeightConstraint.constant = sizeThatFitsTextView.height;
    self.descViewHeight.constant = sizeThatFitsTextView.height+60;
    self.lblAmount.text = [NSString stringWithFormat:@"$%@",[self.activejobDetailDict valueForKey:@"CurrentBid"]];
    
    [self.jobImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.activejobDetailDict valueForKey:@"Images"] firstObject]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
    ImagesArray = [[self.activejobDetailDict valueForKey:@"Images"] mutableCopy];
    [_jobImagesCollectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}


#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _txtViewFileDespute.text = @"";
    _txtViewFileDespute.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_txtViewFileDespute.text.length == 0){
       // _txtViewFileDespute.textColor = (__bridge UIColor * _Nullable)([Grey_COLOR CGColor]);
        _txtViewFileDespute.text = @"What bothering you?";
        [_txtViewFileDespute resignFirstResponder];
    }
}


#pragma mark - Button Action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)actionCloseBtn:(UIButton *)sender {
    
    _fileDesputeView.hidden = YES;
    _blurView.hidden = YES;
    [self.view endEditing:YES];
    
}
- (IBAction)actionFileDespute:(UIButton *)sender {
    
    if ([_txtViewFileDespute.text isEqualToString:@""])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter reason."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self FileDispute];
    }
//    _fileDesputeView.hidden = YES;
//    _blurView.hidden = YES;
}
- (IBAction)actionPayNow:(UIButton *)sender {
}
- (IBAction)actionPayLater:(UIButton *)sender {
    
    NetworkEngine *sharedNetwork = [NetworkEngine sharedNetworkEngine];
    sharedNetwork.completed = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)actionCompleteBtn:(UIButton *)sender {
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@"Do you want to mark this job complete?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self MarkJobComplete];
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
- (IBAction)actionFIleDespute:(UIButton *)sender {
    _fileDesputeView.hidden = NO;
    _blurView.hidden = NO;
    [_txtViewFileDespute setEditable:YES];
    [_txtViewFileDespute becomeFirstResponder];
}
- (IBAction)actionChatBtn:(UIButton *)sender {
    
    ChatViewController *UserChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserChatVC"];
    UserChatVC.recieverIDStr = [_activejobDetailDict valueForKey:@"UserId"];
    UserChatVC.jobIDStr = [_activejobDetailDict valueForKey:@"Id"];
     //UserChatVC.recieverNameStr = [_activejobDetailDict valueForKey:@"ProfileName"];
    [self.navigationController pushViewController:UserChatVC animated:YES];
    
}

#pragma mark - uiView Delegates

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{

    _fileDesputeView.hidden = YES;
    [self.view endEditing:YES];
    _blurView.hidden = YES;

}


#pragma mark - CollectionView Dalagates and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    return ImagesArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JobImagesViewController *jobImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JobImagesVC"];
    jobImageVC.imageIndex = indexPath.row;
    jobImageVC.jobImagesArray = ImagesArray;
    [self.navigationController pushViewController:jobImageVC animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BidCollectionViewCell *cell = (BidCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"JobImageCell" forIndexPath:indexPath];
    
    [cell.imgJobImages sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ImagesArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
    
    return cell;
}

#pragma mark- Api method

-(void)FileDispute
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[_activejobDetailDict valueForKey:@"UserId"] forKey:@"userid"];
    [dict setObject:[self.activejobDetailDict valueForKey:@"Id"] forKey:@"jobid"];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"disputerid"];
    [dict setObject:self.txtViewFileDespute.text forKey:@"disputetext"];
    
    [[NetworkEngine sharedNetworkEngine]FileDispute:^(id object)
     {
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             _fileDesputeView.hidden = YES;
             _blurView.hidden = YES;
             [_chatBtn setEnabled:false];
             //vinay here-
             [_disputeBtn setEnabled:false];
              [self.view endEditing:YES];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken:@"FileDispute"];
         }
         
         
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}



-(void)MarkJobComplete
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    
    [dict setObject:@"" forKey:@"completeddate"];
    [dict setObject:[self.activejobDetailDict valueForKey:@"Id"] forKey:@"jobid"];
    
    [[NetworkEngine sharedNetworkEngine]MarkJobComplete:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             //vinay here-
//             NetworkEngine *sharedNetwork = [NetworkEngine sharedNetworkEngine];
//             sharedNetwork.completed = YES;
             [self.navigationController popViewControllerAnimated:YES];
             [Utility showAlertMessage:nil message:@"Thank you for completing the job. Funds will appear in you stripe account after 5-7 days when your employer will mark it complete."];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"MarkJobComplete"];
         }
         
     }
                                                onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)CreateToken:(NSString*)type
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             
             if ([type isEqualToString:@"FileDispute"])
             {
                 [self FileDispute];
             } else
             {
                 [self MarkJobComplete];
             }
             
             
             
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

@end

