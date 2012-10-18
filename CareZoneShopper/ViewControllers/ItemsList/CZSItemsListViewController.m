//
//  CZSItemsListViewController.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 17.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSItemsListViewController.h"
#import "CZSBusiness.h"
#import "CZSItem.h"
#import "CZSEditItemViewController.h"
#import "SSPullToRefresh.h"
#import "CZSNetworkEngine.h"

static NSString *const kEditItemSegue = @"kEditItemSegue";

@interface CZSItemsListViewController () <UITableViewDataSource,
                                          UITableViewDelegate,
                                          SSPullToRefreshViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetcher;
@property (nonatomic, strong) MKNetworkOperation *operation;

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation CZSItemsListViewController

- (void)dealloc {
    [self.operation cancel];
    self.operation = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected) {
        [self.tableView deselectRowAtIndexPath:selected animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.operation cancel];
    self.operation = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.pullToRefreshView finishLoading];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.fetcher = nil;
    self.pullToRefreshView = nil;
}

- (NSFetchedResultsController *)fetcher {
    if (_fetcher == nil) {
        _fetcher = [CZSItem MR_fetchAllGroupedBy:@"category"
                                   withPredicate:nil
                                        sortedBy:@"category,name"
                                       ascending:YES];
    }
    return _fetcher;
}

- (void)reloadData {
    [self.operation cancel];
    __weak CZSItemsListViewController *weakSelf = self;
    self.operation = [[CZSNetworkEngine sharedEngine] listOfItemsWithCompletion:^(NSArray *items) {
        CZSItemsListViewController *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.pullToRefreshView finishLoading];
            [CZSItem MR_truncateAll];
            [[CZSBusiness sharedInstance] itemsFromNetworkArray:items];
            [[NSManagedObjectContext MR_defaultContext] MR_saveNestedContextsErrorHandler:^(NSError *error) {
                NSLog(@"Save error: %@", error.userInfo);
            } completion:^{
                [strongSelf.fetcher performFetch:nil];
                [strongSelf.tableView reloadData];
            }];
        }
    } onError:^(NSError *error) {
        [UIAlertView showWithError:error];
        CZSItemsListViewController *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.pullToRefreshView finishLoading];
        }
    }];
}

#pragma mark - Actions

- (IBAction)addTapped:(id)sender {
    [self performSegueWithIdentifier:kEditItemSegue sender:nil];
}

#pragma mark - SSPullToRefreshViewDelegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self.pullToRefreshView startLoading];
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetcher sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetcher sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    CZSItem *item = [self.fetcher objectAtIndexPath:indexPath];
    cell.textLabel.text = item.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetcher sections] objectAtIndex:section];
    return [sectionInfo name];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CZSItem *item = [self.fetcher objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kEditItemSegue sender:item];
}

#pragma mark - Seques

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kEditItemSegue]) {
        [(CZSEditItemViewController *)segue.destinationViewController setItem:sender];
    }
}

@end
