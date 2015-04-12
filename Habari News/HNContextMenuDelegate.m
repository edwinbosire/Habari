//
//  HNContextMenuDelegate.m
//  Habari
//
//  Created by edwin bosire on 24/02/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "HNContextMenuDelegate.h"

static NSString *const menuCellIdentifier = @"rotationCell";

@interface HNContextMenuDelegate ()
<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate
>
@property (nonatomic, strong) YALContextMenuTableView *tableView;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;

@end

@implementation HNContextMenuDelegate

+ (instancetype) create {
    static id shared = nil;
    if (shared == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[self alloc] init];
        });
    }
    return shared;
}

- (YALContextMenuTableView *)contextMenuView {
    
    // init YALContextMenuTableView tableView
    if (!self.tableView) {
        
        self.tableView = [[YALContextMenuTableView alloc] initWithTableViewDelegateDataSource:self];
        self.tableView.animationDuration = 0.19;
        self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

        //optional - implement custom YALContextMenuTableView custom protocol
        self.tableView.yalDelegate = self;
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.tableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
        
        [self initiateMenuOptions];
    }

    return self.tableView;
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"Email",
                        @"Share on Facebook",
                        @"Share on Twitter",
                        @"Add to favourites",
                        @"View Original"];
    
    self.menuIcons = @[[UIImage imageNamed:@"closeMenu"],
                       [UIImage imageNamed:@"email"],
                       [UIImage imageNamed:@"facebook"],
                       [UIImage imageNamed:@"twitter"],
                       [UIImage imageNamed:@"favourites"],
                       [UIImage imageNamed:@"globe"]];
}

#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView dismisWithIndexPath:indexPath];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
}

@end
