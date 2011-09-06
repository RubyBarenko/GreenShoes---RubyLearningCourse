//---------------------------------------------------------------------------
#ifndef DAntRoadH
#define DAntRoadH
//---------------------------------------------------------------------------
#include "DAntCity.h"
//---------------------------------------------------------------------------
class Route
{
 private:
 int Pheromone;                 // Amount of pheromone in this route
 float Length;                  // Length of this route

 // Cities linked by this road
 City *FirstCity;
 City *SecondCity;

 TLabel *Info;                  // TLabel to show information on the main window

 public:
 Route(City *Orig, City *Dest, TScrollBox *Terrain);    // Default constructor
 ~Route();                                              // Default destructor

 void EvaporatePheromone() {  Pheromone-=1;  };         // Simulate the evaporation of pheromone

 // Auxiliary Methods:
 float GetLength();                                     // Returns the length of the route
 void IncreasePheromone(int v) { Pheromone+=v; };       // Increase the pheromone level by a given amount
 int GetPositionX(int Remaining);                       // Get position along the road
 int GetPositionY(int Remaining);                       //  "     "        "   "    "
 int GetPheromone() {return Pheromone; };
 int GetCityName(int N);                                // Returns the index of the route
 City* GetConection(City*);                             // Get the other city connected by this route
 void SetPheroTrail(int v);                             // Set pheromone trail to a given value

 // Interface Methods:
 void DrawRoad(TImage* Terrain, TColor thColor, const float Scale);
 void UpdateStatusInfo();
};
//---------------------------------------------------------------------------
#endif
