//
//  Country.m
//  Risk5
//
//  This defines what a Country is and what methods go with a country.  Three main arrays attackables,humanattackables,
//  and computerAttackables allow the game to keep track of which countries a specific country can attack.
//
//  Created by Clayton Brady on 11/13/12.
//  Copyright (c) 2012 Drake University. All rights reserved.
//

#import "Country.h"

@implementation Country

//synthesizes all variables
@synthesize name,isHuman,attackables,soldiers,humanAttackables,computerAttackables;

//initializes and allocates variables
- (id)init
{
    self = [super init];
    if (self) {
        attackables = [[NSMutableArray alloc]init];
        humanAttackables = [[NSMutableArray alloc] init];
        computerAttackables = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//adds soldiers to a given country
-(void)addSoldiers:(int)n{
    soldiers+=n;
}

//adds an attackable link to a country
-(void)setAttackable:(Country*)s
{
    [attackables addObject:s];
}

//checks if a neighboring country is human
-(void)setHumanAttackable
{
    //removes all human attackables
    [humanAttackables removeAllObjects];
    
    //allocates a country
    Country * c = [[Country alloc]init];
    
    //loops through all the attackable countries
    for(int i=0; i<[attackables count]; i++)
    {
        //if the attackable country is human then add to the human attackable list
        c=[attackables objectAtIndex:i];
        if (c.isHuman) {
            [humanAttackables addObject:c];
        }
    }
}

//checks if a neighboring country is computer controlled
-(void)setComputerAttackable
{
    //removes all computer attackables
    [computerAttackables removeAllObjects];
    
    //allocates a country
    Country * c = [[Country alloc]init];
    
    //loops through all the attackable countries
    for(int i=0; i<[attackables count]; i++)
    {
        //if the attackable country is computer controlled then add to the computer attackable list
        c=[attackables objectAtIndex:i];
        if (c.isHuman==false) {
            [computerAttackables addObject:c];
        }
    }
}

//returns a country that is attackable, used by the computer when determining attacks
-(Country*)getAttackable{
    int x;
    [self setHumanAttackable];
    
    //x is the number of countries controlled by the human bordering the given country
    x=[humanAttackables count];
    
    //allocates for a country
    Country* countryName=[[Country alloc]init];
    
    //x is a random number among the number of attackables
    x=rand()%x;
   
    //the country is a random attackable country
    countryName = [humanAttackables objectAtIndex:x];
    return countryName;
}




@end
