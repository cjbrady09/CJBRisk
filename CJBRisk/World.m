//
//  World.m
//  Risk5
//
//  This defines what a world is.  The world consists of an array of countries and keeps track of who owns which
//  country.  
//
//  Created by Clayton Brady on 11/13/12.
//  Copyright (c) 2012 Drake University. All rights reserved.
//

#import "World.h"

@implementation World

//synthesize the properties
@synthesize worldOfRisk, humanCountries, computerCountries;

//initializes variables that need allocation
- (id)init
{
    self = [super init];
    if (self) {
        worldOfRisk = [[NSMutableArray alloc] init];
        humanCountries = [[NSMutableArray alloc] init];
        computerCountries = [[NSMutableArray alloc] init];
    }
    return self;
}

//adds the given country 's' to the board to intialize all countries
-(void)populateWorld:(Country *)s{
    [worldOfRisk addObject:s];
}

-(NSMutableArray*)getHumanCountries{
    
    //removes all countries in the humanCountries array
    [humanCountries removeAllObjects];
    
    //initializes a counter for the for loop
    int counter = worldOfRisk.count;
    
    //loops through all the countries on the board
    for(int i=0; i<counter; i++)
    {
        //if a country is human than add the country to the array of human countries
        if([[worldOfRisk objectAtIndex:i] isHuman])
        {
            [humanCountries addObject:[worldOfRisk objectAtIndex:i]];
        }
    }
    
    //returns all the human Countries
    return humanCountries;
}

//initializes the human countries
-(void)setHumanCountry{
    //removes all objects already in the array
    [humanCountries removeAllObjects];
    
    //initializes a counter
    int counter = worldOfRisk.count;
    
    //loops through all the countries on the board
    for(int i=0; i<counter; i++)
    {
        //if the country is human than add object to human countries
        if([[worldOfRisk objectAtIndex:i] isHuman])
        {
            [humanCountries addObject:[worldOfRisk objectAtIndex:i]];
        }
    }
}

//initializes all of the computer controlled countries
-(void)setComputerCountry{
    
    //removes everything currently in the array
    [computerCountries removeAllObjects];
    
    //sets a counter for the loop
    int counter = worldOfRisk.count;
    
    //loops through each country on the board
    for(int i=0; i<counter; i++)
    {
        //if the country is computer controlled than add object to computers countries
        if([[worldOfRisk objectAtIndex:i] isHuman]==false)
        {
            [computerCountries addObject:[worldOfRisk objectAtIndex:i]];
        }
    }
}

//gets the country at the specified index
-(Country*)getCountry:(int) n {
    return [worldOfRisk objectAtIndex:n];
}

//gets the computer controlled country at the specified index
-(Country*)getCountryComputer:(int)n{
    return [computerCountries objectAtIndex:n];
}

//gets a country based on its name
-(Country*)getCountryString:(NSString *)s {
    
    //initializes a counter
    int size = [worldOfRisk count];
    
    //loops through all the countries
    for(int i=0; i<size; i++)
    {
        
        //if the countries name is equal to the input string then return the country
        if([[worldOfRisk objectAtIndex:i] name]==s)
        {
            return [worldOfRisk objectAtIndex:i];
        }
    }
    //else return nothing
    return nil;
}
 
