

#import "ToilerDashboardViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ToilerDashboardViewController ()
{
    NSMutableArray *arrWork;
    NSMutableArray *arrKeywords;
    NSMutableArray *arrJobData;
    BOOL isSearching;
    NSArray *filterdArray;
    CLLocationManager *locationManager;
    CLLocation        *currentLocation;
    MKCoordinateRegion region;
    NSMutableArray *annotations;
    BOOL shouldAdjustZoom;
    NSArray *locArray;
    int loccount;
    AppDelegate *del;
}
@end

@implementation ToilerDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    shouldAdjustZoom = YES;
    _blurView.hidden = YES;
    
    annotations = [NSMutableArray new];
    //[_mapView setZoomEnabled:YES];
    
    _filterView.layer.cornerRadius = 12;
    //_headerView.layer.cornerRadius = 6;
    _filterView.clipsToBounds = YES;
    _filterView.layer.borderColor = [Grey_COLOR CGColor];
    _filterView.layer.borderWidth = 1.0f;

    _jobNumberView.layer.borderColor = [ORANGE_COLOR CGColor];
    _jobNumberView.layer.borderWidth = 1.0f;
    _jobNumberView.layer.cornerRadius = 12;
    //_headerView.layer.cornerRadius = 10;
    _jobNumberView.clipsToBounds =YES;

    //alert Effect
    _customAlertView.layer.borderColor = [Grey_COLOR CGColor];
    _customAlertView.layer.borderWidth = 1.0f;
    
    _customAlertView.layer.cornerRadius = 12;
    //_headerView.layer.cornerRadius = 10;
    _customAlertView.clipsToBounds =YES;
    
    arrWork = [[NSMutableArray alloc]init];
    arrKeywords = [[NSMutableArray alloc]init];
    arrJobData = [[NSMutableArray alloc] init];
    filterdArray = [[NSArray alloc]init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER) {
        
        [locationManager requestWhenInUseAuthorization];
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startUpdatingLocation];
    
    _mapViewBtn.hidden = YES;
    _filterView.hidden = YES;
    _listTableView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"ShowToilerAlertView"
                                               object:nil];
    
    [self setSearchBarFont];
}

-(void)setSearchBarFont
{
    if(IS_iPHONE_5)
    {
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setFont:[UIFont fontWithName:@"OpenSans" size:15]];
            }
        }
    }
    else if (IS_STANDARD_IPHONE_6)
    {
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setFont:[UIFont fontWithName:@"OpenSans" size:16]];
            }
        }
    }
    else {
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            }
        }
    }
}

