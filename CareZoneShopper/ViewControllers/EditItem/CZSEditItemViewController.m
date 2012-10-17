//
//  CZSEditItemViewController.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 17.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSEditItemViewController.h"
#import "CZSItem.h"

@interface CZSEditItemViewController () {
    __weak IBOutlet UITextField *__nameField;
    __weak IBOutlet UITextField *__categoryField;
}
@end

@implementation CZSEditItemViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.item) {
        __nameField.text = self.item.name;
        __categoryField.text = self.item.category;
    }
}

@end
