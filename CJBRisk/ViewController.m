//
//  ViewController.m
//  Risk5
//
//  The main view controller.  This controls the apps view controller and all the button and user interactions
//  This defines a computer's turn and allows for the user to play. It uses a perceptron to determine where to add
//  soldiers and when to attack.  
//
//  Created by Clayton Brady on 11/13/12.
//  Copyright (c) 2012 Drake University. All rights reserved.
//

#import "ViewController.h"
#import <time.h>

@implementation ViewController

//synthesize all the variables
@synthesize humanTable,positionTroops,attack,moveTroops,whereToMove,attackingCountry,defendingCountry;
@synthesize soldiers,turn,gameBoard,numOfCountries,soldiersToMove, computerTable, myButton, flag;
@synthesize percept,weight1,weight2,weight3,doneButton,mainLabel,leftLabel,rightLabel;

//action that happens when the main button is pressed
- (IBAction)buttonPressed:(id)sender {
    //if the user needs to position troops
    if(positionTroops)
    {
        //removes the soldiers from the number of soldiers left to move;
        soldiers-=soldiersToMove;
        
        //loops through all the countries
        for(int i=0; i<[gameBoard.worldOfRisk count]; i++)
        {
            //allocates a new country
            Country* x = [[Country alloc]init];
            
            //assigns the current country to the new contry x
            x=[gameBoard.worldOfRisk objectAtIndex:i];
            
            //if x is where the user wants to move soldiers, then move the soldiers there
            if(x.name==whereToMove.name)
            {
                x.soldiers+=soldiersToMove;
            }
        }
        
        //set soldiers to move to 0
        soldiersToMove=0;
        
        //if the user has no more soldiers to position
        if (soldiers==0) {
            
            //disable the main button
            myButton.enabled = NO;
            
            //set booleans to move on to attack phase
            positionTroops=false;
            attack=true;
            
            //sets the labels of the app for attack phase
            mainLabel.text = @"Attack the Enemy";
            leftLabel.text = @"Choose your country";
            rightLabel.text = @"Choose your target";
        }
        
        //reloads the table views
        [computerTable reloadData];
        [humanTable reloadData];
    }
    //if attack phase
    else if(attack)
    {
        //when button is pressed then attack
        [gameBoard riskAttack:attackingCountry :defendingCountry];
        
        //get the new human countries
        [gameBoard getHumanCountries];
        
        //reload the table views
        [humanTable reloadData];
        [computerTable reloadData];
    }
    //if attack phase is over then it is move troops phase
    else if(moveTroops)
    {
        //remove troops from selected country and position on new country
        attackingCountry.soldiers--;
        defendingCountry.soldiers++;
        
        //reload table views
        [humanTable reloadData];
        [computerTable reloadData];
    }
}

