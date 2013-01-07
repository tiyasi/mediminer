//
//  MedicineManager.m
//  Mediminder
//
//  Created by Tiyasi Acharya on 06/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import "MedicineManager.h"
#import <AVFoundation/AVFoundation.h>

@interface MedicineManager()<AVAudioPlayerDelegate>
{
    sqlite3_stmt *selectstmt;
}
@property(nonatomic,retain) NSMutableArray *coffeeArray;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

@end

static MedicineManager *sharedDataManger = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;

@implementation MedicineManager

@synthesize coffeeArray,isDetailViewHydrated,isDirty;


+(MedicineManager *)sharedInstance
{
    static dispatch_once_t onceToken; //NS: thread safe singleton
    
    dispatch_once(&onceToken, ^{
        sharedDataManger = [[MedicineManager alloc] init];
        [MedicineManager copyDatabaseIfNeeded];
    });
    
    return sharedDataManger;
}


#pragma mark - Singleton Override Methods
+(id)allocWithZone:(NSZone *)zone
{
    if (sharedDataManger == nil)
    {
        sharedDataManger = [super allocWithZone:zone];
        return sharedDataManger;
    }
    return nil;
}

+(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)retain
{
    return self;
}

-(NSUInteger)retainCount
{
    return NSUIntegerMax;
}

-(id)autorelease
{
    return self;
}

-(oneway void)release
{
    //NS: nothing
}

-(void)dealloc
{
    //NS: will never be called
    [super dealloc];
}

-(id)init
{
    if(self = [super init])
    {
        //Initialize the coffee array.
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.coffeeArray = tempArray;
        [tempArray release];
    }
    return self;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save data if appropriate
    //Save all the dirty coffee objects and free memory.
    
    [MedicineManager finalizeStatements];
}



+ (void) saveAllData:(Medicine *)coffeeObj
{
    [[MedicineManager sharedInstance] saveAllData:coffeeObj];
}

