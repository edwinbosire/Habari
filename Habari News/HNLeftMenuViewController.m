//
//  HNLeftMenuViewController.m
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNLeftMenuViewController.h"

// Viewcontrollers
#import "HNSettingsViewController.h"
#import "HNGenericNewsViewController.h"
#import "RESideMenu.h"

//Categories
#import "UIImage+ImageEffects.h"

#import "HNClient.h"
#import "HNSection.h"

@interface HNLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;

//viewcontrollers
@property (nonatomic, strong) HNGenericNewsViewController *genericNewsListViewController;

@property (nonatomic) NSArray *sectionItems;
@end

@implementation HNLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self reloadData];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 6) / 2.0f, self.view.frame.size.width, 54 * 6) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 110);
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"ReloadLeftMenuItems" object:nil];
}



- (void)reloadData {
    
    self.sectionItems = [HNSection fetchSectionsToBeShown];

}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return  (sectionIndex == 0) ? [self.sectionItems count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    HNSection *sectionItem = self.sectionItems[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];

    }
    
    if (indexPath.section == 0){
        
        cell.textLabel.text = sectionItem.title;
    } else{
        
//        cell.imageView.image = [UIImage imageNamed:@"IconSettings"];
        cell.textLabel.text = @"Settings";
    }
    return cell;
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HNSection *sectionItem = self.sectionItems[indexPath.row];

    if (indexPath.section == 0){
        
//        if (!sectionItem.contentViewController) {
//            HNGenericNewsViewController *listViewController = [[HNGenericNewsViewController alloc] initWithItem:sectionItem];
//            sectionItem.contentViewController = listViewController;
//        }
        HNGenericNewsViewController *newsListViewController = [[HNGenericNewsViewController alloc] initWithItem:sectionItem];
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:newsListViewController];

        [self.sideMenuViewController hideMenuViewController];
               
    }else{
        
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[HNSettingsViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
       
    }
}



@end
