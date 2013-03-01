//
//  TVHRecordingsViewController.m
//  TVHeadend iPhone Client
//
//  Created by zipleen on 2/27/13.
//  Copyright (c) 2013 zipleen. All rights reserved.
//

#import "TVHRecordingsViewController.h"
#import "CKRefreshControl.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "TVHDvrItem.h"

@interface TVHRecordingsViewController ()
@property (weak, nonatomic) TVHDvrStore *dvrStore;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TVHRecordingsViewController
@synthesize dvrStore = _dvrStore;

- (TVHDvrStore*) dvrStore {
    if ( _dvrStore == nil) {
        _dvrStore = [TVHDvrStore sharedInstance];
    }
    return _dvrStore;
}

- (void) receiveDvrNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"didSuccessDvrAction"] ) {
        if ( [notification.object isEqualToString:@"deleteEntry"]) {
            WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:NSLocalizedString(@"Succesfully Deleted Recording", nil)];
            [notice show];
        }
        else if([notification.object isEqualToString:@"cancelEntry"]) {
            WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:NSLocalizedString(@"Succesfully Canceled Recording", nil)];
            [notice show];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.dvrStore setDelegate:self];
    [self.dvrStore fetchDvr];
    
    //pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefreshViewShouldRefresh) forControlEvents:UIControlEventValueChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDvrNotification:)
                                                 name:@"didSuccessDvrAction"
                                               object:nil];
    
    //self.segmentedControl.arrowHeightFactor *= -1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dvrStore count:self.segmentedControl.selectedSegmentIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecordStoreTableItems";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TVHDvrItem *dvrItem = [self.dvrStore objectAtIndex:indexPath.row forType:self.segmentedControl.selectedSegmentIndex];
    
    cell.textLabel.text = dvrItem.title;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        TVHDvrItem *dvrItem = [self.dvrStore objectAtIndex:indexPath.row forType:self.segmentedControl.selectedSegmentIndex];
        if ( self.segmentedControl.selectedSegmentIndex == 0 ) {
            [dvrItem cancelRecording];
        }
        if ( self.segmentedControl.selectedSegmentIndex == 1 || self.segmentedControl.selectedSegmentIndex == 2 ) {
            [dvrItem deleteRecording];
        }
        
        
        // because our recordings aren't really deleted right away, we won't have cute animations because we want confirmation that the recording was in fact removed
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
     
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setSegmentedControl:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (IBAction)segmentedDidChange:(id)sender {
    
    [self.tableView reloadData];
}

- (void)pullToRefreshViewShouldRefresh
{
    [self.dvrStore fetchDvr];
}

- (void)didLoadDvr {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didErrorDvrStore:(NSError *)error {
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:NSLocalizedString(@"Network Error", nil) message:error.description];
    [notice setSticky:true];
    [notice show];
    [self.refreshControl endRefreshing];
}
@end