//the actual attack method takes in an attacker and a defender
-(void)riskAttack:(Country*)attacker:(Country*)attacked{
    
    //initializes the number of attackers and defenders
    int numDefenders=0;
    int numAttackers=0;
    int numAttack=0;
    
    //assigns values to the above variables
    numAttackers = attacker.soldiers;
    numDefenders = attacked.soldiers;
    numAttack = numAttackers;
    
    //if the attacker only has one soldier on his country, he can't attack
    if(numAttackers==1)
    {
        NSLog(@"You must leave a defender on your country");
        return;
    }
    //if the attacker has 2 soldiers on his country, then he can attack with one
    else if(numAttackers==2)
    {
        NSLog(@"Attacker uses one soldier");
        numAttackers = 1;
        attacker.soldiers -=1;
    }
    //if the attacker has 3 soldiers on his country, then he can attack with 2
    else if(numAttackers==3)
    {
        NSLog(@"Attacker uses two soldier");
        numAttackers = 2;
        attacker.soldiers -=2;
    }
    //if the attacker has more than 3 soldiers on his country, then he can attack with 3
    else
    {
        NSLog(@"Attacker uses three soldiers");
        numAttackers = 3;
        attacker.soldiers -=3;
    }
    
    //if the defender has one soldier on his country, then he defends with one
    if(numDefenders==1)
    {
        NSLog(@"Defender uses one soldier");
        numDefenders = 1;
        attacked.soldiers -=1;
    }
    //if the defender has more than one soldier on his country, then he defends with two
    else{
        NSLog(@"Defender uses two soldiers");
        numDefenders=2;
        attacked.soldiers -=2;
    }
    
    //initializes arrays for the dice rolls
    int defenderRoll[2];
    int attackerRoll[3];
    
    //gets a random number
    int rand = arc4random();
    NSLog(@"Defender rolls: ");
    
    //if the attacker only rolls one dice, then set the other two dice to 0
    if(numAttackers==1)
    {
        attackerRoll[1]=1;
        attackerRoll[2]=1;
    }
    
    //rolls for the defender
    for(int ndx=0; ndx<numDefenders; ndx++)
    {
        //initializes x
        int x=0;
        
        //gets a random positive number
        rand = abs(arc4random());
        
        //mods the random number to get a number from 0-5
        x = (rand%6);
        
        //increments the number so it is between 1-6
        x++;
        
        //outputs the defenders rolls
        NSLog(@"%d",x);
        
        //if the defender only defends with one soldier, then set the second dice to 0
        if(numDefenders==1)
        {
            defenderRoll[1]=0;
        }
        
        //sets the defenders roll to the number rolled
        defenderRoll[ndx]=x;
    }
    
    //gets the attackers roll
    NSLog(@"Attackers roll: ");
    
    //loops through the number of dice the attacker has
    for(int ndx=0; ndx<numAttackers; ndx++)
    {
        //initializes the roll to 0
        int x=0;
        
        //gets a random number
        rand = abs(arc4random());
        
        //mods the number with 6 and increments by one for 1-6 range
        x = (rand%6)+1;
        
        //outputs the attackers roll
        NSLog(@"%d",x);
        
        //sets the attackers roll to the number rolled
        attackerRoll[ndx]=x;
    }
    
    //if the attacker rolled with three then replace on soldier back on his country
    if(numAttackers==3)
    {
        attacker.soldiers++;
        numAttackers--;
    }
    
    //sorts attackers dice rolls
    int temp;
    //loops through the attackers dice
    for(int k=0;k<2;k++);
    {
        //loops through each dice again and compares them
        for(int l=0; l<2; l++)
        {
            //if the current dice is less than the next then switch them around
            if(attackerRoll[l+1]>attackerRoll[l])
            {
                temp = attackerRoll[l];
                attackerRoll[l]=attackerRoll[l+1];
                attackerRoll[l+1]=temp;
            }
        }
    }
    
    //sorts defenders dice rolls (see above)
    if(numDefenders ==2)
    {
        int holder;
        for(int a=0; a<1; a++)
        {
            for(int b=0; b<1; b++)
            {
                if(defenderRoll[b+1]>defenderRoll[b])
                {
                    holder = defenderRoll[b];
                    defenderRoll[b]=defenderRoll[b+1];
                    defenderRoll[b+1]=holder;
                }
            }
        }
        
        //compares results
        //if the attackers highest dice is greater than the computer's highest than the computer loses one soldier
        if(attackerRoll[0]>defenderRoll[0])
        {
            numDefenders--;
            NSLog(@"Defender loses one soldier");
        }
        //if the attackers highest is equal to or less than the computer's highest than the human loses one soldier
        else{
            numAttackers--;
            NSLog(@"Attacker loses one soldier");
        }
        //if the attackers second highest dice is greater than the computer's second highest, then computer loses one
        if(attackerRoll[1]>defenderRoll[1])
        {
            numDefenders--;
            NSLog(@"Defender loses one soldier");
        }
        
        else if(attackerRoll[1]<=defenderRoll[1] && numAttack==2)
        {
            
        }
        //if the attackers second highest dice is less than or equal to the computer's second highest than human loses
        else
        {            
            numAttackers--;
            NSLog(@"Attacker loses one soldier");
        }
    }
    //else no need to sort dice, just compare the defenders only dice with the attackers highest
    else{
        if(attackerRoll[0] >defenderRoll[0])
        {
            numDefenders--;
            NSLog(@"Defender loses one soldier");
        }
        else{
            numAttackers--;
            NSLog(@"Attacker loses one soldier");
        }
    }
    //checks if the attacker was the human
    if(attacker.isHuman)
    {
        //if a country was left with 0 defenders then attacker takes over
        if(attacked.soldiers==0 && numDefenders==0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Human Takes Country: "
                                                           message:[NSString stringWithFormat:@"Human takes %@",attacked.name]
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            
            
            attacked.soldiers +=numAttackers;
            attacked.isHuman=true;
            [computerCountries removeObject:attacked];
            [humanCountries addObject:attacked];
            attacked.soldiers += (attacker.soldiers-1);
            attacker.soldiers -= (attacker.soldiers-1);
            NSLog(@"You have taken %@",attacked.name);
        }
        else{
            //replaces remaining attackers and defenders
            attacked.soldiers+=numDefenders;
            attacker.soldiers+=numAttackers;
        }
    }
    //else the computer was the attacker
    else{
        //if the defenders lost all defenders then attacker takes country
        if(attacked.soldiers==0 && numDefenders==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Computer Takes Country: "
                                                           message:[NSString stringWithFormat:@"Computer takes %@ with %@",attacked.name,attacker.name]
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            
            
            //only leave on on country that attacked///////////////
            attacked.soldiers+=numAttackers;
            attacked.isHuman=false;
            [humanCountries removeObject:attacked];
            [computerCountries addObject:attacked];
            
            //moves all attackers onto the attacked but leaves 1
            attacked.soldiers += (attacker.soldiers-1);
            attacker.soldiers -= (attacker.soldiers-1);
            NSLog(@"Computer has taken %@",attacked.name);
        }
        else{
            attacked.soldiers+=numDefenders;
            attacker.soldiers+=numAttackers;
        }
    }
}

/*
-(bool)isAllYours:(NSString*)s
{
    int size = [worldOfRisk count];
    int i;
    for(i=0;i<size;i++)
    {
        if(([[worldOfRisk objectAtIndex:i] name]==s) && [[worldOfRisk objectAtIndex:i] attackableCountries]==0)
        {
            return true;
        }
    }
    return false;
}
 */

@end
