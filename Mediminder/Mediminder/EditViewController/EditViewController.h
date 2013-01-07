//
//  EditViewController.h
//  Mediminder
//
//  Created by Tiyasi Acharya on 06/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medicine.h"

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
@property (nonatomic, retain) Medicine *coffeeObj;

- (void) save_Clicked:(id)sender;
- (void) cancel_Clicked:(id)sender;

@end