//
//  HNContextMenuDelegate.h
//  Habari
//
//  Created by edwin bosire on 24/02/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"

@interface HNContextMenuDelegate : NSObject

+ (instancetype)create;

- (YALContextMenuTableView *)contextMenuView;

@end
