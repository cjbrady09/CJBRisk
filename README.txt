Clayton Brady

This is my risk game I made and it is programmed in objective C. The game is written for an iPad positioned in landscape orientation. The AI is programmed with perceptrons to determine when it should attack and where to place soldiers on the board.  The computer currently can't move soldiers but I plan on adding that in future versions.  

Contents:
CJBRisk.xcodeproj: Click on this link to load the entire project into Xcode. This allows for quick launching of my code.

AppDelegate.h: this defines what properties and methods will happen at the launch of the app.

AppDelegate.m: this is where the code is that executes at the first launch. None of my code is in this file but it is necessary to run.

CJBRisk-info.plist: This defines certain attributes the app has such as a logo, orientation, and splash screen information.

CJBRisk-Prefix.pch: I'm not exactly sure what this one is.  It is auto generated with every app.

Country.h:  This is one of the major parts of my code.  It defines what a country can have and do.

Coountry.m:  This is the actual code that a country can execute and call. Countries have a few properties such as attackables which define which country can be attacked by another.

main.m: This defines the main method that executes the rest of the code. This is auto generated and not messed with in an app.

ViewController.h:  This is the main view controller where all the user interface is and most of the code.  This serves as a the "main" method where my actual code is written. This file simply defines properties and methods.

ViewController.m:  This is the file with most of my code and runs the above properties and methods.  This is where the computer AI is located and defines different phases of the game.

World.h:  This defines a world class which contains many different countries. The world is the basic game board.

World.m:  This is the implementation of the above class. It contains the code to execute all the methods defined in World.h

Running the Code:
First open up the file containing the code and double click on CJBrisk.xcodeproj to load the code within Xcode.  Once all the code is loaded, make sure that the iPad 5.0 simulator is chosen in the top left corner of Xcode.  Once it is selected click on the run button in the top left corner to run the code. Then once the simulator comes up, you have to turn the app to landscape by selecting hardware in the menu bar and rotate either left or right.

Defining the Game:
The first turn starts with 50 soldiers to position on your countries.  You don't get to see where the computer places their first soldiers so it is completely fair when the first turn starts.  

You are then able to make the first attacks against the computer agents.  To do so, choose a country in the left table view, then the right table view will update to show which countries the selected country can attack.  When you are done attacking, hit the done button in the top right corner. 

Next you will have the option of moving soldiers to another location. To do so first select the country you want to move troops from and then select the country you want to move troops to. You must leave 1 soldier at least on each country. When you are done moving soldiers then hit done and the computer's turn begins.  

The computer's turn will happen almost instantaneously and will position troops and attack.  The computer will only attack if the perceptron determines it will win, and it will place troops next to countries until the perceptron determines it should win against the bordering country.  WARNING!!!  Do not waste a turn or the AI will almost certainly win.

There is one thing currently not implemented and that is the code recognizing when a competitor wins.  I simply ran out of time to finish the code so the app will die when one person wins.
