//
//  HNNewsFlowLayout.m
//  Habari News
//
//  Created by edwin bosire on 18/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "SPHGridViewFlowLayout.h"

#define kHEADER_IMAGE_HEIGHT 250.0f

@implementation SPHGridViewFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}


- (UICollectionViewScrollDirection)scrollDirection {
    
    return UICollectionViewScrollDirectionVertical;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGSize)headerReferenceSize{
    return CGSizeMake(320.0f, kHEADER_IMAGE_HEIGHT);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    UICollectionView *collectionView = [self collectionView];
    UIEdgeInsets insets = [collectionView contentInset];
    CGPoint offset = [collectionView contentOffset];
    CGFloat minY = -insets.top;
    
    NSMutableArray *allAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    if (offset.y < minY) {
        
        CGSize  headerSize = [self headerReferenceSize];
        CGFloat deltaY = fabsf(offset.y - minY);
        
        for (UICollectionViewLayoutAttributes *attrs in allAttributes) {
            
            if ([attrs indexPath] == [NSIndexPath indexPathForItem:0 inSection:0]) {
                
                CGRect headerRect = [attrs frame];
                headerRect.size.height = MAX(minY, headerSize.height + deltaY);
                headerRect.origin.y = headerRect.origin.y - deltaY;
                [attrs setFrame:headerRect];
                break;
            }
        }
    }
    
    return allAttributes;
}

@end
