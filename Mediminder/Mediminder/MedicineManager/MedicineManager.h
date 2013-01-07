//
//  MedicineManager.h
//  Mediminder
//
//  Created by Tiyasi Acharya on 06/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Medicine.h"

@interface MedicineManager : NSObject

+(MedicineManager *)sharedInstance;

+ (NSString *) getDBPath;
+ (NSArray *)getCoffeeArray;
+ (void) prepareInitialDataToDisplay;

//data editing -- 1. edit the database     2. edit our 'datasource' to the table
+ (void) removeCoffee:(Medicine *)coffeeObj;
+ (void) addCoffee:(Medicine *)coffeeObj;
+ (void) saveAllData:(Medicine *)coffeeObj;

+ (void) hydrateDetailViewData:(Medicine *)coffeeObj;

+ (void) finalizeStatements;

@end
