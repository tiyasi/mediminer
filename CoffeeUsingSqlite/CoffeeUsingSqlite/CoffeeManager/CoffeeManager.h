//
//  CoffeeManager.h
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 31/12/12.
//  Copyright (c) 2012 Tiyasi Acharya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Coffee.h"

@interface CoffeeManager : NSObject

+(CoffeeManager *)sharedInstance;

+ (NSString *) getDBPath;
+ (NSArray *)getCoffeeArray;
+ (void) prepareInitialDataToDisplay;

//data editing -- 1. edit the database     2. edit our 'datasource' to the table
+ (void) removeCoffee:(Coffee *)coffeeObj;
+ (void) addCoffee:(Coffee *)coffeeObj;
+ (void) saveAllData:(Coffee *)coffeeObj;

+ (void) hydrateDetailViewData:(Coffee *)coffeeObj;

+ (void) finalizeStatements;


@end
