//
//  Country.h
//  Risk5
//
//  Created by Clayton Brady on 11/13/12.
//  Copyright (c) 2012 Drake University. All rights reserved.
//

#import <Foundation/Foundation.h>

//this defines a single country object
@interface Country : NSObject{
    
    //defines attributes for a country
    NSString* name;
    bool isHuman;
    NSMutableArray* attackables;
    NSMutableArray* humanAttackables;
    NSMutableArray* computerAttackables;
    int soldiers;
}

//property list for countries
@property (nonatomic, retain) NSString *name;
@property bool isHuman;
@property (nonatomic, retain) NSMutableArray *attackables;
@property (nonatomic, retain) NSMutableArray *humanAttackables;
@property (nonatomic, retain) NSMutableArray *computerAttackables;
@property int soldiers;

-(void)setComputerAttackable;
-(void)setHumanAttackable;
-(Country*)getAttackable;
-(void)setAttackable:(Country*)s;
-(void)addSoldiers:(int)n;

@end