//done button action
-(IBAction)donePressed:(id)sender{
    //if it is the attack phase
    if(attack)
    {
        //switch the booleans so it is the move phase
        attack=false;
        moveTroops=true;
        myButton.enabled=NO;
        
        //set labels for the move phase
        myButton.titleLabel.text = @"Move";
        mainLabel.text = @"Move your troops";
        leftLabel.text = @"Move troops from:";
        rightLabel.text =@"Move troops to:";
        
        //reload the table views
        [computerTable reloadData];
        [humanTable reloadData];
    }
    //if it is the move phase then end users turn
    else if(moveTroops)
    {
        //reset the booleans for when the turn comes back to human
        moveTroops=false;
        
        //sets the labels for position phase
        mainLabel.text = @"Position Reinforcements";
        leftLabel.text=@"Troops to position:";
        rightLabel.text=@"Where to position:";
        myButton.titleLabel.text = @"Position";
        
        //switch to computer's turn
        [self computerMove:gameBoard :[gameBoard.worldOfRisk count]:turn];
        positionTroops=true;
        myButton.enabled=YES;
        moveTroops=false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//when the view first loads...main method
- (void)viewDidLoad
{
    //initialize countries
    whereToMove = [[Country alloc] init];
    attackingCountry =[[Country alloc] init];
    defendingCountry = [[Country alloc] init];
    flag=false;
    Country *x=[[Country alloc]init];
    whereToMove=x;
    myButton.titleLabel.text = @"Position";
    
    //initialize weights for the perceptron
    weight1=6;
    weight2=-4;
    weight3=7;
    
    //train the perceptron
    for(int i=0; i<3; i++){
        [self trainPerceptron:3 :7 :false];
        [self trainPerceptron:4 :4 :true];
        [self trainPerceptron:3 :5 :false];
        [self trainPerceptron:5 :9 :false];
        [self trainPerceptron:6 :4 :true];
        [self trainPerceptron:7 :3 :false];
        [self trainPerceptron:12 :3 :true];
        [self trainPerceptron:10 :6 :false];
        [self trainPerceptron:5 :4 :false];
        [self trainPerceptron:14 :5 :true];
        [self trainPerceptron:9 :1 :true];
        [self trainPerceptron:8 :9 :true];
        [self trainPerceptron:7 :4 :true];
        [self trainPerceptron:19 :6 :true];
        [self trainPerceptron:2 :3 :false];
        [self trainPerceptron:3 :5 :false];
        [self trainPerceptron:11 :4 :true];
        [self trainPerceptron:4 :3 :false];
        [self trainPerceptron:6 :6 :false];
        [self trainPerceptron:6 :8 :false];
        [self trainPerceptron:6 :2 :true];
        [self trainPerceptron:6 :6 :true];
        [self trainPerceptron:3 :2 :true];
        [self trainPerceptron:21 :3 :true];
        [self trainPerceptron:18 :4 :true];
        [self trainPerceptron:2 :5 :false];
        [self trainPerceptron:6 :2 :true];
        [self trainPerceptron:3 :2 :true];
        [self trainPerceptron:10 :9 :true];
        [self trainPerceptron:10 :9 :false];
        [self trainPerceptron:10 :8 :false];
        [self trainPerceptron:14 :12 :true];
        [self trainPerceptron:2 :7 :false];
    }
    
    //set position phase
    positionTroops=true;
    attack=false;
    moveTroops=false;
    
    //give 50 soldiers to position
    soldiers=55;
    
    //set the random number generator
    srand(time(NULL));
    
    //allocate for a new game board
    gameBoard = [[World alloc]init];
    
    //number of countries equals number of countries on the board
    numOfCountries = [self setBoard:gameBoard];
    
    //sets the human and computer countries
    [gameBoard setHumanCountry];
    [gameBoard setComputerCountry];
    
    //sets the computer's reinforcements
    [self setComputerReinforcements:gameBoard.computerCountries:[gameBoard.computerCountries count]:50];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

//gets the soldiers
-(int)getSoldiers{
    return soldiers;
}

//view did unload method for when the view exits
- (void)viewDidUnload
{
    [self setHumanTable:nil];
    [self setMainLabel:nil];
    [self setLeftLabel:nil];
    [self setRightLabel:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//method for when the view will appears
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//method for when the view did appear
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//method for when the view is about to disappear
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

//method for when the view just disappeared
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//auto rotate the game
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

//checks to see if the human controls all of north america
-(bool)isNorthAmerica:(World*)board
{
    //if human has all of north america, then give 5 extra soldiers
    if([board getCountryString:@"Alaska"].isHuman && [board getCountryString:@"Aberta"].isHuman && [board getCountryString:@"Northwest Territory"].isHuman && [board getCountryString:@"Greenland"].isHuman && [board getCountryString:@"Ontario"].isHuman && [board getCountryString:@"Western US"].isHuman && [board getCountryString:@"Eastern US"].isHuman && [board getCountryString:@"Central America"].isHuman && [board getCountryString:@"Eastern Canada"].isHuman)
    {
        return true;
    }
    else
    {
        return false;
    }
}
//checks to see if the human controls all of south america
-(bool)isSouthAmerica:(World*)board{
    //if human has all of south america, then give 2 extra soldiers
    if([board getCountryString:@"Peru"].isHuman && [board getCountryString:@"Brazil"].isHuman && [board getCountryString:@"Argentina"].isHuman && [board getCountryString:@"Venezuela"].isHuman)
    {
        return true;
    }
    else
    {
        return false;
    }
}
//checks to see if the human controls all of africa
-(bool)isAfrica:(World*)board{
    //if human has all of Africa, then give 3 extra soldiers
    if([board getCountryString:@"North Africa"].isHuman && [board getCountryString:@"South Africa"].isHuman && [board getCountryString:@"Egypt"].isHuman && [board getCountryString:@"Madagascar"].isHuman && [board getCountryString:@"Central Africa"].isHuman && [board getCountryString:@"East Africa"].isHuman)
    {
        return true;
    }
    else
    {
        return false;
    }
}
//checks to see if the human controls all of europe
-(bool)isEurope:(World*)board{
    //if human has all of Europe, then give 5 extra soldiers
    if([board getCountryString:@"Great Britain"].isHuman && [board getCountryString:@"Iceland"].isHuman && [board getCountryString:@"Russia"].isHuman && [board getCountryString:@"Scandenavia"].isHuman && [board getCountryString:@"Western Europe"].isHuman && [board getCountryString:@"Northern Europe"].isHuman && [board getCountryString:@"Southern Europe"].isHuman)
    {
        return true;
    }
    else
    {
        return false;
    }
}
//checks to see if the human controls all of australia
-(bool)isAustralia:(World*)board{
    //if human has all of Australia, then give 2 extra soldiers
    if([board getCountryString:@"Indonesia"].isHuman && [board getCountryString:@"New Guinnea"].isHuman && [board getCountryString:@"Western Australia"].isHuman && [board getCountryString:@"Eastern Australia"].isHuman)
    {
        return true;
    }
    else
    {
        return false;
    }
}
//checks to see if the human controls all of asia
-(bool)isAsia:(World*)board{
    //if human has all of Asia, then give 7 extra soldiers
    if([board getCountryString:@"India"].isHuman && [board getCountryString:@"China"].isHuman && [board getCountryString:@"Japan"].isHuman && [board getCountryString:@"Middle East"].isHuman && [board getCountryString:@"Siberia"].isHuman && [board getCountryString:@"Afghanistan"].isHuman && [board getCountryString:@"Southeast Asia"].isHuman && [board getCountryString:@"Ural"].isHuman && [board getCountryString:@"Mongolia"].isHuman && [board getCountryString:@"Irkutsk"].isHuman && [board getCountryString:@"Kamchatka"].isHuman && [board getCountryString:@"Yakutsk"].isHuman)
    {
        return true;
    }
    else
    {
        return false;
    }
}

//gets a close country to asia only if asia is completely human controlled
-(Country*)calculateClosestAsia{
    //if a boarding country is computer controlled then add soldiers there
    Country* x = [[Country alloc]init];
    x.name = @"Not Good";
    //if the computer controls alaska then return alaska
    if([gameBoard getCountryString:@"Alaska"].isHuman==false) {
        x=[gameBoard getCountryString:@"Alaska"];
    }
    //if the computer controls russia then return russia
    else if([gameBoard getCountryString:@"Russia"].isHuman==false) {
        x=[gameBoard getCountryString:@"Russia"];
    }
    //if the computer controls southern europe then return southern europe
    else if([gameBoard getCountryString:@"Southern Europe"].isHuman==false) {
        x=[gameBoard getCountryString:@"Southern Europe"];
    }
    //if the computer controls egypt then return egypt
    else if([gameBoard getCountryString:@"Egypt"].isHuman==false) {
        x=[gameBoard getCountryString:@"Egypt"];
    }
    //if teh computer controls east africa then return east africa
    else if([gameBoard getCountryString:@"East Africa"].isHuman==false) {
        x=[gameBoard getCountryString:@"East Africa"];
    }
    //if the computer controls madagascar then return madagascar
    else if([gameBoard getCountryString:@"Madagascar"].isHuman==false) {
        x=[gameBoard getCountryString:@"Madagascar"];
    }
    //if the computer controls indonesia then return indonesia
    else if([gameBoard getCountryString:@"Indonesia"].isHuman==false) {
        x=[gameBoard getCountryString:@"Indonesia"];
    }
    //else find a random country
    return x;
}
//gets a close country to north america if it is all controlled by a human
-(Country*)calculateClosestNorthAmerica{
    Country* x = [[Country alloc]init];
    x.name = @"Not Good";
    //if the computer controls kamchatka then return it
    if ([gameBoard getCountryString:@"Kamchatka"].isHuman==false) {
        x=[gameBoard getCountryString:@"Kamchatka"];
    }
    //if the computer controls iceland then return it
    else if([gameBoard getCountryString:@"Iceland"].isHuman==false) {
        x=[gameBoard getCountryString:@"Iceland"];
    }
    //if the computer controls venezuela then return it
    else if([gameBoard getCountryString:@"Venezuela"].isHuman==false) {
        x=[gameBoard getCountryString:@"Venezuela"];
    }
    return x;
}
//gets a close country to south america if it is all controlled by the human
-(Country*)calculateClosestSouthAmerica{
    Country* x = [[Country alloc]init];
    x.name = @"Not Good";
    //if the computer controls central america then return it
    if([gameBoard getCountryString:@"Central America"].isHuman==false) {
        x=[gameBoard getCountryString:@"Central America"];
    }
    //if the computer controls north africa then return it
    else if([gameBoard getCountryString:@"North Africa"].isHuman==false) {
        x=[gameBoard getCountryString:@"North Africa"];
    }
    return x;
}
//gets a close country to europe if it is all controlled by the human
-(Country*)calculateClosestEurope{
    Country* x = [[Country alloc]init];
    x.name = @"Not Good";
    //if the computer controls greenland then return it
    if([gameBoard getCountryString:@"Greenland"].isHuman==false) {
        x=[gameBoard getCountryString:@"Greenland"];
    }
    //if the computer controls ural then return it
    else if([gameBoard getCountryString:@"Ural"].isHuman==false) {
        x=[gameBoard getCountryString:@"Ural"];
    }
    //if the computer controls afghanistan then return it
    else if([gameBoard getCountryString:@"Afghanistan"].isHuman==false) {
        x=[gameBoard getCountryString:@"Afghanistan"];
    }
    //if the computer controls middle east return it
    else if([gameBoard getCountryString:@"Middle East"].isHuman==false) {
        x=[gameBoard getCountryString:@"Middle East"];
    }
    //if the computer controls egypt return it
    else if([gameBoard getCountryString:@"Egypt"].isHuman==false) {
        x=[gameBoard getCountryString:@"Egypt"];
    }
    //if the computer controls north africa then return it
    else if([gameBoard getCountryString:@"North Africa"].isHuman==false) {
        x=[gameBoard getCountryString:@"North Africa"];
    }
    return x;
}
//gets a close country to australia if the human controls all of australia
-(Country*)calculateClosestAustralia{
    Country* x = [[Country alloc]init];
    x.name = @"Not Good";
    //if the computer controls southeast asia then return it
    if([gameBoard getCountryString:@"Southeast Asia"].isHuman==false) {
        x=[gameBoard getCountryString:@"Southeast Asia"];
    }
    return x;
}
//gets a close country to africa if the human controls all of africa
-(Country*)calculateClosestAfrica{
    Country* x = [[Country alloc]init];
    x.name = @"Not Good";
    //if the computer controls Brazil then return it
    if([gameBoard getCountryString:@"Brazil"].isHuman==false) {
        x=[gameBoard getCountryString:@"Brazil"];
    }
    //if the computer controls middle east return it
    else if([gameBoard getCountryString:@"Middle East"].isHuman==false) {
        x=[gameBoard getCountryString:@"Middle East"];
    }
    //if the computer controls soutehr europe return it
    else if([gameBoard getCountryString:@"Southern Europe"].isHuman==false) {
        x=[gameBoard getCountryString:@"Western Europe"];
    }
    return x;
}

//defines a computers turn
-(void)computerMove:(World*)board:(int)numOfCountry:(int)turns{
    //increments the turns
    turns++;
    
    positionTroops=true;
    moveTroops=false;
    int troops;
    bool willWin=true;
    
    //sets computer's reinforcements
    troops=[self calculateReinforcementsComputer:board :[board.worldOfRisk count] :turns];
    [self setComputerReinforcements:gameBoard.computerCountries :[gameBoard.computerCountries count] :troops];
    
    //if there is a winner
    if([self isWinner:board:numOfCountry])
    {
        return;
    }
    
    //while there is a country that the computer will win against, attack
    while (willWin) {
        
        //allocates for countries
        Country * attacker = [[Country alloc]init];
        Country * attacked = [[Country alloc]init];
        attacked.name = @"not good";
        
        //loops through the computer's countries
        for(int i=0; i<[board.computerCountries count]; i++)
        {
            //gets the country at index i
            attacker = [board.computerCountries objectAtIndex:i];
            
            [attacker setHumanAttackable];
            
            //loops through the countries that the computer can attack
            for(int j=0; j<[attacker.humanAttackables count];j++)
            {
                //gets a country at index j
                Country* gonnaAttack = [[Country alloc]init];
                gonnaAttack = [attacker.humanAttackables objectAtIndex:j];
                
                //if the computer should win via perceptron, then select for attack
                if([self perceptron:attacker.soldiers:gonnaAttack.soldiers] && attacker.soldiers>1)
                {
                    attacked = gonnaAttack;
                    break;
                }
            }
            //if a country can be successfully attacked break out of second loop
            if(attacked.name!=@"not good")
            {
                break;
            }
        }
        
        //sets willWin to false if there is no country that the perceptron calculates a win against
        if(attacked.name==@"not good")
        {
            willWin=false;
        }
        
        //if the computer should win the attack
        if(willWin)
        {
            //if the coomputer's country only has one soldier, then it can't attack
            if(attacker.soldiers==1)
            {
                NSLog(@"Computer doesn't attack");
                [self humanMove:board :numOfCountry :turn];
                if([self isWinner:board :numOfCountry])
                {
                    return;
                }
            }
            NSLog(@"Computer attacks with: %@",attacker.name);

        //if the country should win the attack
        if([self perceptron:attacker.soldiers:attacked.soldiers])
        {
            int attacks;
            int defends;
            
                //attack until the computer can't attack or should lose
                while (attacker.soldiers>1 && [self perceptron:attacker.soldiers :attacked.soldiers] && attacked.isHuman) {
                    
                    //gets the number of soldiers
                    attacks = attacker.soldiers;
                    defends = attacked.soldiers;
                
                    NSLog(@"Computer attacks: %@",attacked.name);
                    
                    //make an attack
                    [board riskAttack:attacker:attacked];
                
                    //see if there is a winner
                    if([self isWinner:board :numOfCountry])
                    {
                        return;
                    }
                }
            }
        }
    }
    
    //calculate human reinforcements
    soldiers = [self calculateReinforcementsHuman:board :[board.worldOfRisk count] :turn];
    NSLog(@"Soldiers: %d",soldiers);
    
    //checks for a winner
    if([self isWinner:board :numOfCountry])
    {
        return;
    }
    
    //refreshes tables
    [humanTable reloadData];
    [computerTable reloadData];
}

//a human move just reload data since most of a human's move is the user interfaces...later
-(void)humanMove:(World*)w:(int)x:(int)y{
    [humanTable reloadData];
    [computerTable reloadData];
}

//sets the game board with every country and defines which countries can be attacked
-(int)setBoard:(World*)h{
    int countries;
    
    //creates Alaska
    Country* alaska= [[Country alloc]init];
    int oneSoldier=1;
    alaska.name = @"Alaska";
    alaska.isHuman = true;
    countries++;
    [alaska addSoldiers:oneSoldier];
    
    //creates Northwest Territory
    Country* nwTerritory= [[Country alloc]init];
    nwTerritory.name = @"Northwest Territory";
    nwTerritory.isHuman = false;
    countries++;
    [nwTerritory addSoldiers:oneSoldier];
    
    //creates Greenland
    Country* greenland= [[Country alloc]init];
    greenland.name = @"Greenland";
    greenland.isHuman = true;
    countries++;
    [greenland addSoldiers:oneSoldier];
    
    //creates Alberta
    Country* alberta= [[Country alloc]init];
    alberta.name = @"Alberta";
    alberta.isHuman = false;
    countries++;
    [alberta addSoldiers:oneSoldier];
    
    //creates Ontario
    Country* ontario= [[Country alloc]init];
    ontario.name = @"Ontario";
    ontario.isHuman = true;
    countries++;
    [ontario addSoldiers:oneSoldier];
    
    //creates Eastern Canada
    Country* eaCanada= [[Country alloc]init];
    eaCanada.name = @"Eastern Canada";
    eaCanada.isHuman = false;
    countries++;
    [eaCanada addSoldiers:oneSoldier];
    
    //creates Western US
    Country* weUS= [[Country alloc]init];
    weUS.name = @"Western US";
    weUS.isHuman = true;
    countries++;
    [weUS addSoldiers:oneSoldier];
    
    //creates Eastern US
    Country* eaUS= [[Country alloc]init];
    eaUS.name = @"Eastern US";
    eaUS.isHuman = false;
    countries++;
    [eaUS addSoldiers:oneSoldier];
    
    //creates Central America
    Country* central= [[Country alloc]init];
    central.name = @"Central America";
    central.isHuman = true;
    countries++;
    [central addSoldiers:oneSoldier];
    
    //creates Venezuela
    Country* vene= [[Country alloc]init];
    vene.name = @"Venezuela";
    vene.isHuman = false;
    countries++;
    [vene addSoldiers:oneSoldier];
    
    //creates Brazil
    Country* brazil= [[Country alloc]init];
    brazil.name = @"Brazil";
    brazil.isHuman = true;
    countries++;
    [brazil addSoldiers:oneSoldier];
    
    //creates Peru
    Country* peru= [[Country alloc]init];
    peru.name = @"Peru";
    peru.isHuman = false;
    countries++;
    [peru addSoldiers:oneSoldier];
    
    //creates Argentina
    Country* argentina= [[Country alloc]init];
    argentina.name = @"Argentina";
    argentina.isHuman = true;
    countries++;
    [argentina addSoldiers:oneSoldier];
    
    //creates New Guinnea
    Country* newGuinnea= [[Country alloc]init];
    newGuinnea.name = @"New Guinnea";
    newGuinnea.isHuman = false;
    countries++;
    [newGuinnea addSoldiers:oneSoldier];
    
    //creates Indonesia
    Country* indo= [[Country alloc]init];
    indo.name = @"Indonesia";
    indo.isHuman = true;
    countries++;
    [indo addSoldiers:oneSoldier];
    
    //creates Western Australia
    Country* weAustralia= [[Country alloc]init];
    weAustralia.name = @"Western Australia";
    weAustralia.isHuman = false;
    countries++;
    [weAustralia addSoldiers:oneSoldier];
    
    //creates Eastern Australia
    Country* eaAustralia= [[Country alloc]init];
    eaAustralia.name = @"Eastern Australia";
    eaAustralia.isHuman = true;
    countries++;
    [eaAustralia addSoldiers:oneSoldier];
    
    //creates North Africa
    Country* norAfrica= [[Country alloc]init];
    norAfrica.name = @"North Africa";
    norAfrica.isHuman = false;
    countries++;
    [norAfrica addSoldiers:oneSoldier];
    
    //creates Egypt
    Country* egypt= [[Country alloc]init];
    egypt.name = @"Egypt";
    egypt.isHuman = true;
    countries++;
    [egypt addSoldiers:oneSoldier];
    
    //creates East Africa
    Country* eaAfrica= [[Country alloc]init];
    eaAfrica.name = @"Eastern Africa";
    eaAfrica.isHuman = false;
    countries++;
    [eaAfrica addSoldiers:oneSoldier];
    
    //creates Central Africa
    Country* centralAfrica= [[Country alloc]init];
    centralAfrica.name = @"Central Africa";
    centralAfrica.isHuman = true;
    countries++;
    [centralAfrica addSoldiers:oneSoldier];
    
    //creates South Africa
    Country* southAfrica= [[Country alloc]init];
    southAfrica.name = @"South Africa";
    southAfrica.isHuman = false;
    countries++;
    [southAfrica addSoldiers:oneSoldier];
    
    //creates Madagascar
    Country* madagas= [[Country alloc]init];
    madagas.name = @"Madagascar";
    madagas.isHuman = true;
    countries++;
    [madagas addSoldiers:oneSoldier];
    
    //creates Iceland
    Country* ireland= [[Country alloc]init];
    ireland.name = @"Iceland";
    ireland.isHuman = false;
    countries++;
    [ireland addSoldiers:oneSoldier];
    
    //creates Great Britain
    Country* greBritain= [[Country alloc]init];
    greBritain.name = @"Great Britain";
    greBritain.isHuman = true;
    countries++;
    [greBritain addSoldiers:oneSoldier];
    
    //creates Western Europe
    Country* weEurope= [[Country alloc]init];
    weEurope.name = @"Western Europe";
    weEurope.isHuman = false;
    countries++;
    [weEurope addSoldiers:oneSoldier];
    
    //creates South Europe
    Country* southEurope= [[Country alloc]init];
    southEurope.name = @"South Europe";
    southEurope.isHuman = true;
    countries++;
    [southEurope addSoldiers:oneSoldier];
    
    //creates Northern Europe
    Country* northernEurope= [[Country alloc]init];
    northernEurope.name = @"Northern Europe";
    northernEurope.isHuman = false;
    countries++;
    [northernEurope addSoldiers:oneSoldier];
    
    //creates Scandinavia
    Country* scandi= [[Country alloc]init];
    scandi.name = @"Scandinavia";
    scandi.isHuman = true;
    countries++;
    [scandi addSoldiers:oneSoldier];
    
    //creates Russia
    Country* russia= [[Country alloc]init];
    russia.name = @"Russia";
    russia.isHuman = false;
    countries++;
    [russia addSoldiers:oneSoldier];
    
    //creates Middle East
    Country* middleEast= [[Country alloc]init];
    middleEast.name = @"Middle East";
    middleEast.isHuman = true;
    countries++;
    [middleEast addSoldiers:oneSoldier];
    
    //creates Afghanistan
    Country* afghan= [[Country alloc]init];
    afghan.name = @"Afghanistan";
    afghan.isHuman = false;
    countries++;
    [afghan addSoldiers:oneSoldier];
    
    //creates India
    Country* india= [[Country alloc]init];
    india.name = @"India";
    india.isHuman = true;
    countries++;
    [india addSoldiers:oneSoldier];
    
    //creates China
    Country* china= [[Country alloc]init];
    china.name = @"China";
    china.isHuman = false;
    countries++;
    [china addSoldiers:oneSoldier];
    
    //creates Southeast Asia
    Country* southeastAsia= [[Country alloc]init];
    southeastAsia.name = @"Southeast Asia";
    southeastAsia.isHuman = true;
    countries++;
    [southeastAsia addSoldiers:oneSoldier];
    
    //creates Mongolia
    Country* mongol= [[Country alloc]init];
    mongol.name = @"Mongolia";
    mongol.isHuman = false;
    countries++;
    [mongol addSoldiers:oneSoldier];
    
    //creates Japan
    Country* japan= [[Country alloc]init];
    japan.name = @"Japan";
    japan.isHuman = true;
    countries++;
    [japan addSoldiers:oneSoldier];
    
    //creates Siberia
    Country* siberia= [[Country alloc]init];
    siberia.name = @"Siberia";
    siberia.isHuman = false;
    countries++;
    [siberia addSoldiers:oneSoldier];
    
    //creates Yakutsk
    Country* yakutsk= [[Country alloc]init];
    yakutsk.name = @"Yakutsk";
    yakutsk.isHuman = true;
    countries++;
    [yakutsk addSoldiers:oneSoldier];
    
    //creates Ural
    Country* ural= [[Country alloc]init];
    ural.name = @"Ural";
    ural.isHuman = false;
    countries++;
    [ural addSoldiers:oneSoldier];
    
    //creates Kamchatka
    Country* kamchatka= [[Country alloc]init];
    kamchatka.name = @"Kamchatka";
    kamchatka.isHuman = true;
    countries++;
    [kamchatka addSoldiers:oneSoldier];
    
    //creates Irkutsk
    Country* irkutsk = [[Country alloc]init];
    irkutsk.name = @"Irkutsk";
    irkutsk.isHuman = false;
    countries++;
    [irkutsk addSoldiers:oneSoldier];
    
    //sets up attackable countries in North America
    [alaska setAttackable:nwTerritory];
    [alaska setAttackable:alberta];
    [alaska setAttackable:kamchatka];
    [nwTerritory setAttackable:alaska];
    [nwTerritory setAttackable:alberta];
    [nwTerritory setAttackable:ontario];
    [nwTerritory setAttackable:greenland];
    [alberta setAttackable:alaska];
    [alberta setAttackable:nwTerritory];
    [alberta setAttackable:ontario];
    [alberta setAttackable:weUS];
    [ontario setAttackable:nwTerritory];
    [ontario setAttackable:alberta];
    [ontario setAttackable:eaUS];
    [ontario setAttackable:eaCanada];
    [ontario setAttackable:greenland];
    [ontario setAttackable:weUS];
    [greenland setAttackable:nwTerritory];
    [greenland setAttackable:ontario];
    [greenland setAttackable:eaCanada];
    [greenland setAttackable:ireland];
    [eaCanada setAttackable:greenland];
    [eaCanada setAttackable:ontario];
    [eaCanada setAttackable:eaUS];
    [eaUS setAttackable:central];
    [eaUS setAttackable:weUS];
    [eaUS setAttackable:ontario];
    [eaUS setAttackable:eaCanada];
    [weUS setAttackable:alberta];
    [weUS setAttackable:ontario];
    [weUS setAttackable:eaUS];
    [weUS setAttackable:central];
    [central setAttackable:weUS];
    [central setAttackable:eaUS];
    [central setAttackable:vene];
    
    //sets up attackable countries in South America
    [vene setAttackable:central];
    [vene setAttackable:peru];
    [vene setAttackable:brazil];
    [peru setAttackable:vene];
    [peru setAttackable:brazil];
    [peru setAttackable:argentina];
    [argentina setAttackable:peru];
    [argentina setAttackable:brazil];
    [brazil setAttackable:vene];
    [brazil setAttackable:peru];
    [brazil setAttackable:argentina];
    [brazil setAttackable:norAfrica];
    
    //sets up attackable countries in Australia
    [weAustralia setAttackable:eaAustralia];
    [weAustralia setAttackable:indo];
    [weAustralia setAttackable:newGuinnea];
    [eaAustralia setAttackable:weAustralia];
    [eaAustralia setAttackable:indo];
    [eaAustralia setAttackable:newGuinnea];
    [indo setAttackable:newGuinnea];
    [indo setAttackable:weAustralia];
    [indo setAttackable:southeastAsia];
    [newGuinnea setAttackable:indo];
    [newGuinnea setAttackable:weAustralia];
    [newGuinnea setAttackable:eaAustralia];
    
    //sets up attackable countries in Africa
    [norAfrica setAttackable:brazil];
    [norAfrica setAttackable:egypt];
    [norAfrica setAttackable:eaAfrica];
    [norAfrica setAttackable:centralAfrica];
    [norAfrica setAttackable:weEurope];
    [norAfrica setAttackable:southEurope];
    [egypt setAttackable:southEurope];
    [egypt setAttackable:norAfrica];
    [egypt setAttackable:eaAfrica];
    [egypt setAttackable:middleEast];
    [eaAfrica setAttackable:egypt];
    [eaAfrica setAttackable:norAfrica];
    [eaAfrica setAttackable:centralAfrica];
    [eaAfrica setAttackable:southAfrica];
    [eaAfrica setAttackable:madagas];
    [eaAfrica setAttackable:middleEast];
    [centralAfrica setAttackable:norAfrica];
    [centralAfrica setAttackable:eaAfrica];
    [centralAfrica setAttackable:southAfrica];
    [southAfrica setAttackable:centralAfrica];
    [southAfrica setAttackable:eaAfrica];
    [southAfrica setAttackable:madagas];
    [madagas setAttackable:southAfrica];
    [madagas setAttackable:eaAfrica];
    
    //sets up attackable countries in Europe
    [ireland setAttackable:greenland];
    [ireland setAttackable:greBritain];
    [ireland setAttackable:scandi];
    [greBritain setAttackable:ireland];
    [greBritain setAttackable:scandi];
    [greBritain setAttackable:northernEurope];
    [scandi setAttackable:ireland];
    [scandi setAttackable:greBritain];
    [scandi setAttackable:northernEurope];
    [scandi setAttackable:russia];
    [northernEurope setAttackable:greBritain];
    [northernEurope setAttackable:scandi];
    [northernEurope setAttackable:russia];
    [northernEurope setAttackable:weEurope];
    [northernEurope setAttackable:southEurope];
    [weEurope setAttackable:norAfrica];
    [weEurope setAttackable:northernEurope];
    [weEurope setAttackable:southEurope];
    [southEurope setAttackable:weEurope];
    [southEurope setAttackable:northernEurope];
    [southEurope setAttackable:russia];
    [southEurope setAttackable:norAfrica];
    [southEurope setAttackable:egypt];
    [southEurope setAttackable:middleEast];
    [russia setAttackable:scandi];
    [russia setAttackable:northernEurope];
    [russia setAttackable:southEurope];
    [russia setAttackable:ural];
    [russia setAttackable:afghan];
    [russia setAttackable:middleEast];
    
    //sets up attackable countries in Asia
    [middleEast setAttackable:egypt];
    [middleEast setAttackable:eaAfrica];
    [middleEast setAttackable:southEurope];
    [middleEast setAttackable:russia];
    [middleEast setAttackable:afghan];
    [middleEast setAttackable:india];
    [afghan setAttackable:russia];
    [afghan setAttackable:middleEast];
    [afghan setAttackable:ural];
    [afghan setAttackable:india];
    [afghan setAttackable:china];
    [india setAttackable:middleEast];
    [india setAttackable:afghan];
    [india setAttackable:china];
    [india setAttackable:southeastAsia];
    [southeastAsia setAttackable:india];
    [southeastAsia setAttackable:china];
    [southeastAsia setAttackable:indo];
    [china setAttackable:southeastAsia];
    [china setAttackable:india];
    [china setAttackable:afghan];
    [china setAttackable:ural];
    [china setAttackable:siberia];
    [china setAttackable:mongol];
    [ural setAttackable:russia];
    [ural setAttackable:afghan];
    [ural setAttackable:china];
    [ural setAttackable:siberia];
    [siberia setAttackable:ural];
    [siberia setAttackable:china];
    [siberia setAttackable:yakutsk];
    [siberia setAttackable:irkutsk];
    [siberia setAttackable:mongol];
    [mongol setAttackable:china];
    [mongol setAttackable:siberia];
    [mongol setAttackable:irkutsk];
    [mongol setAttackable:kamchatka];
    [mongol setAttackable:japan];
    [japan setAttackable:mongol];
    [japan setAttackable:kamchatka];
    [irkutsk setAttackable:mongol];
    [irkutsk setAttackable:siberia];
    [irkutsk setAttackable:yakutsk];
    [irkutsk setAttackable:kamchatka];
    [yakutsk setAttackable:irkutsk];
    [yakutsk setAttackable:siberia];
    [yakutsk setAttackable:kamchatka];
    [kamchatka setAttackable:yakutsk];
    [kamchatka setAttackable:irkutsk];
    [kamchatka setAttackable:mongol];
    [kamchatka setAttackable:japan];
    [kamchatka setAttackable:alaska];
    
    //populates the game board
    [gameBoard populateWorld:alaska];
    [h populateWorld:alberta];
    [h populateWorld:nwTerritory];
    [h populateWorld:greenland];
    [gameBoard populateWorld:ontario];
    [gameBoard populateWorld:eaCanada];
    [gameBoard populateWorld:eaUS];
    [gameBoard populateWorld:weUS];
    [gameBoard populateWorld:central];
    [gameBoard populateWorld:vene];
    [gameBoard populateWorld:peru];
    [gameBoard populateWorld:argentina];
    [gameBoard populateWorld:brazil];
    [gameBoard populateWorld:weAustralia];
    [gameBoard populateWorld:eaAustralia];
    [gameBoard populateWorld:indo];
    [gameBoard populateWorld:newGuinnea];
    [gameBoard populateWorld:norAfrica];
    [gameBoard populateWorld:egypt];
    [gameBoard populateWorld:eaAfrica];
    [gameBoard populateWorld:centralAfrica];
    [gameBoard populateWorld:southAfrica];
    [gameBoard populateWorld:madagas];
    [gameBoard populateWorld:ireland];
    [gameBoard populateWorld:scandi];
    [gameBoard populateWorld:greBritain];
    [gameBoard populateWorld:southEurope];
    [gameBoard populateWorld:northernEurope];
    [gameBoard populateWorld:weEurope];
    [gameBoard populateWorld:russia];
    [gameBoard populateWorld:middleEast];
    [gameBoard populateWorld:afghan];
    [gameBoard populateWorld:india];
    [gameBoard populateWorld:china];
    [gameBoard populateWorld:southeastAsia];
    [gameBoard populateWorld:mongol];
    [gameBoard populateWorld:ural];
    [gameBoard populateWorld:siberia];
    [gameBoard populateWorld:japan];
    [gameBoard populateWorld:irkutsk];
    [gameBoard populateWorld:yakutsk];
    [gameBoard populateWorld:kamchatka];
    
    //returns the number of countries on the board
    return countries;
    
}

//calculates if there is a winner
-(bool)isWinner:(World*)board:(int)countries{
    int counter=0;
    int computerCounter=countries;
    Country* x= [[Country alloc]init];
    
    for(int i=0; i<countries; i++)
    {
        
        x=[board getCountry:i];
        if([x isHuman]==false)
        {
            counter++;
        }
        else
        {
            computerCounter--;
        }
    }
    if(counter==0 || counter==countries)
    {
        return true;
    }
    else{
        return false;
    }
}

//announces the winner
-(bool)announceWinner:(World*)w{
    NSLog(@"Computer wins");
    return true;
}

//sets the computer reinforcements on the board
-(void)setComputerReinforcements:(NSMutableArray*)board:(int)numOfCountry:(int)n{
    
    //allocates for countries
    Country* newCountry = [[Country alloc]init];
    Country* humanBest= [[Country alloc]init];
    Country* x= [[Country alloc]init];
        x.name = @"Not Good";
    
    humanBest.soldiers=1;
    
    //loops through the human countries
    for(int i=0; i<[gameBoard.humanCountries count];i++)
    {
        //checks which country has the most troops
        newCountry = [gameBoard.humanCountries objectAtIndex:i];
        if(newCountry.soldiers>humanBest.soldiers)
        {
            humanBest = newCountry;
        }
    }
    
    //sets attackables
    [humanBest setComputerAttackable];
    [humanBest setHumanAttackable];
    
    //loops through the computer's soldiers
    for(int i=0;i<n;i++)
    {
        //checks if the human controls a continent
        if ([self isAsia:gameBoard]) {
            NSLog(@"I need to take an asia country");
            x = [self calculateClosestAsia];
        }
        //checks if the human controls a continent
        else if([self isNorthAmerica:gameBoard])
        {
            NSLog(@"I need to take a north america country");
            x = [self calculateClosestNorthAmerica];
        }
        //checks if the human controls a continent
        else if([self isEurope:gameBoard])
        {
            NSLog(@"I need to take a europe country");
            x = [self calculateClosestEurope];
        }
        //checks if the human controls a continent
        else if([self isAfrica:gameBoard])
        {
            NSLog(@"I need to take an african country");
            x = [self calculateClosestAfrica];
        }
        //checks if the human controls a continent
        else if([self isSouthAmerica:gameBoard])
        {
            NSLog(@"I need to take a south american coutnry");
            x = [self calculateClosestSouthAmerica];
        }
        //checks if the human controls a continent
        else if([self isAustralia:gameBoard])
        {
            NSLog(@"I need to take an australian country");
            x = [self calculateClosestAustralia];
        }
        
        //if there is not a continent
        if(x.name == @"Not Good")
        {
            //keep adding soldiers until there are no more or the computer should win then randomly add
            if([humanBest.computerAttackables count]==0 || humanBest.soldiers==1 || [self perceptron:x.soldiers:humanBest.soldiers])
            {          
                Country* c = [[Country alloc]init];
                
                //randomly adds soldiers
                int j=arc4random()%numOfCountry;
                c=[board objectAtIndex:j];
                c.soldiers++;
            }
            //add soldiers to a specific country
            else{
                int j=0;
                x=[humanBest.computerAttackables objectAtIndex:j];
                x.soldiers++;
            }
        }
        else{
            x.soldiers++;
        }
    }
}

//calculates the number of reinforcements the human gets
-(int)calculateReinforcementsHuman:(World*)board:(int)numOfCountry:(int)turns{
    int reinforcements = 5+turns;
    int counter = 0;
    
    //if human has all of north america, then give 5 extra soldiers
    if([self isNorthAmerica:board])
    {
        reinforcements += 5;
    }
    
    //if human has all of south america, then give 2 extra soldiers
    if([self isSouthAmerica:board])
    {
        reinforcements += 2;
    }
    
    //if human has all of Africa, then give 3 extra soldiers
    if([self isAfrica:board])
    {
        reinforcements += 3;
    }
    
    //if human has all of Europe, then give 5 extra soldiers
    if([self isEurope:board])
    {
        reinforcements += 5;
    }
    
    //if human has all of Australia, then give 2 extra soldiers
    if([self isAustralia:board])
    {
        reinforcements +=2;
    }
    
    //if human has all of Asia, then give 7 extra soldiers
    if([self isAsia:board])
    {
        reinforcements +=7;
    }
    
    //gets the number of countries controlled by the computer
    for(int i=0; i<numOfCountry;i++)
    {
        Country* z= [[Country alloc]init];
        z= [board getCountry:i];
        if([z isHuman])
        {
            counter++;
        }
    }
    //for every 4 countries human gets an extra soldier
    int extra = counter/4;
    reinforcements += extra;
    return reinforcements;
}

//calculates how many soldiers the computer
-(int)calculateReinforcementsComputer:(World*)board:(int)numOfCountry:(int)turns{
    int reinforcements = 5+turns;
    int counter = 0;
    
    //if human has all of north america, then give 5 extra soldiers
    if([self isNorthAmerica:board]==false)
    {
        reinforcements += 5;
    }
    
    //if human has all of south america, then give 2 extra soldiers
    if([self isSouthAmerica:board]==false)
    {
        reinforcements += 2;
    }
    
    //if human has all of Africa, then give 3 extra soldiers
    if([self isAfrica:board]==false)
    {
        reinforcements += 3;
    }
    
    //if human has all of Europe, then give 5 extra soldiers
    if([self isEurope:board]==false)
    {
        reinforcements += 5;
    }
    
    //if human has all of Australia, then give 2 extra soldiers
    if([self isAustralia:board]==false)
    {
        reinforcements +=2;
    }
    
    //if human has all of Asia, then give 7 extra soldiers
    if([self isAsia:board]==false)
    {
        reinforcements +=7;
    }
    
    //loops through all the computer countries
    for(int i=0; i<numOfCountry;i++)
    {
        Country* z = [[Country alloc]init];
        z= [board getCountry:i];
        if([z isHuman]==false)
        {
            counter++;
        }
    }
    
    //for every 4 computer gets an extra soldier
    int extra = counter/4;
    reinforcements += extra;
    soldiers = reinforcements;
    [humanTable reloadData];
    [computerTable reloadData];
    return reinforcements;
}

//defines the number of rows in a table view
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    //if it is the move phase then both tables should have rows equal to the number of human countries
    if(moveTroops) 
    {
        return [gameBoard.humanCountries count];
    }
    //if it is attack phase
    else if(attack)
    {
        //human table view is the number of human countries
        if(tableView==humanTable)
        {
            return [gameBoard.humanCountries count];
        }
        //if a human country is selected then show that countries attackables
        else if(tableView==computerTable && flag==true)
        {
            return [attackingCountry.computerAttackables count];
        }
        //if no human country is chosen then show all computer countries
        else{
            return [gameBoard.computerCountries count];
        }
    }
    //if it is position phase
    else if(positionTroops)
    {
        //human table is equal to number of soldiers
        if(tableView==humanTable)
        {
            return soldiers;
        }
        //computer table is equal to number of huamn countries
        else{
            return [gameBoard.humanCountries count];
        }
    }
    //if it is move phase
    else if(moveTroops)
    {
        //human table is equal to number of human countries
        if(tableView == humanTable)
        {
            return [gameBoard.humanCountries count];
        }
        //human table is equal to number of human countries
        else
        {
            return [gameBoard.humanCountries count];
        }
    }
    //if no phase show each others countries
    else{
        if(tableView == humanTable)
        {
            return [gameBoard.humanCountries count];
        }
        else
        {
            return [gameBoard.worldOfRisk count]-[gameBoard.humanCountries count];
        }
    }
}

//defines individual cells
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Default";
	
    //initializes a cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //cells have red text
        cell.textLabel.textColor = [UIColor redColor];
    }
	
    //if position phase
    if(positionTroops) {
        //if human table then set up what the cell should say
        if (tableView==humanTable) {
            int x = indexPath.row;
            cell.textLabel.text = [NSString stringWithFormat:@"Position %d Troops",x+1];
            return cell;
        }
        //else it is the computer table and should show the human's countries
        else
        {
            Country *myCountry=[[Country alloc]init];
            myCountry = [gameBoard.humanCountries objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
            return cell;
        }
    }
    //if move phase
    else if(moveTroops)
    {
        //if human table then show the human's countries
        if(tableView == humanTable){
            Country * myCountry= [[Country alloc]init];
            myCountry= [gameBoard.humanCountries objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
            
            return cell;
        }
        else{
            //computer table should show the human's countries as well
            Country * myCountry = [[Country alloc]init];
            myCountry = [gameBoard.humanCountries objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
            
            return cell;
        }
    }
    //if attack phase
    else if(attack)
    {
        //human table should show human countries
        if(tableView == humanTable){
            Country * myCountry= [[Country alloc]init];
            myCountry= [gameBoard.humanCountries objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
            
            return cell;
        }
        //computer table should show the attackable countries of the selected country
        else if(tableView == computerTable && flag==true)
        {
            Country * myCountry = [[Country alloc]init];
            myCountry = [attackingCountry.computerAttackables objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
            
            return cell;
        }
        //if no cuntry is selected then computer table should show all computer countries
        else{
            Country * myCountry = [[Country alloc]init];
            myCountry = [gameBoard.computerCountries objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
            
            return cell;
        }
    }
    //if no phase then just show human and computer countries respectively
    else{
        if(tableView == humanTable){
            Country * myCountry= [[Country alloc]init];
            myCountry= [gameBoard.humanCountries objectAtIndex:indexPath.row];
    
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
    
            return cell;
        }
        else{
            Country * myCountry = [[Country alloc]init];
            myCountry = [gameBoard.computerCountries objectAtIndex:indexPath.row];
        
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",myCountry.name,myCountry.soldiers];
        
            return cell;
        }
    }
}

//if the user selects a row, used for the human's turn
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    
    //if position phase
    if(positionTroops)
    {
        //the human table the selected row will be the number of soldiers to position
        if(tableView==humanTable)
        {
            int x = indexPath.row;
            NSLog(@"Selected '%d'", x);
            soldiersToMove = x+1;
        }
        //the computer table will select the country to position troops on
        else
        {
            Country * myCountry = [[Country alloc]init];
            myCountry =[gameBoard.humanCountries objectAtIndex:indexPath.row];
            NSLog(@"Selected '%@'",myCountry.name);
            whereToMove = myCountry;
        }
        
    }
    
    //if move phase
    if(moveTroops)
    {
        //human table selects the country to move troops from
        if(tableView==humanTable)
        {
            attackingCountry = [gameBoard.humanCountries objectAtIndex:indexPath.row];
        }
        //computer table selects the country to move troops to
        else{
            defendingCountry = [gameBoard.humanCountries objectAtIndex:indexPath.row];
            myButton.enabled = YES;
        }
    }
    
    //if attack phase
    else if(attack)
    {
        //the human table selects the country to attack with
        if(tableView==humanTable)
        {
            attackingCountry = [gameBoard.humanCountries objectAtIndex:indexPath.row];
            [attackingCountry setComputerAttackable];
            flag=true;
            [computerTable reloadData];
        }
        //the computer table selects the country to attack
        else
        {
            defendingCountry = [attackingCountry.computerAttackables objectAtIndex:indexPath.row];
            myButton.enabled = YES;
            myButton.titleLabel.text = @"Attack";
        }
    }
    
}

//perceptron takes in # of attackers and # of defenders
-(bool)perceptron:(int)attackers:(int)defenders
{
    //sums up weights and numbers
    int total =0;
    total = weight1*attackers+weight2*defenders+weight3;
    
    //squash function
    if(total>.5)
    {
        return true;
    }
    else{
        return false;
    }
}

//trains the perceptron, takes in # of attackers, # of defenders, T/F
-(void)trainPerceptron:(int)attackers:(int)defenders:(bool)val
{
    //sums up all the weights and numbers
    int total =0;
    percept=false;
    
    total = (weight1*attackers)+(weight2*defenders)+weight3;
    
    //if total>.5 then guess true
    if(total>.5)
        percept=true;
    //else guess false
    else
        percept=false;
    
        //updates weight values
        weight1=weight1 + (val-percept)*(attackers);
        weight2=weight2 + (val-percept)*(defenders);
}

@end
