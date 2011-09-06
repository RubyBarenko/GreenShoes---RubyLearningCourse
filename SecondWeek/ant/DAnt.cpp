//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
#include "DAnt.h"
#include <math.h>
//---------------------------------------------------------------------------
#define EMPTYPHERO 1
#define LOADEDPHERO 100
#define RANDOM_VALUE (random(100)-50.0)/10.0  // Random number within [-5..5]
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
// Constructors/Destructors
//---------------------------------------------------------------------------
// Description: The defaul constructor creates a completely new individual at random
//              It is used to create the inicial population and to simulate migration
Ant::Ant()
{
 randomize();

 alfa  = RANDOM_VALUE;
 beta  = RANDOM_VALUE;
 gamma = RANDOM_VALUE;

 DistanceRemaining = 0;
 LostCounter       = 0;
 FoodCollected     = 0;
 VisitedCities  = new TList();
 HaveFood       = false;
 Road           = NULL;
 TargetCity     = NULL;
}
//---------------------------------------------------------------------------
// Description: Crossover constructor. Create a new individual as an offspring
//              of two others.
Ant::Ant(Ant *Father, Ant *Mother)
{
 randomize();

 int Chromosome[3];     // Chromosome with 3 genes

 // Fill the chromosome with 0s or 1s at random to simulate a crossover operation
 for( int i=0; i<3; i++ ) Chromosome[i] = random(1);

 // if the gene is 0, the characteristic will be inherited from the
 // mother and if it's 1, from the father.
 alfa  = (Chromosome[0]==0)?Mother->alfa:Father->alfa;
 beta  = (Chromosome[1]==0)?Mother->beta:Father->beta;
 gamma = (Chromosome[2]==0)?Mother->gamma:Father->gamma;

 DistanceRemaining = 0;
 LostCounter       = 0;
 FoodCollected     = 0;
 VisitedCities  = new TList();
 HaveFood       = false;
 Road           = NULL;
 TargetCity     = NULL;
}
//---------------------------------------------------------------------------
// Description: The default destructor free the memory that will no longer be used
Ant::~Ant()
{
 VisitedCities->Clear();
 delete VisitedCities;
}
//---------------------------------------------------------------------------
// Methods:
//---------------------------------------------------------------------------
// Description: Evaluates the tendency of choosing a given route
float Ant::GetTendency(int PheroLevel)
{
 return alfa * sin( beta*PheroLevel + gamma);
}
//---------------------------------------------------------------------------
// Description: Leave food when the ant is back in the nest
void Ant::LeaveFood()
{
 HaveFood = false;         // Not carrying food anymore
 FoodCollected++;          // Increase the amount of food collected

 VisitedCities->Clear();   // Clear memory
}
//---------------------------------------------------------------------------
// Description: Increase the pheromone level of the current route
void Ant::PutPheromone()
{
 if(CarryingFood()) Road->IncreasePheromone((FoodCollected+1)*LOADEDPHERO);
  else Road->IncreasePheromone(EMPTYPHERO);
}
//---------------------------------------------------------------------------
// Description: Walk one more step.
void Ant::Walk()
{
 DistanceRemaining-=10; // Decrease the distance remaining to reach the target city
}
//---------------------------------------------------------------------------
// Description: Perform mutation changing one of the characteristic at random
void Ant::Mutation()
{
 randomize();

 switch(random(3))
  {
   case 0: { alfa  = RANDOM_VALUE; break; }
   case 1: { beta  = RANDOM_VALUE; break; }
   case 2: { gamma = RANDOM_VALUE; break; }
  }
}
//---------------------------------------------------------------------------
// Auxiliary Methods
//---------------------------------------------------------------------------
bool Ant::IsOnTheRoad()
{
 return DistanceRemaining>0 ; // If the distance remaining > 0, the ant is still traveling
}
//---------------------------------------------------------------------------
void Ant::RememberCity()
{
 // if the ant has already been in this city, increase the 'LostCounter'
 if(VisitedCities->IndexOf(TargetCity)!=-1) LostCounter++;

 VisitedCities->Add(TargetCity);
}
//---------------------------------------------------------------------------
// Description: Prepare trail back to the nest. When the ant is carrying food
//              it will follow its own trail until the nest is reached.
bool Ant::PrepareTrail()
{
 TList *BackTrail = new TList();
 City *mCity;
 // From the last city to the Anthill...
 for(int i=VisitedCities->Count-1; i>=0; i--)
  {
   mCity = (City*)VisitedCities->Items[i];
   int ind = BackTrail->IndexOf(mCity);
   // If the city has not been visited...
   if(ind==-1) BackTrail->Add(mCity);
    else
      for(int j=ind+1; j<BackTrail->Count; j++)
        BackTrail->Delete(j);
  }

 VisitedCities->Clear();
 delete VisitedCities;

 VisitedCities = BackTrail;

 return true;
}
//---------------------------------------------------------------------------
// Description: Get next city of the trail.
City* Ant::GetNextCity()
{
 if(VisitedCities->Count<1) { return NULL; }

 City* mCity = (City*)VisitedCities->Items[0];
 VisitedCities->Delete(0);

 return mCity;
}
//---------------------------------------------------------------------------
// Interface Methods
//---------------------------------------------------------------------------
void Ant::DrawAnt(TImage* Terrain)
{
 if(IsOnTheRoad())
  {
   City *CurrentCity = Road->GetConection(TargetCity);
   int sgx = (CurrentCity->GetCityPositionX() > TargetCity->GetCityPositionX())?-1:1;
   int sgy = (CurrentCity->GetCityPositionY() > TargetCity->GetCityPositionY())?-1:1;

   int X = CurrentCity->GetCityPositionX() + sgx*Road->GetPositionX(DistanceRemaining);
   int Y = CurrentCity->GetCityPositionY() + sgy*Road->GetPositionY(DistanceRemaining);

   const int Radius = (FoodCollected+1)*2;

   Terrain->Canvas->Pen->Mode =    pmCopy;
   Terrain->Canvas->Pen->Color =   clGreen;
   Terrain->Canvas->Arc(X-Radius, Y-Radius, X+Radius, Y+Radius, X+Radius, Y+Radius, X+Radius, Y+Radius);
  }
}
//---------------------------------------------------------------------------
