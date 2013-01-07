//
//  Medicine.m
//  Mediminder
//
//  Created by Tiyasi Acharya on 06/01/13.
//  Copyright (c) 2013 Tiyasi Acharya. All rights reserved.
//

#import "Medicine.h"

@implementation Medicine

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
