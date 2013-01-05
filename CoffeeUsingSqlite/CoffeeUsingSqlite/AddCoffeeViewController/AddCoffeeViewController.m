//
//  AddCoffeeViewController.m
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 01/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import "AddCoffeeViewController.h"
#import "CoffeeManager.h"

@interface AddCoffeeViewController ()<UITextFieldDelegate>
{
    UITextField *coffeenameTxtFld;
    UITextField *priceTxtFld;
    UIDatePicker *nextMedicineDatePicker;
}
@end

@implementation AddCoffeeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     self.title = @"Add Medicine";
    
    UILabel *coffeeNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 10, 200, 20)];
    [coffeeNameLabel setText:@"Medicine Name"];
    [self.view addSubview:coffeeNameLabel];
    [coffeeNameLabel release];
    
    coffeenameTxtFld=[[UITextField alloc] initWithFrame: CGRectMake(50, 35, 200, 40)];
    [coffeenameTxtFld setBorderStyle:UITextBorderStyleRoundedRect];
    [coffeenameTxtFld setDelegate:self];
    [coffeenameTxtFld setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:coffeenameTxtFld];
    [coffeenameTxtFld release];
    
//    UILabel *prceLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 100, 200, 20)];
//    [prceLabel setText:@"Price"];
//    [self.view addSubview:prceLabel];
//    [prceLabel release];
    
//    priceTxtFld=[[UITextField alloc] initWithFrame: CGRectMake(50, 130, 200, 40)];
//    [priceTxtFld setBackgroundColor:[UIColor lightGrayColor]];
//    [priceTxtFld setBorderStyle:UITextBorderStyleRoundedRect];
//    [self.view addSubview:priceTxtFld];
//    [priceTxtFld release];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonItemMethod:)];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(saveButtonItemMethod:)];
    
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [saveButtonItem release];
    [cancelButtonItem release];
    
    nextMedicineDatePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(05, 90, 300, 150)];
    [self.view addSubview: nextMedicineDatePicker];
    [nextMedicineDatePicker release];
    
    [coffeenameTxtFld becomeFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    return YES;
}


- (void) cancelButtonItemMethod: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) saveButtonItemMethod : (id) sender
{

    //Create a Coffee Object.
    Coffee *coffeeObj = [[Coffee alloc] initWithPrimaryKey:0];
    coffeeObj.coffeeName = coffeenameTxtFld.text;
    
    NSDecimalNumber *temp = [[NSDecimalNumber alloc] initWithString:priceTxtFld.text];
    coffeeObj.price = temp;
    [temp release];
    
    coffeeObj.isDirty = NO;
    coffeeObj.isDetailViewHydrated = YES;
    
    NSLocale *usLocale = [[[NSLocale alloc]
                           initWithLocaleIdentifier:@"en_US"] autorelease];
    
    NSDate *pickerDate = [nextMedicineDatePicker date];
    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", [pickerDate descriptionWithLocale:usLocale]];
    NSLog(@" time = %@ ", selectionString);
    
    [selectionString release];
    
    coffeeObj.dateAndTime=pickerDate;
    
    //Add the object
    [CoffeeManager addCoffee:coffeeObj];
    
    
    //Dismiss the controller.
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
