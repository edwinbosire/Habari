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
#import "HNLatestNewsViewController.h"
#import "HNBusinessViewController.h"
#import "HNTechViewController.h"
#import "HNSportsViewController.h"

#import "RESideMenu.h"

//Categories
#import "UIImage+ImageEffects.h"

@interface HNLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;

//viewcontrollers
@property (nonatomic, strong) HNLatestNewsViewController *latestViewController;
@property (nonatomic, strong) HNBusinessViewController *businessNewsViewController;
@property (nonatomic, strong) HNTechViewController *techNewsViewController;
@property (nonatomic, strong) HNSportsViewController *sportsNewsViewController;

@end

@implementation HNLeftMenuViewController

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
	
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 110);
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
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
    
    return  (sectionIndex == 0) ? 4 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    if (indexPath.section == 0){
        
        NSArray *titles = @[@"Latest", @"Tech", @"Business", @"Sports"];
        cell.textLabel.text = titles[indexPath.row];
    } else{
        
        cell.textLabel.text = @"Settings";
    }
    return cell;
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        
        switch (indexPath.row) {
            case 0:
                self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:self.latestViewController];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 1:
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:self.techNewsViewController]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 2:
                self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:self.businessNewsViewController];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 3:
                self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:self.sportsNewsViewController];
                [self.sideMenuViewController hideMenuViewController];
                break;
            
            default:
                break;
        }
        
    }else{
        
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[HNSettingsViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
       
    }
}


#pragma mark - Setters

- (HNLatestNewsViewController *)latestViewController{
    if(!_latestViewController){
        _latestViewController = [HNLatestNewsViewController new];
    }
    
    return _latestViewController;
}

- (HNTechViewController *)techNewsViewController{
    if (!_techNewsViewController){
        _techNewsViewController = [HNTechViewController new];
    }
    return _techNewsViewController;
}

- (HNSportsViewController *)sportsNewsViewController{
    if(!_sportsNewsViewController){
        _sportsNewsViewController = [HNSportsViewController new];
    }
    return _sportsNewsViewController;
}

- (HNBusinessViewController *)businessNewsViewController{
    
    if (!_businessNewsViewController){
        _businessNewsViewController = [HNBusinessViewController new];
    }
    return _businessNewsViewController;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
