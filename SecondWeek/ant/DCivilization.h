//---------------------------------------------------------------------------
#ifndef DCivilizationH
#define DCivilizationH
//---------------------------------------------------------------------------
#include "DAntRoad.h"
#include "DAntCity.h"
#include "DAnt.h"
#include <stdio.h>
//---------------------------------------------------------------------------
class Civilization
{
 private:

 int Epoch;                           // Current Turn
 int TurnsRemaining;                  // Turns remaining before next natural selection
 int FoodCollected;                   // Total amount of food collected

 City *FoodSourceCity;                // The Civilization's Food Source City
 City *Nest;                          // The Civilization's Nest

 TList    *Roads;                     // All Routes in the Environment
 TList    *Cities;                    // All Cities in the Environment
 TList    *Ants;                      // All Ants in the Environment

 City *CityBuildingRoad;              // Origin of a road been built

 // Interface private properties
 TImage *VirtualCiv;                  // Interface for the Simulation Panel
 TImage *Preview;                     // Interface for the Preview Panel
 TScrollBox *VirtualTerrain;
 TLabel *LabelEpoch;                  // Label that show the current turn number

 // Auxiliary private properties and methods
 TList    *DeliveryTime;              // Holds data to evaluate current food per turn rate
 City *GetCityAddress(int Index);

 public:

 Civilization(TImage*,TScrollBox*,TImage*,TLabel*);   // Default Constructor
 ~Civilization();                                     // Default Destructor

 void NaturalSelection();       // Perform Natural Selection...
 void PerformEvolution();       // Run the simulation
 int NextTurn();                // Perform one turn of the simulation

 // Auxiliary Methods:
 void LoadAnts(void);           // Create inicial ants at random
 Ant* GetAnt(int Index);        // Return a pointer to an ant in the list
 void Restart();                // Restart the simulation environment
 void ClearTrails();            // Reset the pheromone intensity on all trails
 TList *GetRoads(){ return Roads; }; // Returns a pointer to the list of roads
 int AddCity(int X, int Y);     // Add a new city to the environment
 int BuildRoad(City *Dest);     // Build a route connecting two cities
 bool FoodRateReached(int Range, int Target); // Check if the food per turn rate was reached

 // Interface Methods:
 void SaveToFile(FILE *stream);                     // Save environment to file
 void LoadFromFile(FILE *stream);                   // Load environemtn from file
 int Rebuild(TImage *ImageBox, const float Scale);  // Redraw a viewport
 bool __fastcall DrawPreviewBoard();                // Redraw the preview panel
 bool __fastcall FindMainRoads(int Ntries, TImage *ImageBox, const int RWidth, const float Scale);
 void __fastcall CityMouseDown(TObject *Sender,TMouseButton Button, TShiftState Shift, int X, int Y);
};
//---------------------------------------------------------------------------
#endif
