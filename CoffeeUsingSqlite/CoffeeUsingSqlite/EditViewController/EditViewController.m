//
//  EditViewController.m
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 01/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import "EditViewController.h"
#import "CoffeeManager.h"

@interface EditViewController ()<UITextFieldDelegate>
{
    Coffee *currentObj;
    UITextField *coffeePriceTxtFld;
    UIDatePicker *nextMedicineDatePicker;
}
@end

@implementation EditViewController

@synthesize objectToEdit,keyOfTheFieldToEdit,editValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor: [UIColor groupTableViewBackgroundColor]];
    
    currentObj = (Coffee *) self.objectToEdit;
    self.title = [currentObj.coffeeName capitalizedString];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_Clicked:)];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(save_Clicked:)];
    
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [saveButtonItem release];
    [cancelButtonItem release];
    
    UILabel *coffeeNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 10, 200, 20)];
    [coffeeNameLabel setText:@"Medicine Name"];
    [self.view addSubview:coffeeNameLabel];
    [coffeeNameLabel release];
    
    txtField=[[UITextField alloc] initWithFrame: CGRectMake(50, 40, 200, 40)];
    [txtField setBorderStyle:UITextBorderStyleRoundedRect];
    [txtField setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:txtField];
    [txtField release];
    
//    coffeePriceTxtFld=[[UITextField alloc] initWithFrame: CGRectMake(50, 70, 200, 40)];
//    [coffeePriceTxtFld setBorderStyle:UITextBorderStyleRoundedRect];
//    [coffeePriceTxtFld setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:coffeePriceTxtFld];
//    [coffeePriceTxtFld release];
    
    nextMedicineDatePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(05, 90, 300, 150)];
    [self.view addSubview: nextMedicineDatePicker];
    [nextMedicineDatePicker release];
    
    [txtField becomeFirstResponder];
    
    
    txtField.placeholder = [self.keyOfTheFieldToEdit capitalizedString];
    
    txtField.text = self.editValue;
    
    [txtField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) save_Clicked:(id)sender
{
    NSLog(@"sender=%@",sender);
    //Update the value.
    //Invokes the set<key> method defined in the Coffee Class.
    
    currentObj.coffeeName=txtField.text;
    currentObj.price = [NSDecimalNumber decimalNumberWithString:coffeePriceTxtFld.text];
    [CoffeeManager saveAllData:currentObj];
    
    NSLocale *usLocale = [[[NSLocale alloc]
                           initWithLocaleIdentifier:@"en_US"] autorelease];
    
    NSDate *pickerDate = [nextMedicineDatePicker date];
    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", [pickerDate descriptionWithLocale:usLocale]];
    NSLog(@" time = %@ ", selectionString);
    
    [selectionString release];


    //Pop back to the detail view.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancel_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) dealloc
{
    self.objectToEdit = nil;
    self.keyOfTheFieldToEdit = nil;
    self.editValue = nil;
    [super dealloc];
}


@end