- (void)receiveNotification:(NSNotification *)notification
{
    [self.alertEffectView setHidden:NO];
    NSDictionary* userInfo = notification.userInfo;
   // NSLog(@"%@",userInfo);
    self.alertTextLable.text = [userInfo valueForKey:@"message"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    
    if([self.searchBar.text length] == 0)
    {
        if (del.isSameTabIndex)
        {
            del.isSameTabIndex = false;
        }
        else
        {
             [self GetJobList];
        }
       
    }
  
}

-(void)hideUnhideLable
{
    if (arrWork.count>0) {
        [self.noJobLabel setHidden:YES];
    } else {
        [self.noJobLabel setHidden:NO];
    }
}

#pragma mark- filter jobs from category-

-(void)filterJobsCategory
{
    arrWork = [[NSMutableArray alloc]init];
    
    if (arrKeywords.count>0)
    {
         for (NSString *categoryKeyword in arrKeywords)
         {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Category CONTAINS[cd] %@",categoryKeyword];
                
                filterdArray = [arrJobData filteredArrayUsingPredicate:predicate];
                
                [arrWork addObjectsFromArray:filterdArray];
         }

    } else {
        arrWork = arrJobData;
    }

   self.searchBar.text =@"";
   [self.listTableView reloadData];
   [self getAnnottion];
    
}

#pragma mark - Btns action

- (IBAction)actionOddJobsAction:(UIButton *)sender {
    
    if( _oddJobsBtn.selected){
        _oddJobsBtn.selected = NO;
        [_oddJobView setBackgroundColor: [UIColor whiteColor]];
        _lblOddJobs.textColor = ORANGE_COLOR;
        [arrKeywords removeObject:@"Odd Jobs"];
    }
    else{
        _oddJobsBtn.selected = YES;
        [_oddJobView setBackgroundColor:ORANGE_COLOR];
        _lblOddJobs.textColor = [UIColor whiteColor];
        [arrKeywords addObject:@"Odd Jobs"];
    }
    
}
- (IBAction)actionDeliveryBtn:(UIButton *)sender {
    //Delivery / Moving Person
    if(_deliveryBtn.selected){
    
        _deliveryBtn.selected = NO;
        [_DeliveryView setBackgroundColor:[UIColor whiteColor]];
        _lblDelivery.textColor = ORANGE_COLOR;
        [arrKeywords removeObject:@"Delivery / Moving Person"];
    }
    else{
        
    _deliveryBtn.selected = YES;
    [_DeliveryView setBackgroundColor:ORANGE_COLOR];
     _lblDelivery.textColor = [UIColor whiteColor];
        [arrKeywords addObject:@"Delivery / Moving Person"];
    }
}
- (IBAction)actionMapViewBtn:(UIButton *)sender {
    _listTableView.hidden = YES;
    _mapViewBtn.hidden = YES;
    _listViewBtn.hidden = NO;
    _mapView.hidden = NO;
}

- (IBAction)actionChoresBtn:(UIButton *)sender {
    
    //Household Chores
    if(_choresBtn.selected){
        
        _choresBtn.selected = NO;
        [_choresView setBackgroundColor: [UIColor whiteColor]];
        _lblChores.textColor = ORANGE_COLOR;
        [arrKeywords removeObject:@"Household Chores"];
    }
    else{
    _choresBtn.selected = YES;
         [_choresView setBackgroundColor:ORANGE_COLOR];
    _lblChores.textColor = [UIColor whiteColor];
        [arrKeywords addObject:@"Household Chores"];
    }
}
- (IBAction)actionServiceBtn:(UIButton *)sender {
    
    //Service / Retail Industry
    
    if(_serviceBtn.selected){
        
        _serviceBtn.selected = NO;
        [_serviceView setBackgroundColor:[UIColor whiteColor]];
        _lblService.textColor = ORANGE_COLOR;
        [arrKeywords removeObject:@"Service / Retail Industry"];
        
    }
    else{
    _serviceBtn.selected = YES;
    [_serviceView setBackgroundColor:ORANGE_COLOR];
    _lblService.textColor = [UIColor whiteColor];
        [arrKeywords addObject:@"Service / Retail Industry"];
    }
}
- (IBAction)actionTradesBtn:(UIButton *)sender {
    
    //Trades and Construction
    
    if(_tradesBtn.selected){
        _tradesBtn.selected = NO;
        //_constructionView
        [_constructionView setBackgroundColor:[UIColor whiteColor]];
        _lblConstruction.textColor = ORANGE_COLOR;
        [arrKeywords removeObject:@"Trades and Construction"];
        
    }
    else{
    _tradesBtn.selected = YES;
    //_constructionView
    [_constructionView setBackgroundColor:ORANGE_COLOR];
    _lblConstruction.textColor = [UIColor whiteColor];
        [arrKeywords addObject:@"Trades and Construction"];
    }
}
- (IBAction)actionFarmBtn:(UIButton *)sender {
    
    //Farm Hand
    
    if(_farmBtn.selected){
        _farmBtn.selected = NO;
        [_farmView setBackgroundColor:[UIColor whiteColor]];
        _lblFarm.textColor = ORANGE_COLOR;
        [arrKeywords removeObject:@"Farm Hand"];
    }
    else{
    _farmBtn.selected = YES;
    [_farmView setBackgroundColor:ORANGE_COLOR];
    _lblFarm.textColor = [UIColor whiteColor];
        [arrKeywords addObject:@"Farm Hand"];
    }
}
- (IBAction)actionFilterBtn:(UIButton *)sender {
    
    _filterView.hidden = NO;
    _blurView.hidden = NO;
    
}
- (IBAction)actionCloseBtn:(UIButton *)sender {
    
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    [self filterJobsCategory];
}

- (IBAction)actionVIewBtn:(UIButton *)sender {
    
    _listTableView.hidden = NO;
    _mapViewBtn.hidden = NO;
    _listViewBtn.hidden = YES;
    _mapView.hidden = YES;
    
}


#pragma mark - Table View Delegates and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWork.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]!=nil)
    {
        BidsJobDetailsViewController *BidsJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidsJobDetailsVC"];
        BidsJobDetailsVC.jobBidDetailDict = [[arrWork objectAtIndex:indexPath.row] mutableCopy];
        [self.navigationController pushViewController:BidsJobDetailsVC animated:YES];
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"dashboardCell";
    DashboardTableViewCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *dic = [arrWork objectAtIndex:indexPath.row];
    
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblName.text = [dic valueForKey:@"EmployerName"];
    cell.lblWork.text = [dic valueForKey:@"JobTitle"];
    int rate = [[dic valueForKey:@"EmployerRating"] intValue];
    
    [self addRating:cell :rate];
    
    cell.profilePic.tag = indexPath.row;
  
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"EmployerPic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];

   
    return cell;
}

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

#pragma mark - Custom annotation methods
-(void)getAnnottion{

    [self removeAllAnnotations];
    [_mapView removeAnnotations:annotations];
    [annotations removeAllObjects];
    
 [_mapView addAnnotations:[self annotations]];
    
    [self.listTableView reloadData];
    [kAppDelegate hideProgressHUD];
    
}

-(void)removeAllAnnotations
{
    for (int i =0; i < [_mapView.annotations count]; i++)
    {
        if ([[_mapView.annotations objectAtIndex:i] isKindOfClass:[JPSThumbnailAnnotation class]])
        {
            JPSThumbnailAnnotation *obj = (JPSThumbnailAnnotation *)[_mapView.annotations objectAtIndex:i];
            
            [_mapView removeAnnotation:obj];
        }
    }
    
    
}

- (NSArray *)annotations {
    
    NSLog(@"we are on annotion");
    for (int valcount=0;valcount<arrWork.count;valcount++)
    {
        
        NSMutableDictionary *JobDict = [arrWork objectAtIndex:valcount];
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = [[JobDict objectForKey:@"Latitude"] doubleValue];
        zoomLocation.longitude = [[JobDict objectForKey:@"Longitude"] doubleValue];
        
        
        if(zoomLocation.latitude != 0 && zoomLocation.longitude != 0)
        {
            // Empire State Building
            JPSThumbnail *empire = [[JPSThumbnail alloc] init];
            
            empire.coordinate = zoomLocation;
            NSString *lastItem= [arrWork[valcount] objectForKey:@"EmployerPic"];
//            NSArray *arr = [[arrWork[valcount] objectForKey:@"EmployerPic"] componentsSeparatedByString:@"http://3.214.38.142/UserImages/"];
//            NSString *lastItem = [arr objectAtIndex:1];
            if(lastItem.length>=1)
            {
                NSURL *imageURL = [NSURL URLWithString:[arrWork[valcount] objectForKey:@"EmployerPic"]];
//                NSData *data = [NSData dataWithContentsOfURL:imageURL];
//                UIImage *img = [[UIImage alloc] initWithData:data];
//                [empire setImage:img];
                
                [empire setImage:[UIImage imageNamed:@"pipe"]];
//                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//                    if (data) {
//
//                        UIImage *image = [UIImage imageWithData:data];
//
//                        if (image) {
//
//                            dispatch_async(dispatch_get_main_queue(), ^{
//
//                                 [empire setImage:image];
//
//                            });
//
//                        }
//
//                    }
//
//                }];
                
//                [task resume];
                
                

                 //[empire setImage:[self checkCategories:valcount]];
                 //[empire setImage:[UIImage imageNamed:@"pipe"]];
            }
            else{
                [empire setImage:[self checkCategories:valcount]];
               // [empire setImage:[UIImage imageNamed:@"pipe"]];
            }
            
            [empire setImage:[self checkCategories:valcount]];
            empire.title = [NSString stringWithFormat:@"%@",[arrWork[valcount] objectForKey:@"JobTitle"]];
            
            empire.subtitle = [NSString stringWithFormat:@"$%@",[JobDict objectForKey:@"Budget"]];
            
            empire.coordinate = CLLocationCoordinate2DMake(zoomLocation.latitude, zoomLocation.longitude);
            empire.disclosureBlock = ^{
                
                
                if ([[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]!=nil)
                {
                    BidsJobDetailsViewController *BidsJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidsJobDetailsVC"];
                    BidsJobDetailsVC.jobBidDetailDict = [arrWork objectAtIndex:valcount];
                    [self.navigationController pushViewController:BidsJobDetailsVC animated:YES];
                }
                
            };
            
            
            [annotations addObject:[JPSThumbnailAnnotation annotationWithThumbnail:empire]];
        }
    }
    return [annotations mutableCopy];
    
}


-(UIImage *)checkCategories:(int)index
{
    UIImage *image;
    NSString *category = [arrWork[index] valueForKey:@"Category"];
    if([category isEqualToString:@"Household Chores"])
    {
        image = [UIImage imageNamed:@"Icon_Chores"];
    }
    else if([category isEqualToString:@"Delivery / Moving Person"])
    {
        image = [UIImage imageNamed:@"Icon_Delivery"];
    }
    else if([category isEqualToString:@"Delivery / Moving Person"])
    {
        image = [UIImage imageNamed:@"Icon_Delivery"];
    }
    else if([category isEqualToString:@"Trades and Construction"])
    {
        image = [UIImage imageNamed:@"Icon_Construction"];
    }
    else if([category isEqualToString:@"Farm Hand"])
    {
        image = [UIImage imageNamed:@"Icon_Farm"];
    }
    else if([category isEqualToString:@"Services / Rental Industry"])
    {
        image = [UIImage imageNamed:@"Icon_Service"];
    }
    else
    {
        image = [UIImage imageNamed:@"Icon_Odd_Jobs"];
    }
    return image;
}

#pragma mark- Api method

-(void)GetJobList
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if ([[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]!=nil) {
        [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"toilerid"];
    } else {
        [dict setObject:@"0" forKey:@"toilerid"];
        del.isSameTabIndex =YES;
    }
    
    
    [dict setObject:@"0" forKey:@"radius"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"latitude"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"longitude"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetJobList:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
//             arrJobData = (NSMutableArray *)CFBridgingRelease(CFPropertyListCreateDeepCopy(NULL, (__bridge CFPropertyListRef)(dataArray), kCFPropertyListMutableContainersAndLeaves));
             
             arrJobData = [[object valueForKey:@"data"] mutableCopy];
             arrWork = [[NSMutableArray alloc]initWithArray:arrJobData];
             [self hideUnhideLable];
             NSArray *sortedArray;
             sortedArray = [arrWork sortedArrayUsingComparator: \
                            ^NSComparisonResult(id a, id b) {
                                NSDate *first = [NSDate dateWithTimeIntervalSince1970:([[a valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                NSDate *second = [NSDate dateWithTimeIntervalSince1970:([[b valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                return [second compare:first];
                            }];
             arrWork = [[NSMutableArray alloc]initWithArray:sortedArray];
             
             if (arrWork.count>0) {
                 _numberCount.text = [NSString stringWithFormat:@": %lu",(unsigned long)arrWork.count];
             } else {
                 _numberCount.text = [NSString stringWithFormat:@": N/A"];
             }
            
             [self.listTableView reloadData];
             [self getAnnottion];

             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken];
         }
         
         
         
         
     }
                                           onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)CreateToken
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             [self GetJobList];
             
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

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView2 didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:_mapView];
    }
}

- (void)mapView:(MKMapView *)mapView2 didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:_mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView2 viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:_mapView];
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView1 didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if (shouldAdjustZoom) {
        shouldAdjustZoom =NO;
        MKCoordinateRegion mapRegion;
        mapRegion.center = _mapView.userLocation.coordinate;
        mapRegion.span = MKCoordinateSpanMake(0.01, 0.01 );
        [_mapView setRegion:mapRegion animated: YES];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    currentLocation = newLocation;
    if (shouldAdjustZoom) {
        // Use the manually defined span
        region.span.longitudeDelta  = 0.005;
        region.span.latitudeDelta  = 0.005;
        region.center.latitude = newLocation.coordinate.latitude;
        region.center.longitude = newLocation.coordinate.longitude;
        [_mapView setRegion:region animated:YES];
        [locationManager stopUpdatingLocation];
        if(loccount == 0)
        {
            [self loadMapData];
            loccount = 1;
        }
        
        
    } else {
        // Keep the current span
        MKCoordinateRegion mapRegion = _mapView.region;  // To get the current span
        mapRegion.center = newLocation.coordinate;
        _mapView.region = mapRegion;
        
        
    }
    
}

#pragma mark - Method to load Map data

-(void)loadMapData
{
    
    //    [self makeListEmployeesRequest:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] : [NSString stringWithFormat:@"%f",region.center.latitude]  :[NSString stringWithFormat:@"%f",region.center.longitude] :cat_id completion:^(NSString *result, NSError *err) {
    //
    //        dispatch_sync(dispatch_get_main_queue(), ^{
    //            if (!err && result)
    //            {
    //
    //                SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
    //
    //                NSMutableDictionary *dic=[jsonParser objectWithString:result error:nil];
    //
    //                if (dic)
    //                {
    //                    NSLog(@"%@",dic[@"status"]);
    //
    //
    //                    // play with dic : server response
    //                    if ([dic[@"status"] integerValue] == 1)
    //                    {
    //                        jobsData = [[NSMutableArray alloc] init];
    //
    //                        jobsData = dic[@"jobs"];
    //
    //                        arrDetails = dic[@"jobs"];
    //
    //                        filterdJobArray = [jobsData copy];
    //
    //                        [self getAnnottion];
    //
    //                    }
    //                    else
    //                    {
    //                        [ProgressHUD dismiss];
    //
    //                        [CommonFunctions AlertWithMsg:@"Unable to save details, Please try again later."];
    //                    }
    //                }
    //                else
    //                {
    //                    [ProgressHUD dismiss];
    //                }
    //
    //            }
    //        });
    //
    //    }];
    
}

#pragma mark Searchbar delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if([searchBar.text length] != 0) {
        isSearching = YES;
        // [self searchTableList:searchText];
    }
    else {
        isSearching = NO;
        
       // [self searchTableList:searchBar.text];
    }
    
    // navTitle.text = @"Dashboard";
}

- (void)searchBar:(UISearchBar *)sBar textDidChange:(NSString *)searchText {
    
    
    if([searchText length] != 0) {
        isSearching = YES;
        // [self searchTableList:searchText];
    }
    else {
        isSearching = NO;
        
        arrWork = [arrJobData mutableCopy];
        NSArray *sortedArray;
        sortedArray = [arrWork sortedArrayUsingComparator: \
                       ^NSComparisonResult(id a, id b) {
                           NSDate *first = [NSDate dateWithTimeIntervalSince1970:([[a valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                           NSDate *second = [NSDate dateWithTimeIntervalSince1970:([[b valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                           return [second compare:first];
                       }];
        arrWork = [[NSMutableArray alloc]initWithArray:sortedArray];
        
        
        [self getAnnottion];
    }
    // [self.tblContentList reloadData];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar {
    NSLog(@"Search Clicked");
    [_searchBar resignFirstResponder];
    
    if (![sBar.text isEqualToString:@""])
    {
        [self searchTableList:sBar.text];
    }

   
}
-(void)searchTableList:(NSString *)searchtext
{
    if(isSearching)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"JobTitle CONTAINS[cd] %@ OR EmployerName CONTAINS[cd] %@ OR Category CONTAINS[cd] %@ OR JobDescription CONTAINS[cd] %@",searchtext,searchtext,searchtext,searchtext];
        
        filterdArray = [arrJobData filteredArrayUsingPredicate:predicate];
        arrWork = [filterdArray mutableCopy];
        [self getAnnottion];
    }
    else
    {
        arrWork = [arrJobData mutableCopy];
        
        [self getAnnottion];
    }
    
     [self.listTableView reloadData];
    
}

- (IBAction)closeAlertAction:(id)sender {
    [self.alertEffectView setHidden:YES];
}

- (IBAction)registerUserAction:(id)sender {
    del.isSameTabIndex = false;
    [del RegisterGuestUser];
}


@end
