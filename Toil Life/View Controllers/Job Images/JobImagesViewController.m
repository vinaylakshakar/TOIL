//
//  JobImagesViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "JobImagesViewController.h"

@interface JobImagesViewController ()
{
    NSMutableArray* arrJobImages;
}
@end

@implementation JobImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrJobImages = [[NSMutableArray alloc]init];
    arrJobImages = self.jobImagesArray;
    // Do any additional setup after loading the view.

    NSLog(@"%@",arrJobImages);
    if (self.SelectedImage)
    {
            _imgJobImage.image = self.SelectedImage;
    } else
    {
          [_imgJobImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrJobImages objectAtIndex:self.imageIndex]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    }
    
}

#pragma mark - Button Action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CollectionView Dalagates and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    return arrJobImages.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.SelectedImage)
    {
           _imgJobImage.image = [arrJobImages objectAtIndex:indexPath.row];
    }else
    {
          [_imgJobImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrJobImages objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    }
 
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BidCollectionViewCell *cell = (BidCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"JobImageCell" forIndexPath:indexPath];
    
    cell.profilePic.tag = indexPath.row;
    
    if (self.SelectedImage)
    {
        [cell.imgJobImages setImage:[arrJobImages objectAtIndex:indexPath.row]];
    }
    else
    {
         [cell.imgJobImages sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrJobImages objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    }
    

    
    return cell;
}


@end
