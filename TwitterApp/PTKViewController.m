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

- (void)tryAddTweet:(NSString *)tweet {
    if (tweet != nil && ![tweet  isEqualToString: @""]) {
        PTKViewController *selfCopy = self;
        [self.twitterManager addTweet:tweet withCallback:^(BOOL success, NSError *error) {
            if (success) {
                [selfCopy.twittsTableView reloadData];
            } else if (error != nil) {
                [PTKErrorHandler handleError:error];
            }
        }];
    }
}

@end
