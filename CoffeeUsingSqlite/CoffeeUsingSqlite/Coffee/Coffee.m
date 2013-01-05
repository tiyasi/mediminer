//
//  Coffee.m
//  CoffeeUsingSqlite
//
//  Created by Tiyasi Acharya on 31/12/12.
//  Copyright (c) 2012 Tiyasi Acharya. All rights reserved.
//

#import "Coffee.h"
#import "CoffeeManager.h"

@interface Coffee()

@end

@implementation Coffee

@synthesize coffeeID, coffeeName, price, isDirty, isDetailViewHydrated, dateAndTime;


- (id) initWithPrimaryKey:(NSInteger) pk
{
    self=[super init];
    
    coffeeID = pk;
    isDetailViewHydrated = NO;
    
    return self;
}


- (void) dealloc
{
    self.price = nil;
    self.coffeeName = nil;
    self.dateAndTime = nil;
    
    [super dealloc];
}


@end
