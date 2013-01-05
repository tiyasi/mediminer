//
//  CoffeeTableViewController.m
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 31/12/12.
//  Copyright (c) 2012 Tiyasi Acharya. All rights reserved.
//

#import "CoffeeTableViewController.h"
#import "CoffeeManager.h"
#import "Coffee.h"
#import "AddCoffeeViewController.h"
#import "CoffeeDetailsViewController.h"
#import "EditViewController.h"


@interface CoffeeTableViewController ()
{
    CoffeeManager *coffeeMngrObj;
    NSIndexPath *selectedIndexPath;
    EditViewController *evController;
}
@end



@implementation CoffeeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

-(void)dealloc
{
    self.tableView=nil;
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

   
    UIBarButtonItem *plusButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addView:)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = plusButtonItem;
    self.title = @"Mediminder";
    [plusButtonItem release];
    
    [CoffeeManager prepareInitialDataToDisplay];
     NSLog(@"[CoffeeManager getCoffeeArray]-%@",[CoffeeManager getCoffeeArray]);
    //TA: put table
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}


-(void)addView:(id)sender
{
    AddCoffeeViewController *addCoffee=[[AddCoffeeViewController alloc]init];
    [self.navigationController pushViewController:addCoffee animated:YES];
    [addCoffee release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[CoffeeManager getCoffeeArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    Coffee *currentObj = [[CoffeeManager getCoffeeArray] objectAtIndex:indexPath.row];
    NSLog(@" \n currentObjname = %@ ",currentObj.coffeeName);
    cell.textLabel.text = currentObj.coffeeName;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //Get the object to delete from the array.
        Coffee *coffeeObj = [[CoffeeManager getCoffeeArray] objectAtIndex:indexPath.row];
       [CoffeeManager removeCoffee:coffeeObj];
        
        //Delete the object from the table.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    [self.navigationItem setHidesBackButton:editing animated:animated];
//    
//    [self.tableView reloadData];
//}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    // Show the disclosure indicator if editing.
//    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
//}

//- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Only allow selection if editing.
//    return (self.editing) ? indexPath : nil;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
//    NSLog(@"didSelectRowAtIndexPath");
//    CoffeeDetailsViewController *detailViewController = [[CoffeeDetailsViewController alloc] init];
//    
//    Coffee *currentObj = [[CoffeeManager getCoffeeArray] objectAtIndex:indexPath.row];
//    [CoffeeManager hydrateDetailViewData : currentObj];
//    detailViewController.coffeeObjInCoffeeDetailsViewController = currentObj;
//    [self.navigationController pushViewController : detailViewController animated:YES];
//    [detailViewController release];
    
    Coffee *currentObj = [[CoffeeManager getCoffeeArray] objectAtIndex:indexPath.row];
    
    //Keep track of the row selected.
    selectedIndexPath = indexPath;
    
    if(evController == nil)
    {
        evController = [[EditViewController alloc] init];
    }
    
    //Find out which field is being edited.
//    switch(indexPath.section)
//    {
//        case 0:
            evController.keyOfTheFieldToEdit = currentObj.coffeeName;
//            evController.editValue = currentObj.coffeeName;
//            break;
//            
//        case 1:
//            evController.keyOfTheFieldToEdit = @"price";
//            evController.editValue=[currentObj.price stringValue];
//            break;
//    }
    
    //Object being edited.
    evController.objectToEdit = currentObj;
    //Push the edit view controller on top of the stack.
    [self.navigationController pushViewController:evController animated:YES];
    [evController release];
    evController=nil;
    
}

@end
