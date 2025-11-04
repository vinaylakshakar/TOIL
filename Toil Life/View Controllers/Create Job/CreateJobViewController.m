

#import "CreateJobViewController.h"
#import "AppDelegate.h"

@interface CreateJobViewController ()
{
    NSMutableArray *arrPics;
    int strLenght;
    NSString *dateCreatedJob;
    NSMutableDictionary *jobdataDict;
    UIDatePicker *DatePicker;
}
@end

@implementation CreateJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _getUserCards = [[NSMutableArray alloc]init];
    jobdataDict =[[NSMutableDictionary alloc]init];
    if(IS_iPHONE_5){
        [_txtViewJobDescription setFont:[UIFont fontWithName:@"OpenSans" size:13]];
         mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 750);
    }
    NSLog(@"this is for create jobviewController");
    
    arrPics = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    
    _filterView.layer.cornerRadius = 12;
    //_headerView.layer.cornerRadius = 6;
    _filterView.clipsToBounds =YES;
    _filterView.layer.borderColor = [Grey_COLOR CGColor];
    _filterView.layer.borderWidth = 1.0f;
    
    // Do any additional setup after loading the view.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateCreatedJob = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateCreatedJob); // 2012-02-08
    [_selectCategoryBtn setTitle: @"Select" forState: UIControlStateNormal];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.barTintColor = [UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(1/255.0) alpha:1];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            barButton
                            ];
    [numberToolbar sizeToFit];
    barButton.tintColor = [UIColor whiteColor];
    _txtBudget.inputAccessoryView = numberToolbar;
    
    if (self.isForEditJob==YES) {
        [self setLayOut];
    }
    
    //vinay here-
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.txtEndJob setInputView:datePicker];
    _txtBudget.delegate = self;
    
}

-(void)updateTextField:(id)sender
{
    DatePicker = (UIDatePicker*)self.txtEndJob.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   // [dateFormat setDateFormat:@"yyyy-MM-dd"];
    //vinay here-
    [dateFormat setDateFormat:@"dd MMMM YYYY"];
    NSString *theDate = [dateFormat stringFromDate:DatePicker.date];
    self.txtEndJob.text = [NSString stringWithFormat:@"%@",theDate];
}


-(void)viewWillAppear:(BOOL)animated
{
     [self getAllCard];
}
-(void)doneWithNumberPad{
    [_txtBudget resignFirstResponder];
}

-(void)setLayOut
{
    [self.postBtn setImage:[UIImage imageNamed:@"Button_Update"] forState:UIControlStateNormal];
    [self.postBtn setImage:[UIImage imageNamed:@"Button_Update_Selected"] forState:UIControlStateHighlighted];
    
    self.navigationTitle.text =@"Edit Job";
    
    self.txtJobTitle.text = [self.editJobDict valueForKey:@"JobTitle"];
    //_selectCategoryBtn.titleLabel.text = [self.editJobDict valueForKey:@"Category"];
    [self.selectCategoryBtn setTitle:[self.editJobDict valueForKey:@"Category"] forState:UIControlStateNormal];
    _txtViewJobDescription.text = [self.editJobDict valueForKey:@"JobDescription"];
    _txtBudget.text = [self.editJobDict valueForKey:@"Budget"];
    
    NSMutableArray *imageArray = [[self.editJobDict valueForKey:@"Images"] mutableCopy];
    
    for (int index=0;index<imageArray.count;index++ )
    {
        UIImageView *imageView =[[UIImageView alloc]init];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:index]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [arrPics addObject:image];
            
            if (imageArray.count==arrPics.count) {
                [self.toilerImageCollectionView reloadData];
            }
        }];
    }
}



#pragma mark - Text Field Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        _addressTblView.hidden = YES;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if(textField == _txtJobTitle){
        // Prevent crashing undo bug – see note below.
          strLenght = (int)_txtJobTitle.text.length;
        //_lblStrLength.text = [NSString stringWithFormat:@"%i", strLenght];
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength<=30) {
          _lblStrLength.text = [NSString stringWithFormat:@"%lu", (unsigned long)newLength];
        }
        return newLength <= 30;
    }
    return YES;
}

