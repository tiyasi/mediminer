//
//  MedicineTableViewController.m
//  Mediminder
//
//  Created by Tiyasi Acharya on 06/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import "MedicineTableViewController.h"
#import "MedicineManager.h"
#import "Medicine.h"
#import "AddMedicineViewController.h"
#import "EditViewController.h"

@interface MedicineTableViewController ()
{
    MedicineManager *coffeeMngrObj;
    NSIndexPath *selectedIndexPath;
    EditViewController *evController;
}
@end

@implementation MedicineTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    
    [MedicineManager prepareInitialDataToDisplay];
    NSLog(@"[CoffeeManager getCoffeeArray]-%@",[MedicineManager getCoffeeArray]);
    //TA: put table

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    AddMedicineViewController *addCoffee=[[AddMedicineViewController alloc]init];
    [self.navigationController pushViewController:addCoffee animated:YES];
    [addCoffee release];
    
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
    return [[MedicineManager getCoffeeArray] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    Medicine *currentObj = [[MedicineManager getCoffeeArray] objectAtIndex:indexPath.row];
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
        Medicine *coffeeObj = [[MedicineManager getCoffeeArray] objectAtIndex:indexPath.row];
        [MedicineManager removeCoffee:coffeeObj];
        
        //Delete the object from the table.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    
    Medicine *currentObj = [[MedicineManager getCoffeeArray] objectAtIndex:indexPath.row];
    
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
