//
//  ViewController.h
//  CJBRisk
//
//  Created by Clayton Brady on 12/1/12.
//  Copyright (c) 2012 Drake University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "World.h"
#import "Country.h"
#include <time.h>

//this is the view controller where everything happens
@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    //defines variables for the main view
    int soldiers;
    int turn;
    World* gameBoard;
    int numOfCountries;
    bool positionTroops;
    bool attack;
    bool moveTroops;
    int soldiersToMove;
    Country* whereToMove;
    Country* attackingCountry;
    Country* defendingCountry;
    bool flag;
    bool percept;
    int weight1;
    int weight2;
    int weight3;
}

//defines properties the view has
@property int soldiersToMove;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property int soldiers;
@property int turn;
@property(nonatomic, retain)World* gameBoard;
@property int numOfCountries;
@property (nonatomic, retain) IBOutlet UILabel *mainLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightLabel;
@property bool positionTroops;
@property bool attack;
@property bool moveTroops;
@property(nonatomic, retain)Country* whereToMove;
@property(nonatomic, retain)Country* attackingCountry;
@property(nonatomic, retain)Country* defendingCountry;
@property (nonatomic, retain) IBOutlet UITableView *humanTable;
@property(nonatomic, retain)IBOutlet UITableView *computerTable;
@property(nonatomic, retain)IBOutlet UIButton* myButton;
@property bool flag;
@property int weight1;
@property int weight2;
@property int weight3;
@property bool percept;

//defines methods that the view has
- (IBAction)donePressed:(id)sender;
- (IBAction)buttonPressed:(id)sender;
-(void)setSoldiers:(int)soldiers;
-(int)getSoldiers;
-(void)computerMove:(World*)w:(int)x:(int)y;
-(void)humanMove:(World*)w:(int)x:(int)y;
-(int)setBoard:(World*)w;
-(bool)isWinner:(World*)w:(int)x;
-(bool)announceWinner:(World*)w;
-(void)setComputerReinforcements:(NSMutableArray*)w:(int)x:(int)y;
-(int)calculateReinforcementsHuman:(World*)w:(int)x:(int)y;
-(int)calculateReinforcementsComputer:(World*)w:(int)x:(int)y;
-(bool)perceptron:(int)attackers:(int)defenders;
-(void)trainPerceptron:(int)attackers:(int)defenders:(bool)val;
-(bool)isNorthAmerica:(World*)w;
-(bool)isSouthAmerica:(World*)w;
-(bool)isAfrica:(World*)w;
-(bool)isEurope:(World*)w;
-(bool)isAustralia:(World*)w;
-(bool)isAsia:(World*)w;
-(Country*)calculateClosestAsia;
-(Country*)calculateClosestNorthAmerica;
-(Country*)calculateClosestSouthAmerica;
-(Country*)calculateClosestEurope;
-(Country*)calculateClosestAustralia;
-(Country*)calculateClosestAfrica;


@end
