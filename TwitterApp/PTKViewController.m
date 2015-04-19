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

@interface PTKViewController () <PTKTwitterManagerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *twittsTableView;

@property (nonatomic) PTKTwitterManager *twitterManager;

@end

@implementation PTKViewController

- (PTKTwitterManager *)twitterManager {
    return [PTKTwitterManager sharedManager];
}

#pragma mark lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.twitterManager updateTwittsWithCallback:^(BOOL success, NSError *error) {
        if (success) {
            [self.twittsTableView reloadData];
        } else if (error != nil) {
            [PTKErrorHandler handleError:error];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.twitterManager.delegate = self;
}

#pragma mark ui actions methods
- (IBAction)authorizeButtonPressed:(id)sender {
    [self.twitterManager authorizeWithCallback:^(BOOL success, NSError *error) {
        if (success) {
            [self updateTwitts];
        }    }];
}

#pragma mark table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.twitterManager.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *twitterCellReusingID = @"twitter_cell_reusing_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twitterCellReusingID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twitterCellReusingID];
    }
    PTKTwitt *twitt = [self.twitterManager twittAtIndex:indexPath.row];
    cell.textLabel.text = twitt.text;
    return cell;
}

#pragma mark twitter manager delegate methods
- (void)twitterManagerNeedToPresentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark private menthods
- (void)updateTwitts {
    [self.twitterManager updateTwittsWithCallback:^(BOOL success, NSError *error) {
        if (success) {
            [self.twittsTableView reloadData];
        } else if (error != nil) {
            [PTKErrorHandler handleError:error];
        }
    }];
}

@end
