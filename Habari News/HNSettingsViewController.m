//
//  HNSettingsViewController.m
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSettingsViewController.h"
#import "HNSettingsFontSizeCell.h"
#import "HNSettingsSectionsCell.h"
#import "HNSettingsHeaderView.h"
#import "UIImage+ImageEffects.h"

#define kSTANDARD_WIDTH 300.0f

static NSString *const reusableCellIdentifier = @"reusableCellIdentifier";
static NSString *const reusableNewsItemSelectors = @"reusableNewsItemSelectors";
static NSString *const reusableHeaderView = @"reusableHeaderView";


typedef NS_OPTIONS(NSInteger, SettingsSection) {
    SettingsSectionFontSize,
    SettingsSectionNewsSections,
};

@interface HNSettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HNSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Settings";
    
    UIImage *backgroundImage = [UIImage imageNamed:@"Stars"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[backgroundImage applyLightEffect]];
    backgroundImageView.frame = self.view.bounds;
    [self.view insertSubview:backgroundImageView belowSubview:self.collectionView];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNSettingsFontSizeCell class]) bundle:nil] forCellWithReuseIdentifier:reusableCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNSettingsSectionsCell class]) bundle:nil] forCellWithReuseIdentifier:reusableNewsItemSelectors];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNSettingsHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableHeaderView];
    
}


#pragma mark - UICollectionView

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        HNSettingsHeaderView *headerView = (HNSettingsHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableHeaderView forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"Font Size";
        }else{
            headerView.titleLabel.text = @"News Categories";
        }
        
        return headerView;
    }
    
    return nil;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == SettingsSectionFontSize && indexPath.section == 0){
        
            HNSettingsFontSizeCell *cell = (HNSettingsFontSizeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reusableCellIdentifier forIndexPath:indexPath];
            return cell;
        }else /*if (indexPath.row == SettingsSectionNewsSections)*/{
            
            HNSettingsSectionsCell *cell = (HNSettingsSectionsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reusableNewsItemSelectors forIndexPath:indexPath];
            return cell;
        }

}

#pragma mark - Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        return CGSizeMake(kSTANDARD_WIDTH, 100.0f);
    }else{
        return CGSizeMake(kSTANDARD_WIDTH, 70 * 7);
    }
}

@end
