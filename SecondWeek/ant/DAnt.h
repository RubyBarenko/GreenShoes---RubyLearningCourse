//---------------------------------------------------------------------------
#ifndef DAntH
#define DAntH
//---------------------------------------------------------------------------
#include "DAntRoad.h"
//---------------------------------------------------------------------------
class Ant
{
 private:

 // Indicates the Ant's pheromone sensibility
 float alfa;
 float beta;
 float gamma;

 int FoodCollected;       // Amount of food collected by this Ant

 bool HaveFood;           // Indicates if the Ant is carrying food

 TList    *VisitedCities; // Address of the visited cities during a tour

 int DistanceRemaining;   // Distance remaining to reach the next city
                          // If [DistanceRemaining] is zero,
                          // this ant is on the [TargetCity],
                          // else it's on the [Road]

 public:

 int LostCounter;         // Counts how many times has chosen a repeated route
 Route *Road;             // Route where this ant is traveling
 City *TargetCity;        // City that will be reached at the end of the [Road]

 Ant();                                         // Default constructor: completely new individual
 Ant(Ant *Father, Ant *Mother);                 // Crossover constructor
 ~Ant();                                        // Default destructor

 float GetTendency(int PheroLevel);             // Evaluates the tendency of choosing a given route
 void PickFood()   { HaveFood = true;  };       // Pick food when in the food source
 void LeaveFood();                              // Leave food when in the nest
 void PutPheromone();                           // Increase the pheromone level of the chosen route
 void Walk();                                   // Walk one more step
 void Mutation();                               // Perform mutation

 // Auxiliary Methods:
 bool IsOnTheRoad();                            // Returns true if this ant is traveling
 bool CarryingFood() { return HaveFood; };      // Returns true if this ant is carrying food
 int GetFoodCollected() { return FoodCollected; };  // Returns the amount of food collected by this Ant
 void SetDistance(int d) {DistanceRemaining = d; }; // Sets the distance remaining before reach the target city
 void RememberCity();                               // Remember the cities where this ant has been
 bool PrepareTrail();                               // Prepare the trail back to the nest
 City* GetNextCity();                               // Get next city of the trail

 // Interface Methods:
 void DrawAnt(TImage* Terrain);                 // Draw this ant on the window acording to its position on the route
};
//---------------------------------------------------------------------------
#endif
 