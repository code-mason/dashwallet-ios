//
//  Created by Andrew Podkovyrin
//  Copyright © 2020 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DWContactsContentViewController.h"

#import "DWContactsModel.h"
#import "DWFilterHeaderView.h"
#import "DWSharedUIConstants.h"
#import "DWUIKit.h"
#import "DWUserDetailsCell.h"
#import "DWUserDetailsContactCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DWContactsContentViewController () <DWUserDetailsCellDelegate, DWFilterHeaderViewDelegate>

@end

NS_ASSUME_NONNULL_END

@implementation DWContactsContentViewController

- (void)setModel:(DWContactsModel *)model {
    _model = model;
    [model.dataSource setupWithTableView:self.tableView
                     userDetailsDelegate:self
                         emptyDataSource:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor dw_secondaryBackgroundColor];

    self.tableView.backgroundColor = [UIColor dw_secondaryBackgroundColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 74.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, DW_TABBAR_NOTCH, 0.0);

    NSArray<NSString *> *cellIds = @[
        DWUserDetailsCell.dw_reuseIdentifier,
    ];
    for (NSString *cellId in cellIds) {
        UINib *nib = [UINib nibWithNibName:cellId bundle:nil];
        NSParameterAssert(nib);
        [self.tableView registerNib:nib forCellReuseIdentifier:cellId];
    }
    [self.tableView registerClass:DWUserDetailsContactCell.class
           forCellReuseIdentifier:DWUserDetailsContactCell.dw_reuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: return empty state cell
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id<DWUserDetails> item = [self.model.dataSource userDetailsAtIndexPath:indexPath];
    [self.delegate contactsContentViewController:self didSelectUserDetails:item];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    else {
        DWFilterHeaderView *headerView = [[DWFilterHeaderView alloc] initWithFrame:CGRectZero];
        headerView.titleLabel.text = NSLocalizedString(@"My Contacts", nil);
        headerView.delegate = self;

        UIButton *button = headerView.filterButton;
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
        [result beginEditing];
        NSAttributedString *prefix =
            [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Sort by", nil)
                                            attributes:@{
                                                NSForegroundColorAttributeName : [UIColor dw_tertiaryTextColor],
                                                NSFontAttributeName : [UIFont dw_fontForTextStyle:UIFontTextStyleCaption1],
                                            }];
        [result appendAttributedString:prefix];

        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        NSString *optionValue = nil;
        switch (self.model.sortMode) {
            case DWContactsSortMode_ByUsername: {
                optionValue = NSLocalizedString(@"Name", nil);
                break;
            }
        }
        NSAttributedString *option =
            [[NSAttributedString alloc] initWithString:optionValue
                                            attributes:@{
                                                NSForegroundColorAttributeName : [UIColor dw_dashBlueColor],
                                                NSFontAttributeName : [UIFont dw_fontForTextStyle:UIFontTextStyleFootnote],
                                            }];
        [result appendAttributedString:option];
        [result endEditing];
        [button setAttributedTitle:result forState:UIControlStateNormal];

        return headerView;
    }
}

#pragma mark - DWUserDetailsCellDelegate

- (void)userDetailsCell:(DWUserDetailsCell *)cell didAcceptContact:(id<DWUserDetails>)contact {
    [self.model acceptContactRequest:contact];
}

- (void)userDetailsCell:(DWUserDetailsCell *)cell didDeclineContact:(id<DWUserDetails>)contact {
    NSLog(@"DWDP: ignore contact request");
}

#pragma mark - DWFilterHeaderViewDelegate

- (void)filterHeaderView:(DWFilterHeaderView *)view filterButtonAction:(UIView *)sender {
    NSString *title = NSLocalizedString(@"Sort Contacts", nil);
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:title
                         message:nil
                  preferredStyle:UIAlertControllerStyleActionSheet];
    {
        UIAlertAction *action = [UIAlertAction
            actionWithTitle:NSLocalizedString(@"Name", nil)
                      style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction *_Nonnull action) {
                        self.model.sortMode = DWContactsSortMode_ByUsername;
                    }];
        [alert addAction:action];
    }

    {
        UIAlertAction *action = [UIAlertAction
            actionWithTitle:NSLocalizedString(@"Cancel", nil)
                      style:UIAlertActionStyleCancel
                    handler:nil];
        [alert addAction:action];
    }

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = sender;
        alert.popoverPresentationController.sourceRect = sender.bounds;
    }

    [self presentViewController:alert animated:YES completion:nil];
}

@end
