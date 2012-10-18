//
//  CZSEditItemViewController.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 17.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSEditItemViewController.h"
#import "CZSItem.h"
#import "MBProgressHUD.h"
#import "CZSNetworkEngine.h"

@interface CZSEditItemViewController () <UITextFieldDelegate> {
    __weak IBOutlet UIButton *__deleteButton;
    __weak IBOutlet UITextField *__nameField;
    __weak IBOutlet UITextField *__categoryField;
    __weak IBOutlet UIBarButtonItem *__titleBarItem;
}
@property (nonatomic, strong) MKNetworkOperation *operation;
@end

@implementation CZSEditItemViewController

- (void)dealloc {
    [self.operation cancel];
    self.operation = nil;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.item) { // edit
        __titleBarItem.title = NSLocalizedString(@"Edit", @"title in the top toolbar");
        __deleteButton.hidden = NO;
        __nameField.text = self.item.name;
        __categoryField.text = self.item.category;
    } else { // new
        __titleBarItem.title = NSLocalizedString(@"New", @"title in the top toolbar");
        __deleteButton.hidden = YES;
        __nameField.text = @"";
        __categoryField.text = @"";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.operation cancel];
    self.operation = nil;
}

#pragma mark - Actions

- (IBAction)saveTapped:(id)sender {
    // validate
    if ([__nameField.text isEqualToString:@""] ||
        [__categoryField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"alert title")
                                    message:NSLocalizedString(@"All fields should be filled in.", @"alert message on edit screen")
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel button")
                          otherButtonTitles:nil] show];
        return;
    } // otherwise we should to process changes

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    [self.operation cancel];
    __weak CZSEditItemViewController *weakSelf = self;
    if (self.item) { // edit
        self.operation = [[CZSNetworkEngine sharedEngine] updateItem:self.item
                                                            withName:__nameField.text
                                                            category:__categoryField.text
                                                        onCompletion:^(NSDictionary *item)
                          {
                              CZSEditItemViewController *strongSelf = weakSelf;
                              if (strongSelf) {
                                  [strongSelf dismissViewControllerAnimated:YES completion:nil];
                              }
                          } onError:^(NSError *error) {
                              CZSEditItemViewController *strongSelf = weakSelf;
                              if (strongSelf) {
                                  [MBProgressHUD hideAllHUDsForView:strongSelf.view
                                                           animated:YES];
                              }
                              [UIAlertView showWithError:error];
                          }];
    } else {
        self.operation = [[CZSNetworkEngine sharedEngine] createNewItemWithName:__nameField.text
                                                                       category:__categoryField.text
                                                                   onCompletion:^(NSDictionary *item)
                          {
                              CZSEditItemViewController *strongSelf = weakSelf;
                              if (strongSelf) {
                                  [strongSelf dismissViewControllerAnimated:YES completion:nil];
                              }
                          } onError:^(NSError *error) {
                              CZSEditItemViewController *strongSelf = weakSelf;
                              if (strongSelf) {
                                  [MBProgressHUD hideAllHUDsForView:strongSelf.view
                                                           animated:YES];
                              }
                              [UIAlertView showWithError:error];
                          }];
    }
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteTapped:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    [self.operation cancel];
    __weak CZSEditItemViewController *weakSelf = self;

    self.operation = [[CZSNetworkEngine sharedEngine] deleteItem:self.item
                                                    onCompletion:^(MKNetworkOperation *completedOperation)
                      {
                          CZSEditItemViewController *strongSelf = weakSelf;
                          if (strongSelf) {
                              [strongSelf dismissViewControllerAnimated:YES completion:nil];
                          }
                      } onError:^(NSError *error) {
                          CZSEditItemViewController *strongSelf = weakSelf;
                          if (strongSelf) {
                              [MBProgressHUD hideAllHUDsForView:strongSelf.view
                                                       animated:YES];
                          }
                          [UIAlertView showWithError:error];
                      }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == __categoryField) {
        [__categoryField resignFirstResponder];
        [self saveTapped:nil];
    } else if (textField == __nameField) {
        [__categoryField becomeFirstResponder];
    }
    return YES;
}

@end
