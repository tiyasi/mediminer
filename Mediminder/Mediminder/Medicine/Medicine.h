//
//  Medicine.h
//  Mediminder
//
//  Created by Tiyasi Acharya on 06/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface Medicine : NSObject

@property (nonatomic, readwrite) NSInteger coffeeID;
@property (nonatomic, copy) NSString *coffeeName; //find out why 'copy' is used for NSString (and what else copy is used for)
@property (nonatomic, copy) NSDecimalNumber *price;
@property (nonatomic, retain) NSDate *dateAndTime;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;

@end
