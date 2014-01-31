//
//  World.h
//  Risk5
//
//  Created by Clayton Brady on 11/13/12.
//  Copyright (c) 2012 Drake University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"

//the world is an NSObject and serves as the board
@interface World : NSObject{
    
    //each board has an array of all the countries, an array of human countries, and an array of computer countries
    NSMutableArray* worldOfRisk;
    NSMutableArray* humanCountries;
    NSMutableArray* computerCountries;
}

//properties of the board
@property(nonatomic, retain)NSMutableArray* worldOfRisk;
@property(nonatomic, retain)NSMutableArray* humanCountries;
@property(nonatomic, retain)NSMutableArray* computerCountries;

//methods that can be performed on a world
-(void)populateWorld:(Country *)s;
-(Country*)getCountry:(int)n;
-(Country*)getCountryString:(NSString *)s;
-(void)riskAttack:(Country*)attacker:(Country*)attacked;
//-(bool)isAllYours:(NSString*)s;
-(NSMutableArray*)getHumanCountries;
-(void)setHumanCountry;
-(void)setComputerCountry;
-(Country*)getCountryComputer:(int)n;


@end
