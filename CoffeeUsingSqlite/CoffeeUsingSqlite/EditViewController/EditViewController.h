//
//  EditViewController.h
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 01/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coffee.h"

@interface EditViewController : UIViewController
{
    UITextField *txtField;
    NSString *keyOfTheFieldToEdit;
    NSString *editValue;
    id objectToEdit;
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;
@property (nonatomic, retain) Coffee *coffeeObj;

- (void) save_Clicked:(id)sender;
- (void) cancel_Clicked:(id)sender;


@end
