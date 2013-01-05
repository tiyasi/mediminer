//
//  CoffeeDetailsViewController.m
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 01/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import "CoffeeDetailsViewController.h"
#import "CoffeeManager.h"

@interface CoffeeDetailsViewController ()
{
    UITextField *coffeenameTxtFld;
    UITextField *priceTxtFld;
}
@end

@implementation CoffeeDetailsViewController

@synthesize coffeeObjInCoffeeDetailsViewController;

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

    NSLog(@"coffeeObjInCoffeeDetailsViewController %@ %@", coffeeObjInCoffeeDetailsViewController.coffeeName, coffeeObjInCoffeeDetailsViewController.price);
    
    self.title=coffeeObjInCoffeeDetailsViewController.coffeeName;
    
    UILabel *coffeeNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 20, 200, 20)];
    [coffeeNameLabel setText:@"Coffee Name"];
    [self.view addSubview:coffeeNameLabel];
    [coffeeNameLabel release];
    
    coffeenameTxtFld=[[UITextField alloc] initWithFrame: CGRectMake(50, 50, 200, 40)];
    [coffeenameTxtFld setBorderStyle:UITextBorderStyleRoundedRect];
    [coffeenameTxtFld setText:coffeeObjInCoffeeDetailsViewController.coffeeName];
    [coffeenameTxtFld setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:coffeenameTxtFld];
    [coffeenameTxtFld release];
    
    UILabel *prceLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 100, 200, 20)];
    [prceLabel setText:@"Price"];
    [self.view addSubview:prceLabel];
    [prceLabel release];
    
    priceTxtFld=[[UITextField alloc] initWithFrame: CGRectMake(50, 130, 200, 40)];
    [priceTxtFld setBackgroundColor : [UIColor lightGrayColor]];
    [priceTxtFld setText: [NSString stringWithFormat  : @"%@" , coffeeObjInCoffeeDetailsViewController.price]];
    [priceTxtFld setBorderStyle  :UITextBorderStyleRoundedRect];
    [self.view addSubview: priceTxtFld];
    [priceTxtFld release];
    
    [coffeenameTxtFld becomeFirstResponder];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [CoffeeManager hydrateDetailViewData:coffeeObjInCoffeeDetailsViewController];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    return YES;
}

-(void)dealloc
{
    [coffeeObjInCoffeeDetailsViewController release];
    coffeeObjInCoffeeDetailsViewController=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
