//
//  Coffee.h
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 31/12/12.
//  Copyright (c) 2012 Tiyasi Acharya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface Coffee : NSObject

@property (nonatomic, readwrite) NSInteger coffeeID;
@property (nonatomic, copy) NSString *coffeeName; //find out why 'copy' is used for NSString (and what else copy is used for)
@property (nonatomic, copy) NSDecimalNumber *price;
@property (nonatomic, retain) NSDate *dateAndTime;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
                

@end
