

#import "EmployerCompleteJobDetailsViewController.h"

@interface EmployerCompleteJobDetailsViewController ()
{
    NSMutableArray *arrWork;
    NSString *ratingStr;
    NSMutableArray *ImagesArray;
}
@end

@implementation EmployerCompleteJobDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        _imgJobImageHeight.constant = screenRect.size.width;

    
    _rateView.layer.borderColor = [Grey_COLOR CGColor];
    _rateView.layer.borderWidth = 1.0f;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //Init Start
    _rateView.hidden = YES;
    _blurView.hidden = YES;
    
    _rateView.layer.borderColor = [Grey_COLOR CGColor];
    _rateView.layer.borderWidth = 1.0f;
    
    _headerView.layer.borderColor = [Grey_COLOR CGColor];
    _headerView.layer.borderWidth = 1.0f;
    
    arrWork = [[NSMutableArray alloc]init];

    _firstStar.selected = NO;
    _secondStar.selected = NO;
    _thirdStar.selected = NO;
    _fourthStar.selected = NO;
    _fifthStar.selected = NO;
    
    if (_firstStar.selected == NO) {
        _imgFirstStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgSecondStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgThirdStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFourthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFifthStar.image = [UIImage imageNamed:@"Star_Grey"];
    }
    
    //Comment View Border
    
    CALayer *imageLayer = self.txtViewComment.layer;
    [imageLayer setCornerRadius:10];
    [imageLayer setBorderWidth:1];
    imageLayer.borderColor=[Grey_COLOR CGColor];
    
    _rateView.layer.cornerRadius = 12;
    //_headerView.layer.cornerRadius = 6;
    _rateView.clipsToBounds =YES;
    //Comment View
    
    self.txtViewComment.text = @"Comment";
    self.txtViewComment.textColor = Grey_COLOR;
    //_commentView.delegate = self;
    
    //file dispute text
    CALayer *imageLayer2 = _txtViewFileDespute.layer;
    [imageLayer2 setCornerRadius:10];
    [imageLayer2 setBorderWidth:1];
    imageLayer2.borderColor=[Grey_COLOR CGColor];
    
    _fileDesputeView.layer.borderColor = [Grey_COLOR CGColor];
    _fileDesputeView.layer.borderWidth = 1.0f;
   
    _fileDesputeView.layer.cornerRadius = 12;
    _fileDesputeView.clipsToBounds =YES;
    
    if(IS_iPHONE_5){
        
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 720);
    }
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.completedJobDict);
      [self setLayout];
}

-(void)setLayout
{
    self.lblTitle.text = [self.completedJobDict valueForKey:@"JobTitle"];
    self.lblJobName.text = [self.completedJobDict valueForKey:@"JobTitle"];
    self.txtViewJobDetails.text = [self.completedJobDict valueForKey:@"JobDescription"];
    self.lblAmount.text = [NSString stringWithFormat:@"$%@",[self.completedJobDict valueForKey:@"ToilerBidAmount"]];
    if ([[self.completedJobDict valueForKey:@"IsPaymentDone"] boolValue]) {
        [self.makePaymentBtn setEnabled:NO];
    }
    
    [self.jobImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.completedJobDict valueForKey:@"Images"] firstObject]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
    ImagesArray = [[self.completedJobDict valueForKey:@"Images"] mutableCopy];
    [_jobImagesCollectionView reloadData];
}

#pragma mark- Api method

-(void)FileDispute
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[_completedJobDict valueForKey:@"AssignedToilerId"] forKey:@"userid"];
    [dict setObject:[_completedJobDict valueForKey:@"Id"] forKey:@"jobid"];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"disputerid"];
    [dict setObject:self.txtViewFileDespute.text forKey:@"disputetext"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]FileDispute:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             _fileDesputeView.hidden = YES;
             _blurView.hidden = YES;
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


-(void)SaveRating
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"ratebyuserid"];
    [dict setObject:[_completedJobDict valueForKey:@"AssignedToilerId"] forKey:@"ratetouserid"];
    [dict setObject:_txtViewComment.text forKey:@"comment"];
    [dict setObject:ratingStr forKey:@"rating"];
    [dict setObject:@"" forKey:@"createddate"];
    [dict setObject:[_completedJobDict valueForKey:@"Id"] forKey:@"jobid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]SaveRating:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
                 _rateView.hidden = YES;
                 _blurView.hidden = YES;
                 [self.view endEditing:YES];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken:@"SaveRating"];
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
                 [self SaveRating];
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

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _txtViewFileDespute.text = @"";
    _txtViewFileDespute.textColor = [UIColor blackColor];
    self.txtViewComment.text = @"";
    self.txtViewComment.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if (textView==_txtViewFileDespute)
    {
        if(_txtViewFileDespute.text.length == 0){
            _txtViewFileDespute.textColor = (__bridge UIColor * _Nullable)([Grey_COLOR CGColor]);
            _txtViewFileDespute.text = @"What bothering you?";
            [_txtViewFileDespute resignFirstResponder];
        }
    } else
    {
        if(self.txtViewComment.text.length == 0){
            self.txtViewComment.textColor = Grey_COLOR;
            self.txtViewComment.text = @"Comment";
            [self.txtViewComment resignFirstResponder];
        }
        
    }
    

}


#pragma mark - Rating Image Alloc

-(void)addRating:(DashboardTableViewCell *)cell :(int)rating
{
    
    cell.firstStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.secondStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.thirdStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
    
    switch (rating) {
        case 1:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 2:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 3:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 4:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 5:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Selected" ];
            break;
            
        default:
            break;
    }
}

