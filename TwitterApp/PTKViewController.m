//
//  ViewController.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/15/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKViewController.h"

#import "PTKTwitterManager.h"
#import "PTKTwitt.h"
#import "PTKErrorHandler.h"
#import "MBProgressHUD.h"

@interface PTKViewController () <PTKTwitterManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *twittsTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic) PTKTwitterManager *twitterManager;

@end

@implementation PTKViewController

- (PTKTwitterManager *)twitterManager {
    return [PTKTwitterManager sharedManager];
}

#pragma mark lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshControlToTableView];
    
    [self updateTweets];
}

- (void)addRefreshControlToTableView {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(updateTweets) forControlEvents:UIControlEventValueChanged];
    [self.twittsTableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.twitterManager.delegate = self;
}

#pragma mark ui actions methods
- (IBAction)authorizeButtonPressed:(id)sender {
    [self.twitterManager authorizeWithCallback:^(BOOL success, NSError *error) {
        if (success) {
            [self updateTweets];
        }    }];
}

- (IBAction)addButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add tweet" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter tweet here";
    }];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *tweet = ((UITextField *)alertController.textFields.firstObject).text;
        [self tryAddTweet:tweet];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.twitterManager.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:self.view.bounds];
    return footerView;
}

#pragma mark table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *twitterCellReusingID = @"twitter_cell_reusing_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twitterCellReusingID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twitterCellReusingID];
    }
    PTKTwitt *tweet = [self.twitterManager twittAtIndex:indexPath.row];
    cell.textLabel.text = tweet.text;
    return cell;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float height = size.height;
    
    float reloadDistance = 20;
    if(y > height + reloadDistance) {
        [self tryLoadMoreTweets];
    }
}

#pragma mark twitter manager delegate methods
- (void)twitterManagerNeedToPresentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark private menthods
- (void)updateTweets {
    [self changeTweetsDataWithTwitterManagerSelector:@selector(updateTweetsWithCallback:) andExtraParamether:nil];
}

- (void)tryLoadMoreTweets {
    if (self.twitterManager.canTryLoadMore) {
        [self changeTweetsDataWithTwitterManagerSelector:@selector(loadMoreTwittsWithCallback:) andExtraParamether:nil];
    }
}

- (void)tryAddTweet:(NSString *)tweet {
    if (tweet != nil && ![tweet  isEqualToString: @""]) {
        [self changeTweetsDataWithTwitterManagerSelector:@selector(addTweet:withCallback:) andExtraParamether:tweet];
    }
}

- (void)changeTweetsDataWithTwitterManagerSelector:(SEL)selector andExtraParamether:(id)extraParamether {
    
    void (^callbackBlock)(BOOL, NSError *) = ^(BOOL success, NSError *error) {
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (success) {
            [self.twittsTableView reloadData];
        } else if (error != nil) {
            [PTKErrorHandler handleError:error];
        }
    };
    
    [self.refreshControl beginRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (extraParamether != nil) {
        [self.twitterManager performSelector:selector withObject:extraParamether withObject:callbackBlock];
    } else {
        [self.twitterManager performSelector:selector withObject:callbackBlock];
    }
}

@end
