//
//  HNSettingsSectionsCell.m
//  Habari
//
//  Created by edwin bosire on 20/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSettingsSectionsCell.h"
#import "HNSettingsSectionSelectorCell.h"
#import "HNClient.h"
#import "HNSection.h"


typedef NS_OPTIONS(NSInteger, NewsSection) {
    NewsSectionLatest,
    NewsSectionBusiness,
    NewsSectionTechnology,
    NewsSectionSports,
    NewsSectionCounties,
    NewsSectionBlogsAndOpinion,
    NewsSectionLifeStyle
};

static NSString *const reusableCellIdentifier = @"reusableCellIdentifier";

@interface HNSettingsSectionsCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NewsSection sectionnews;
@property (nonatomic) NSArray *items;
@end

@implementation HNSettingsSectionsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNSettingsSectionSelectorCell class]) bundle:nil] forCellWithReuseIdentifier:reusableCellIdentifier];
    
    self.items = [HNSection fetchAllSections];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HNSettingsSectionSelectorCell *cell = (HNSettingsSectionSelectorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reusableCellIdentifier forIndexPath:indexPath];
    
    HNSection *item = self.items[indexPath.row];
    
    cell.numberBadge.text = [NSString stringWithFormat:@"%i", indexPath.row+1];
    cell.titleLabel.text = item.title;
    cell.backgroundColor = [UIColor colorFromHexCode:item.primaryColor];
    cell.numberBadge.backgroundColor = [UIColor colorFromHexCode:item.secondaryColor];
    cell.checkmarkImage.hidden = !item.show;
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HNSettingsSectionSelectorCell *cell = (HNSettingsSectionSelectorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self selectedStateForCell:cell selected:NO];
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HNSettingsSectionSelectorCell *cell = (HNSettingsSectionSelectorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self selectedStateForCell:cell selected:!cell.checkmarkImage.hidden];

    HNSection *item = self.items[indexPath.row];
    item.show = (cell.checkmarkImage.hidden) ? @NO : @YES;
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadLeftMenuItems" object:nil];
}

- (void)selectedStateForCell:(HNSettingsSectionSelectorCell *)cell selected:(BOOL)selected{
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         if (selected) {
                             cell.checkmarkImage.alpha = 0.0f;
                         }else{
                             cell.checkmarkImage.hidden = selected;
                             cell.checkmarkImage.alpha = 1.0f;
                         }
                         
                     } completion:^(BOOL finished) {
                         cell.checkmarkImage.hidden = selected;

                     }];
}



- (NSString *)titleForEnum:(NewsSection )newsSection{
    
    switch (newsSection) {
        case NewsSectionLatest:
            return @"Latest";
            break;
        case NewsSectionBusiness:{
            return @"Business";

        }
            break;
        case NewsSectionTechnology:{
            return @"Technology";

        }
            break;
        case NewsSectionSports:{
            return @"Sports";

        }
            break;
        case NewsSectionCounties:{
            return @"Counties";

        }
            break;
        case NewsSectionBlogsAndOpinion:{
            return @"Blogs & Opinions";

        }
            break;
        case NewsSectionLifeStyle:{
            return @"Life Style";

        }
            break;
            
    }

}
@end