- (void) saveAllData:(Medicine *)coffeeObj
{
    int i;
    for (i=0; i < [self.coffeeArray count]; i++)
    {
        Medicine *oldCoffeeObj = (Medicine *)[self.coffeeArray objectAtIndex:i];
        NSLog(@"    self.array in saveAllData before for statement= %@", oldCoffeeObj.coffeeName);
        if (oldCoffeeObj.coffeeID == coffeeObj.coffeeID)
        {
            [self.coffeeArray replaceObjectAtIndex:i withObject:coffeeObj];
            break;
        }
        
    }
    Medicine *cof=[self.coffeeArray objectAtIndex:i];
    NSLog(@"    self.array in saveAllData after for statement= %@", cof.coffeeName);
    
    if(updateStmt == nil)
    {
        //            const char *sql = "update Coffee Set CoffeeName = ?, Price = ? Where CoffeeID = ?";
        const char *sql = "update MedicineTable Set CoffeeName = ?, MedicineDate = ? Where CoffeeID = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    }
    
    NSDate *today=coffeeObj.dateAndTime;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:today];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormat dateFromString:dateString];
    [dateFormat release];
    
    sqlite3_bind_text(updateStmt, 1, [coffeeObj.coffeeName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text (updateStmt, 2,[dateString UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updateStmt, 3,coffeeObj.coffeeID);
    
    //    sqlite3_bind_text(updateStmt, 1, [coffeeObj.coffeeName UTF8String], -1, SQLITE_TRANSIENT);
    //    sqlite3_bind_double(updateStmt, 2, [coffeeObj.price doubleValue]);
    //    sqlite3_bind_int(updateStmt, 3,coffeeObj.coffeeID);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    [localNotif setFireDate:dateFromString ];
    [localNotif setRepeatInterval:NSCalendarCalendarUnit];
    [localNotif setAlertAction:@"Hello"];
    localNotif.hasAction = YES;
    localNotif.soundName = UILocalNotificationDefaultSoundName ;
    //    [localNotif addObserver:self forKeyPath:@"today" options:NSKeyValueObservingOptionNew context:NULL];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    [dateFromString release];
    
    //    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"wake_up" ofType:@"mp3"]];
    //    NSError *error;
    //    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    //    if (error)
    //    {
    //        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    //    }
    //    else
    //    {
    //        audioPlayer.delegate = self;
    //        [audioPlayer play];
    //    }
    
    
    sqlite3_reset(updateStmt);
    
}


+ (NSArray *)getCoffeeArray
{
    return [[MedicineManager sharedInstance] getCoffeeArray];
}

- (NSArray *)getCoffeeArray
{
    return sharedDataManger.coffeeArray;
}

+ (void) removeCoffee:(Medicine *)coffeeObj
{
    [sharedDataManger removeCoffee:(Medicine *)coffeeObj];
}

- (void) removeCoffee:(Medicine *)coffeeObj
{
    NSLog(@"removeCoffee in instance variable.");
    
    //Delete it from the database.
    //    [coffeeObj deleteCoffee];
    
    if(deleteStmt == nil)
    {
        //        const char *sql = "delete from Coffee where coffeeID = ?";
        const char *sql = "delete from MedicineTable where coffeeID = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
    }
    
    //When binding parameters, index starts from 1 and not zero.
    sqlite3_bind_int(deleteStmt, 1, coffeeObj.coffeeID);
    
    if (SQLITE_DONE != sqlite3_step(deleteStmt))
        NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(deleteStmt);
    
    //Remove it from the array.
    [sharedDataManger.coffeeArray removeObject:coffeeObj];
}

+ (void) addCoffee:(Medicine *)coffeeObj
{
    [sharedDataManger addCoffee:(Medicine *)coffeeObj];
}

- (void) addCoffee:(Medicine *)coffeeObj
{
    //    NSPredicate *sPredicate =[NSPredicate predicateWithFormat:@"SELF beginsWith[c] %@",charactersInTextField];
    //    [nameOfCitiesMutable filterUsingPredicate:sPredicate];
    
    //Add it from the array.
    [sharedDataManger.coffeeArray addObject:coffeeObj];
    NSLog(@"sharedDataManger.coffeeArray=%@ in addCoffee",sharedDataManger.coffeeArray);
    
    //    if(addStmt == nil)
    //    {
    //        const char *sql = "insert into Coffee(CoffeeName, Price) Values(?, ?)";
    //        if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
    //            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    //    }
    //
    //    sqlite3_bind_text(addStmt, 1, [coffeeObj.coffeeName UTF8String], -1, SQLITE_TRANSIENT);
    //    sqlite3_bind_double(addStmt, 2, [coffeeObj.price doubleValue]);
    //
    //    if(SQLITE_DONE != sqlite3_step(addStmt))
    //        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //    else
    //        //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
    //        coffeeObj.coffeeID = sqlite3_last_insert_rowid(database);
    //
    //    //Reset the add statement.
    //    sqlite3_reset(addStmt);
    
    
    if(addStmt == nil)
    {
        const char *sql = "insert into MedicineTable(CoffeeName, MedicineDate) Values(?, ?)";
        if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    }
    
    NSDate *today=coffeeObj.dateAndTime;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:today];
    [dateFormat release];
    
    sqlite3_bind_text(addStmt, 1, [coffeeObj.coffeeName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 2,[dateString UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
        coffeeObj.coffeeID = sqlite3_last_insert_rowid(database);
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    [localNotif setFireDate:today];
    [localNotif setRepeatInterval:NSDayCalendarUnit];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//    
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"wake_up" ofType:@"mp3"]];
//    NSError *error;
//    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    if (error)
//    {
//        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
//    }
//    else
//    {
//        audioPlayer.delegate = self;
//        [audioPlayer play];
//    }
    
    
    //Reset the add statement.
    sqlite3_reset(addStmt);
}

+ (void) hydrateDetailViewData:(Medicine *)coffeeObj
{
    [[MedicineManager sharedInstance] hydrateDetailViewData:coffeeObj];
}

- (void) hydrateDetailViewData:(Medicine *)coffeeObj
{
    //If the detail view is hydrated then do not get it from the database.
    //    if(isDetailViewHydrated) return;
    
    if(detailStmt == nil)
    {
        const char *sql = "Select price from Coffee Where CoffeeID = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(detailStmt, 1,coffeeObj.coffeeID);
    
    if(SQLITE_DONE != sqlite3_step(detailStmt)) {
        
        //Get the price in a temporary variable.
        NSDecimalNumber *priceDN = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(detailStmt, 0)];
        
        //Assign the price. The price value will be copied, since the property is declared with "copy" attribute.
        //        self.price = priceDN;
        NSLog(@"hydrateDetailViewData price= %@", priceDN);
        coffeeObj.price = priceDN;
        
        //Release the temporary variable. Since we created it using alloc, we have own it.
        [priceDN release];
    }
    else
        NSAssert1(0, @"Error while getting the price of coffee. '%s'", sqlite3_errmsg(database));
    
    //Reset the detail statement.
    sqlite3_reset(detailStmt);
    
    //Set isDetailViewHydrated as YES, so we do not get it again from the database.
    isDetailViewHydrated = YES;
}

+ (void) prepareInitialDataToDisplay
{
    [[MedicineManager sharedInstance] prepareInitialDataToDisplay];
}

- (void) prepareInitialDataToDisplay
{
    NSString *dbPath = [MedicineManager getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"getInitialDataToDisplay=sqlite3_open");
        
        //        const char *sql = "select coffeeID, coffeeName from coffee";
        
        // Put in the Table name always not the database name - mediTable here not medi.
        const char *sql = "select coffeeID, coffeeName from medicineTable";
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                
                NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
                
                Medicine *coffeeObj = [[Medicine alloc] initWithPrimaryKey:primaryKey];
                //                coffeeObj.coffeeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                char * str = (char*)sqlite3_column_text(selectstmt, 1);
                if (str)
                {
                    coffeeObj.coffeeName = [NSString stringWithUTF8String:str];
                }
                else
                {
                    // handle case when object is NULL, for example set result to empty string:
                    coffeeObj.coffeeName = @"";
                }
                
                isDirty = NO;
                
                [sharedDataManger.coffeeArray addObject:coffeeObj];
                NSLog(@" sharedDataManger.coffeeArray in prepareInitialDataToDisplay = %@",sharedDataManger.coffeeArray);
            }
        }
    }
    else
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}

#pragma mark - DB helper methoids
+ (void) copyDatabaseIfNeeded
{
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [MedicineManager getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    NSLog(@"copyDatabaseIfNeeded ");
    
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Medicine.sqlite"];
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
        {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}

+ (NSString *) getDBPath
{
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSLog(@"Medicine.sqlite getDBPath CoffeeTableViewController ");
    return [documentsDir stringByAppendingPathComponent:@"Medicine.sqlite"];
}


+ (void) finalizeStatements
{
    if (database) sqlite3_close(database);
    if (deleteStmt) sqlite3_finalize(deleteStmt);
    if (addStmt) sqlite3_finalize(addStmt);
    if (detailStmt) sqlite3_finalize(detailStmt);
    if (updateStmt) sqlite3_finalize(updateStmt);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
    //Save all the dirty coffee objects and free memory.
    //    [self.coffeeArray makeObjectsPerformSelector:@selector(saveAllData)];
}




@end
