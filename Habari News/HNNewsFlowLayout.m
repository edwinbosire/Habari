//
//  HNNewsFlowLayout.m
//  Habari News
//
//  Created by edwin bosire on 18/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNNewsFlowLayout.h"



@implementation HNNewsFlowLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.sectionInset = UIEdgeInsetsZero;
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = 0.0f;
    
    return self;
}
@end