#pragma mark - CollectionView Dalagates and Data Source

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JobImagesViewController *jobImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JobImagesVC"];
    jobImageVC.imageIndex = indexPath.row;
    jobImageVC.jobImagesArray = ImagesArray;
    
    [self.navigationController pushViewController:jobImageVC animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    return ImagesArray.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BidCollectionViewCell *cell = (BidCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"JobImageCell" forIndexPath:indexPath];
    
     [cell.imgJobImages sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ImagesArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
    
    return cell;
}

#pragma mark - Button action

- (IBAction)actionCloseFileDispute:(UIButton *)sender {
    
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
    
}

- (IBAction)showFileDespute:(UIButton *)sender {
    _fileDesputeView.hidden = NO;
    _blurView.hidden = NO;
    [_txtViewFileDespute setEditable:YES];
    [_txtViewFileDespute becomeFirstResponder];
}

- (IBAction)actionRequestPaymentBtn:(UIButton *)sender
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@"Do you want to make payment for this job?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self makePayment];
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

-(void)makePayment
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[_completedJobDict valueForKey:@"Id"] forKey:@"jobid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]MakePaymentByEmployer:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [self.makePaymentBtn setEnabled:NO];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                            message:@"Payment Done Successfully."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
             [alert addAction:cancel];
             [self presentViewController:alert animated:YES completion:nil];

         }
         else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken:@"FileDispute"];
         }
         else
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

- (IBAction)actionRateBtn:(UIButton *)sender {
    _rateView.hidden = NO;
    _blurView.hidden = NO;
    [self.txtViewComment setEditable:YES];
    [self.txtViewComment becomeFirstResponder];
}
- (IBAction)actionCloseBtn:(UIButton *)sender {
    _rateView.hidden = YES;
    _blurView.hidden = YES;
    [self.view endEditing:YES];
}
- (IBAction)actionBidBtn:(id)sender {

    
    if (!ratingStr)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please Select Rating!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([_txtViewComment.text isEqualToString:@""])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter a comment!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        [self SaveRating];
    }
    
}
- (IBAction)actionBackBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionFirstStar:(UIButton *)sender {
    if(!_firstStar.selected){
        _imgFirstStar.image = [UIImage imageNamed:@"Star_Selected"];
        _firstStar.selected = YES;
        _secondStar.selected = NO;
        _thirdStar.selected = NO;
        _fourthStar.selected = NO;
        _fifthStar.selected = NO;
        _imgSecondStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgThirdStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFourthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFifthStar.image = [UIImage imageNamed:@"Star_Grey"];
    }
    else{
        _firstStar.selected = YES;
        _secondStar.selected = NO;
        _thirdStar.selected = NO;
        _fourthStar.selected = NO;
        _fifthStar.selected = NO;
        _imgSecondStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgThirdStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFourthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFifthStar.image = [UIImage imageNamed:@"Star_Grey"];
    }
    
    ratingStr = @"1";
    NSLog(@"%@",ratingStr);
}
- (IBAction)actionSecondStar:(UIButton *)sender {
    if(!_secondStar.selected){
        _imgFirstStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgSecondStar.image = [UIImage imageNamed:@"Star_Selected"];
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        
    }else{
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        _thirdStar.selected = NO;
        _fourthStar.selected = NO;
        _fifthStar.selected = NO;
        //_imgSecondStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgThirdStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFourthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFifthStar.image = [UIImage imageNamed:@"Star_Grey"];
        
    }
    
    ratingStr = @"2";
    NSLog(@"%@",ratingStr);
}
- (IBAction)actionThirdStar:(UIButton *)sender {
    if(!_thirdStar.selected){
        _imgSecondStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgThirdStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgFirstStar.image = [UIImage imageNamed:@"Star_Selected"];
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        _thirdStar.selected = YES;
        
    }else{
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        _thirdStar.selected = YES;
        _fourthStar.selected = NO;
        _fifthStar.selected = NO;
        //_imgThirdStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFourthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFifthStar.image = [UIImage imageNamed:@"Star_Grey"];
        
        
    }
    
    ratingStr = @"3";
    NSLog(@"%@",ratingStr);
}
- (IBAction)actionFourthStar:(UIButton *)sender {
    if(!_fourthStar.selected){
        _imgFourthStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgSecondStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgThirdStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgFirstStar.image = [UIImage imageNamed:@"Star_Selected"];
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        _thirdStar.selected = YES;
        _fourthStar.selected = YES;
    }else{
        //_imgFourthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _imgFifthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        _thirdStar.selected = YES;
        _fourthStar.selected = YES;
        _fifthStar.selected = NO;
        
        
    }
    
    ratingStr = @"4";
    NSLog(@"%@",ratingStr);
}
- (IBAction)actionFifthStar:(UIButton *)sender {
    if(!_fifthStar.selected){
        _imgFirstStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgSecondStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgThirdStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgFourthStar.image = [UIImage imageNamed:@"Star_Selected"];
        _imgFifthStar.image = [UIImage imageNamed:@"Star_Selected"];
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        _thirdStar.selected = YES;
        _fourthStar.selected = YES;
        _fifthStar.selected = YES;
    }else{
        //_imgFifthStar.image = [UIImage imageNamed:@"Star_Grey"];
        _firstStar.selected = YES;
        _secondStar.selected = YES;
        _thirdStar.selected = YES;
        _fourthStar.selected = YES;
        _fifthStar.selected = YES;
        
        
    }
    
    ratingStr = @"5";
    NSLog(@"%@",ratingStr);
}

@end