#pragma mark - Collection View Delegates and Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JobImagesViewController *jobImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JobImagesVC"];
    jobImageVC.jobImagesArray = arrPics;
    jobImageVC.SelectedImage = [arrPics objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:jobImageVC animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return arrPics.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SendInviteCell";
    
    BidCollectionViewCell *cell = (BidCollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.imgToiler setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    cell.imgToiler.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.imgToiler.image = arrPics[indexPath.row];
    
    cell.deleteImage.tag = indexPath.row;
    [cell.deleteImage addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteImage setHidden:NO];
    
    return cell;
}

- (IBAction)deleteImage:(id)sender
{
    [arrPics removeObjectAtIndex:[sender tag]];
    [_toilerImageCollectionView reloadData];
    //Write a code you want to execute on buttons click event
}

#pragma mark - button action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionPostJob:(UIButton *)sender {
    
    if([_selectCategoryBtn.titleLabel.text isEqualToString:@"Select"]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please select a category."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        if([_txtBudget.text isEqualToString:@""]){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                           message:@"Please enter budget."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        else{
            if([_txtViewAddress.text isEqualToString:@"Add Location"]||[_txtViewAddress.text isEqualToString:@""]){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                               message:@"Please enter address."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        else{
            if([_txtJobTitle.text isEqualToString:@""]){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                               message:@"Please enter a job title."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else{
                if([_txtViewJobDescription.text isEqualToString:@""]){
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                                   message:@"Please enter job description."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else if([_txtEndJob.text isEqualToString:@""]){
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                                   message:@"Please Select End Job."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }else
                {
                    LoginProcess *sharedManager = [LoginProcess sharedManager];
                    bool budgetValidate = [sharedManager validateBudget:_txtBudget];
                    if(budgetValidate){
                        
                        [jobdataDict setObject:self.txtJobTitle.text forKey:@"JobTitle"];
                        [jobdataDict setObject:_selectCategoryBtn.titleLabel.text forKey:@"Category"];
                        [jobdataDict setObject:_txtViewJobDescription.text forKey:@"JobDescription"];
                        [jobdataDict setObject:_txtBudget.text forKey:@"Budget"];
                        //vinay here-
                        NSTimeInterval seconds = [DatePicker.date timeIntervalSince1970];
                        double milliseconds = seconds*1000;
                        NSString *milisecondStr = [NSString stringWithFormat:@"%.0f",milliseconds];
                        [jobdataDict setObject:milisecondStr forKey:@"EndDate"];
                        
                                     if(_getUserCards.count<1)
                                     {
                                         
                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                                                        message:@"Please provide payment information to create a job."
                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Proceed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                                              {
                                             CreditCardViewController *sendInviteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
                                             sendInviteVC.cardDelegate = self;
                                             sendInviteVC.fromCreateJob = true;
                                             [self.navigationController pushViewController:sendInviteVC animated:YES];
                                         }];
                                         
                                         UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                                         
                                         [alert addAction:ok];
                                         [alert addAction:cancel];
                                         [self presentViewController:alert animated:YES completion:nil];
                                         
                                         
                                        
                                     }else
                                     {
                                          [self CreatejobWithImage];
                                     }
                        
  
                    }
                    else{
                        
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                                       message:@"Please enter valid budget"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
            }
        }
        }
    }
    
}

#pragma mark - Multipart Api Method


- (void)CreatejobWithImage {
    
//    if(arrPics.count>0)
    {
        
        NSMutableDictionary *editDict = [[NSMutableDictionary alloc]init];
        [editDict setObject:[jobdataDict objectForKey:@"JobTitle"] forKey:@"JobTitle"];
        [editDict setObject:[jobdataDict objectForKey:@"Category"] forKey:@"Category"];
        [editDict setObject:[jobdataDict objectForKey:@"Budget"] forKey:@"Budget"];
        //vinay here-
        [editDict setObject:[jobdataDict objectForKey:@"EndDate"] forKey:@"EndDate"];
        [editDict setObject:[jobdataDict objectForKey:@"JobDescription"] forKey:@"JobDescription"];
        
         
         [editDict setObject:arrPics forKey:@"ImagesArray"];
        if(self.isForEditJob)
        {
         [editDict setObject:@"1" forKey:@"isForEditJob"];
        [editDict setObject:[self.editJobDict valueForKey:@"Id"] forKey:@"Id"];
        }
        else{
            [editDict setObject:@"0" forKey:@"isForEditJob"];
        }
        
        [editDict setObject:latitute forKey:@"Latitude"];
        [editDict setObject:longitude forKey:@"Longitude"];

        [kAppDelegate showProgressHUD];
        [[NetworkEngine sharedNetworkEngine]PostJobMultipartWithImages:^(id object) {
            
            if ([object[@"status"] integerValue]==1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [kAppDelegate hideProgressHUD];
                    if ([object[@"status"] integerValue]==1) {
                        
                        // UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        NetworkEngine *sharedNetwork = [NetworkEngine sharedNetworkEngine];
                        
                        if (self.isForEditJob==YES)
                        {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            sharedNetwork.posted = YES;
                        } else {
                            [kAppDelegate hideProgressHUD];
                            sharedNetwork.posted = YES;
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    else if ([[object valueForKey:@"message"] isEqualToString:@"Can not edit job!"])
                    {
                        [kAppDelegate hideProgressHUD];
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                                       message:@"Cannot edit this job as bid has already started."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                        //[self.navigationController popViewControllerAnimated:YES];
                    }
                });
                
                
                
            }
            else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
            {
                
                [self CreateToken:@"postjob"];
            }
            
        } onError:^(NSError *error) {
            NSLog(@"Error : %@",error);
        } params:editDict];
        
        
    }
//    else
//    {
//
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
//                                                                       message:@"Please Select Image."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}

-(void)CreateToken:(NSString *)name
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             if([name isEqualToString:@"getCards"])
             {
                 
             }
             else{
             [self CreatejobWithImage];
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

- (IBAction)actionCloseBtn:(UIButton *)sender {
    _filterView.hidden = YES;
    _blurView.hidden = YES;
}
- (IBAction)actionSelectCategory:(id)sender {
    _filterView.hidden = NO;
    _blurView.hidden = NO;
}
- (IBAction)actionTradeBtn:(UIButton *)sender {
    _tradesBtn.selected = YES;
    _farmBtn.selected = NO;
    _serviceBtn.selected = NO;
    _choresBtn.selected = NO;
    _deliveryBtn.selected = NO;
    _oddJobsBtn.selected = NO;
    
    _constructionView.backgroundColor = ORANGE_COLOR;
    _lblConstruction.textColor = [UIColor whiteColor];
    _farmView.backgroundColor = [UIColor whiteColor];
    _lblFarm.textColor = ORANGE_COLOR;
    _serviceView.backgroundColor = [UIColor whiteColor];
    _lblService.textColor = ORANGE_COLOR;
    _choresView.backgroundColor = [UIColor whiteColor];
    _lblChores.textColor = ORANGE_COLOR;
    _oddJobView.backgroundColor = [UIColor whiteColor];
    _lblOddJobs.textColor = ORANGE_COLOR;
    _DeliveryView.backgroundColor = [UIColor whiteColor];
    _lblDelivery.textColor = ORANGE_COLOR;
    [_selectCategoryBtn setTitle: @"Trades and Construction" forState: UIControlStateNormal];
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    
}
- (IBAction)actionFarmBtn:(UIButton *)sender {
    _tradesBtn.selected = NO;
    _farmBtn.selected = YES;
    _serviceBtn.selected = NO;
    _choresBtn.selected = NO;
    _deliveryBtn.selected = NO;
    _oddJobsBtn.selected = NO;
    
    _constructionView.backgroundColor = [UIColor whiteColor];
    _lblConstruction.textColor = ORANGE_COLOR;
    _farmView.backgroundColor = ORANGE_COLOR;
    _lblFarm.textColor = [UIColor whiteColor];
    _serviceView.backgroundColor = [UIColor whiteColor];
    _lblService.textColor = ORANGE_COLOR;
    _choresView.backgroundColor = [UIColor whiteColor];
    _lblChores.textColor = ORANGE_COLOR;
    _oddJobView.backgroundColor = [UIColor whiteColor];
    _lblOddJobs.textColor = ORANGE_COLOR;
    _DeliveryView.backgroundColor = [UIColor whiteColor];
    _lblDelivery.textColor = ORANGE_COLOR;
    [_selectCategoryBtn setTitle: @"Farm Hand" forState: UIControlStateNormal];
    _filterView.hidden = YES;
    _blurView.hidden = YES;
}
- (IBAction)actionServiceBtn:(UIButton *)sender {
    _tradesBtn.selected = NO;
    _farmBtn.selected = NO;
    _serviceBtn.selected = YES;
    _choresBtn.selected = NO;
    _deliveryBtn.selected = NO;
    _oddJobsBtn.selected = NO;
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    _constructionView.backgroundColor = [UIColor whiteColor];
    _lblConstruction.textColor = ORANGE_COLOR;
    _farmView.backgroundColor = [UIColor whiteColor];
    _lblFarm.textColor = ORANGE_COLOR;
    _serviceView.backgroundColor = ORANGE_COLOR;
    _lblService.textColor = [UIColor whiteColor];
    _choresView.backgroundColor = [UIColor whiteColor];
    _lblChores.textColor = ORANGE_COLOR;
    _oddJobView.backgroundColor = [UIColor whiteColor];
    _lblOddJobs.textColor = ORANGE_COLOR;
    _DeliveryView.backgroundColor = [UIColor whiteColor];
    _lblDelivery.textColor = ORANGE_COLOR;
    [_selectCategoryBtn setTitle: @"Service / Retail Industry" forState: UIControlStateNormal];
}
- (IBAction)actionChoresBtn:(id)sender {
    _tradesBtn.selected = NO;
    _farmBtn.selected = NO;
    _serviceBtn.selected = NO;
    _choresBtn.selected = YES;
    _deliveryBtn.selected = NO;
    _oddJobsBtn.selected = NO;
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    _constructionView.backgroundColor = [UIColor whiteColor];
    _lblConstruction.textColor = ORANGE_COLOR;
    _farmView.backgroundColor = [UIColor whiteColor];
    _lblFarm.textColor = ORANGE_COLOR;
    _serviceView.backgroundColor = [UIColor whiteColor];
    _lblService.textColor = ORANGE_COLOR;
    _choresView.backgroundColor = ORANGE_COLOR;
    _lblChores.textColor = [UIColor whiteColor];
    _oddJobView.backgroundColor = [UIColor whiteColor];
    _lblOddJobs.textColor = ORANGE_COLOR;
    _DeliveryView.backgroundColor = [UIColor whiteColor];
    _lblDelivery.textColor = ORANGE_COLOR;
    [_selectCategoryBtn setTitle: @"Household Chores" forState: UIControlStateNormal];
    
}
- (IBAction)actionOddJobsBtn:(UIButton *)sender {
    _tradesBtn.selected = NO;
    _farmBtn.selected = NO;
    _serviceBtn.selected = NO;
    _choresBtn.selected = NO;
    _deliveryBtn.selected = NO;
    _oddJobsBtn.selected = YES;
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    _constructionView.backgroundColor = [UIColor whiteColor];
    _lblConstruction.textColor = ORANGE_COLOR;
    _farmView.backgroundColor = [UIColor whiteColor];
    _lblFarm.textColor = ORANGE_COLOR;
    _serviceView.backgroundColor = [UIColor whiteColor];
    _lblService.textColor = ORANGE_COLOR;
    _choresView.backgroundColor = [UIColor whiteColor];
    _lblChores.textColor = ORANGE_COLOR;
    _oddJobView.backgroundColor = ORANGE_COLOR;
    _lblOddJobs.textColor = [UIColor whiteColor];
    _DeliveryView.backgroundColor = [UIColor whiteColor];
    _lblDelivery.textColor = ORANGE_COLOR;
    
    [_selectCategoryBtn setTitle: @"Odd Jobs" forState: UIControlStateNormal];
}
- (IBAction)actionDeliveryBtn:(UIButton *)sender {
    _tradesBtn.selected = NO;
    _farmBtn.selected = NO;
    _serviceBtn.selected = NO;
    _choresBtn.selected = NO;
    _deliveryBtn.selected = YES;
    _oddJobsBtn.selected = NO;
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    _constructionView.backgroundColor = [UIColor whiteColor];
    _lblConstruction.textColor = ORANGE_COLOR;
    _farmView.backgroundColor = [UIColor whiteColor];
    _lblFarm.textColor = ORANGE_COLOR;
    _serviceView.backgroundColor = [UIColor whiteColor];
    _lblService.textColor = ORANGE_COLOR;
    _choresView.backgroundColor = [UIColor whiteColor];
    _lblChores.textColor = ORANGE_COLOR;
    _oddJobView.backgroundColor = [UIColor whiteColor];
    _lblOddJobs.textColor = ORANGE_COLOR;
    _DeliveryView.backgroundColor = ORANGE_COLOR;
    _lblDelivery.textColor = [UIColor whiteColor];
    [_selectCategoryBtn setTitle: @"Delivery / Moving Person" forState: UIControlStateNormal];
    
    
}
- (IBAction)actionAddPhotos:(UIButton *)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // take photo button tapped.
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else{
            [self takePhoto];
            //other action
        }
        
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no PhotoLibrary."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else{
            
            [self choosePhoto];
        }
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma mark –  Custom Methods

-(void)takePhoto{
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate= self;
    
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

-(void)choosePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate= self;
    
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

#pragma mark– Camera Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    
    [arrPics addObject:selectedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [_toilerImageCollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableCell" forIndexPath:indexPath];
    //cell.btnLocation.tag = indexPath.row;
    MKMapItem *mapItem = [searchArr objectAtIndex:indexPath.row];
    cell.lblLocation.text = [NSString stringWithFormat:@"%@",[[mapItem placemark] title]];
    //[cell.btnLocation addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem *mapItem = [searchArr objectAtIndex:indexPath.row];
    
    latitute = [NSString stringWithFormat:@"%f",mapItem.placemark.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f",mapItem.placemark.coordinate.longitude];
    
    _txtViewAddress.text = [NSString stringWithFormat:@"%@",[[mapItem placemark] title]];
    _addressTblView.hidden = YES;
}

#pragma mark - text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == _txtViewAddress)
    {
        if([_txtViewAddress.text isEqualToString:@"Add Location"]){
            
            _txtViewAddress.text = @"";
            _txtViewAddress.textColor = [UIColor darkGrayColor];
            
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView == _txtViewAddress)
    {
        if([_txtViewAddress.text isEqualToString:@""]){
            
            _txtViewAddress.text = @"Add Location";
            _txtViewAddress.textColor = Grey_COLOR;
            _addressTblView.hidden = YES;
        }
    }
    
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(textView == _txtViewAddress)
    {
        if(_txtViewAddress.text.length == 0)
        {
            _addressTblView.hidden = true;
            _txtViewAddress.textColor = Grey_COLOR;
            _txtViewAddress.text = @"Add Location";
            [_txtViewAddress resignFirstResponder];
        }
        else{
            [self SearchText:textView.text];
        }
    }
}



#pragma mark - Custom search Method

-(void)SearchText:(NSString *)text
{
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    NSString *typedData = text;
    if([typedData isEqualToString:@""])
    {}
    else{
        
        [searchRequest setNaturalLanguageQuery:typedData];
        [searchRequest setRegion:searchedRegion];
        
        
        // Create the local search to perform the search
        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
        
        //[ProgressHUD show];
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            if (!error) {
                
                //[ProgressHUD dismiss];
                searchArr = [NSMutableArray arrayWithArray:[response mapItems]];
                
                if(searchArr.count>=1)
                {
                    _addressTblView.hidden  = false;
                    _addressTblView.delegate = self;
                    _addressTblView.dataSource  =self;
                    [_addressTblView reloadData];
                }
                else{
                    _addressTblView.hidden  = true;
                }
                
                
                
                
            } else {
                NSLog(@"Search Request Error: %@", [error localizedDescription]);
            }
        }];
    }
    
}



-(void)getAllCard
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetCardList:^(id object)
     {
         NSLog(@"%@",object);
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             _getUserCards = [object valueForKey:@"data"];
//             if(_getUserCards.count<1)
//             {
//                 CreditCardViewController *sendInviteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
//                 sendInviteVC.cardDelegate = self;
//                 sendInviteVC.fromCreateJob = true;
//                 [self.navigationController pushViewController:sendInviteVC animated:YES];
//             }
             
         }
         else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken:@"getCards"];
         }
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.txtBudget) {
        if ([self.txtBudget.text intValue]<5) {
            self.txtBudget.text = @"";
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                           message:@"Please enter budget minimum $5."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

@end
