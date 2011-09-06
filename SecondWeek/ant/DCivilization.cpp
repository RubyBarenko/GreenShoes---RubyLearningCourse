//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
#include "DCivilization.h"
//---------------------------------------------------------------------------
#include <values.h>
#include "MainForm.h"
//---------------------------------------------------------------------------
#define TURNS_BEFORE_SELECTION 30
#define MUTATION_PROB random(20)==5    // Probability of 5% to occur mutation
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
// Constructors/Destructors
//---------------------------------------------------------------------------
Civilization::Civilization(TImage *ptrVirtualCiv, TScrollBox *ptrVirtualTerrain, TImage *IPreview, TLabel *LEpoch)
{
 FoodCollected = 0;                       // No food collected at the beginning
 Epoch = 0;                               // Start from turn 0
 TurnsRemaining = TURNS_BEFORE_SELECTION; // Set turn remaining before the Natural Selection occurs

 Cities = new TList();                    // Civilization begins with no City
 Roads = new TList();                     // ... and no routes
 Nest = NULL;
 FoodSourceCity = NULL;
 CityBuildingRoad = NULL;                 // ... and no roads are being built

 DeliveryTime = new TList();


 Ants = new TList();                      // Create some ants at random...
 LoadAnts();

 Restart();                               // Prepare the environment for simulation

 VirtualCiv = ptrVirtualCiv;
 VirtualTerrain = ptrVirtualTerrain;
 Preview = IPreview;
 LabelEpoch = LEpoch;
}
//---------------------------------------------------------------------------
Civilization::~Civilization()
{
 for(int i=0; i<Roads->Count; i++)
  {
   delete (Route*)Roads->Items[i];        // Free memory stored for routes...
  }
 for(int i=0; i<Cities->Count; i++)
  {
   delete (City*)Cities->Items[i];        // ... and cities
  }
}
//---------------------------------------------------------------------------
// Methods
//---------------------------------------------------------------------------
// Description: This method controls the natural selection.
//              Steps:
//              Select the two best explorers and workers
//              Create offspring of the successful agents using crossover
//              Elimite lost agents from the population
//              Introduce a completely random individual to the population (migration)
void Civilization::NaturalSelection()
{
 TurnsRemaining = TURNS_BEFORE_SELECTION;

 // Selecting successful individuals:
 // The best two workers are those with the
 Ant *mExplorer, *fExplorer, *mWorker, *fWorker;

 mExplorer = fExplorer = mWorker = fWorker = (Ant*)Ants->Items[0];

 for(int i=1; i<Ants->Count; i++)
  {
   Ant* thisAnt = (Ant*)Ants->Items[i];
   // Selecting the two best explorers...
   if(thisAnt->LostCounter < mExplorer->LostCounter)
    {
     fExplorer = mExplorer;
     mExplorer = thisAnt;
    }
     else if(thisAnt->LostCounter < fExplorer->LostCounter)
           {
            fExplorer = thisAnt;
           }
   // Selecting the two best workers...
   if(thisAnt->GetFoodCollected() > mWorker->GetFoodCollected())
    {
     fWorker = mWorker;
     mWorker = thisAnt;
    }
     else if(thisAnt->GetFoodCollected() > fWorker->GetFoodCollected())
           {
            fWorker = thisAnt;
           }
  }

  // Crossover... new agent is offspring of the best explorers
  Ant *newAnt = new Ant(mExplorer,fExplorer);
  // Mutation may occur...
  if ( MUTATION_PROB ) newAnt->Mutation();
  // Add agent to the population...
  newAnt->TargetCity = Nest;
  newAnt->RememberCity();
  Ants->Add(newAnt);

  // Crossover... new agent is offspring of the best workers
  newAnt = new Ant(mWorker,fWorker);
  // Mutation may occur...
  if ( MUTATION_PROB ) newAnt->Mutation();
  // Add agent to the population...
  newAnt->TargetCity = Nest;
  newAnt->RememberCity();
  Ants->Add(newAnt);

 // Eliminating lost ants from the population...
 int i=0;
 while(i<Ants->Count)
   {
     // Select lost Ants...
     Ant* thisAnt = (Ant*)Ants->Items[i];
     if(thisAnt->LostCounter>5 )
      {
       // ... and kill them!
       Ants->Remove(thisAnt);
       delete thisAnt;
      }
       else i++;
    }

 // Migration: completely new individual
 newAnt = new Ant();
 newAnt->TargetCity = Nest;
 newAnt->RememberCity();
 Ants->Add(newAnt);
}
//---------------------------------------------------------------------------
// Description: This method runs the simulation by calling the 'NextTurn' method,
//              checking the stop criteria and updating the main window interface
void Civilization::PerformEvolution()
{
 Restart();

 for(int i=0; i< MainWindow->EditTurns->Text.ToInt(); i++)
  {
   NextTurn();
   DrawPreviewBoard();                // highlight the road with more pheromone
   Application->ProcessMessages();

   if(FoodRateReached(MainWindow->EditRange->Text.ToInt(),MainWindow->EditRate->Text.ToInt()))  break;
  }

 FindMainRoads(50,VirtualCiv,10,1.0);

 Application->ProcessMessages();
}
//---------------------------------------------------------------------------
// Description: Evaluates the next move of all agents in the population.
//
//              For all ants in the colony...
//              - if traveling, walk one more step
//              - if in the food source not carrying food, pick food
//              - if in the nest carrying food, leave food
//              - else (in another city), choose next route
int Civilization::NextTurn()
{

 TurnsRemaining--;
 if(TurnsRemaining==0)   // If it's time to evolve the population...
  {
   NaturalSelection();   // ...perform Natural Selection
  }

 Epoch++;                // Update next turn number

 // For all ants in the colony...
 for(int i=0; i<Ants->Count; i++)
  {
   // Select an Ant...
   Ant* thisAnt = (Ant*)Ants->Items[i];
   // If it's traveling, walk a little more...
   if(thisAnt->IsOnTheRoad()) thisAnt->Walk();
    else { //... else, if the ant is on a city, ...
          // See if the ant reached the Civilization's Food Souce...
          if( (thisAnt->TargetCity==FoodSourceCity) && !thisAnt->CarryingFood() )
           {
            thisAnt->PickFood();
            thisAnt->PrepareTrail();
           }
          else
          // ... or in the Nest carrying food, ...
          if( (thisAnt->TargetCity==Nest) && thisAnt->CarryingFood() )
           {
            thisAnt->LeaveFood();        // ... leave food
            FoodCollected++;             // ... add one more food to the colony

            thisAnt->RememberCity();     // ... start again ...
            int *ThisYear = new int;
            *ThisYear = Epoch;
            DeliveryTime->Add(ThisYear);
           }
          else
          // if the ant is carring food, follow its own trail back to the Anthill
          if( thisAnt->CarryingFood() )
           {
            City *CurrentCity = thisAnt->TargetCity;
            City *BackCity = thisAnt->GetNextCity();
            for(int j=0; j<Roads->Count; j++)
             {
              Route* thisRoad = (Route*)Roads->Items[j];
              // if the road has a conection with the current city...
              City* NextCity = thisRoad->GetConection(CurrentCity);
              if(NextCity!=NULL && NextCity==BackCity)
               {
                thisAnt->SetDistance((int)NextCity->GetDistance(CurrentCity));
                thisAnt->TargetCity = NextCity;
                thisAnt->Road = thisRoad;
                if(thisAnt->Road!=NULL) thisAnt->PutPheromone();
                break;
               }
             }
           }
          else
           {
            // ... or select a new way to go.
            // Search all cities that have a road to this one
            float CurrentLevel = -MaxInt;
            // Save the TargetCity for comparisons...
            City *CurrentCity = thisAnt->TargetCity;
            for(int j=0; j<Roads->Count; j++)
             {
              Route* thisRoad = (Route*)Roads->Items[j];
              // if the road has a conection with the current city...
              City* NextCity = thisRoad->GetConection(CurrentCity);
              // ... test the Will Level
              if(NextCity!=NULL)
               {
                float Level = thisAnt->GetTendency(thisRoad->GetPheromone());
                if(Level > CurrentLevel)
                 {
                  CurrentLevel = Level;
                  // Set the distance to the next target city
                  thisAnt->SetDistance((int)NextCity->GetDistance(CurrentCity));
                  // Select a new Target City and Route:
                  thisAnt->TargetCity = NextCity;
                  thisAnt->Road = thisRoad;
                 }
               }
              thisRoad->UpdateStatusInfo();
             } // end of Road Search

            if(thisAnt->Road!=NULL) thisAnt->PutPheromone();
            // After a target city was selected, remember it...
            thisAnt->RememberCity();
           } // end of new path selection
         }
   // Draw Ants...
   thisAnt->DrawAnt(VirtualCiv);
  } // end of Ants Movements

 // Pheromone Evaporation...
 for(int j=0; j<Roads->Count; j++)
  {
   ((Route*)Roads->Items[j])->EvaporatePheromone();
  }

 // Show Current Status on the main window
 LabelEpoch->Caption = "Turn: " + IntToStr(Epoch) + '\n' + "Population: " + IntToStr(Ants->Count) + '\n' +
                       "Food Collected: " + IntToStr(FoodCollected);

 return Epoch;
}
//---------------------------------------------------------------------------
// Auxiliary Methods
//---------------------------------------------------------------------------
// Description: Create the inicial population of agents at random
void Civilization::LoadAnts()
{
 randomize();

 int AntCount = random(9) + 1;  // create a random number of agents (at least one)

 for(int j=0; j<AntCount; j++)  Ants->Add(new Ant());

}
//---------------------------------------------------------------------------
// Description: Returns a pointer to a specified ant in the population
Ant* Civilization::GetAnt(int Index)
{
 return (Ant*)Ants->Items[Index];
}
//---------------------------------------------------------------------------
// Description: Set inicial condition to all agents in the population and to
//              the environment
void Civilization::Restart()
{
 DeliveryTime->Clear();

 for(int j=0; j<Ants->Count; j++)
 {
  // Set the Origin of the all ants in the Nest
  ((Ant*)Ants->Items[j])->TargetCity = Nest;
  ((Ant*)Ants->Items[j])->RememberCity();
  ((Ant*)Ants->Items[j])->SetDistance(0);
 }

 ClearTrails();
}
//---------------------------------------------------------------------------
// Description: Reset the pheromone intensity on all trails
//              Set inicial condition to all routes in the environment
void Civilization::ClearTrails()
{
 for(int i=0; i<Roads->Count; i++)
  {
   ((Route*)Roads->Items[i])->SetPheroTrail(30);
  }
}
//---------------------------------------------------------------------------
// Description: Add a new city to the environment at the position X,Y in pixels
int Civilization::AddCity(int X, int Y)
{
 const int NodeDim = 30;
 TShape* NewNode = new TShape(VirtualCiv);  // Create the AntCity interface on the form

 NewNode->OnMouseDown = CityMouseDown;      // Assign the OnClick Event
 City *newCity = new City(NewNode);
 NewNode->Tag = Cities->Add(newCity);       // Add the new city to the environment


 NewNode->Shape  = stCircle;                // Interface settings: size, color, ...
 NewNode->Width  = NodeDim;
 NewNode->Height = NodeDim;
 NewNode->Top  = Y - NodeDim/2;
 NewNode->Left = X - NodeDim/2;
 NewNode->Brush->Color = clTeal;
 NewNode->Visible = true;
 NewNode->Parent = VirtualTerrain;
 TLabel *pCityName  = new TLabel(NewNode);  // Create a label to show the city's name
 pCityName->Caption = NewNode->Tag;
 pCityName->Visible = true;
 pCityName->Parent  = VirtualTerrain;
 pCityName->Top  = Y;
 pCityName->Left = X;

 return 1;
}
//---------------------------------------------------------------------------
// Description: Returns the pointer to a specific city of the environment
City *Civilization::GetCityAddress(int Index)
{
 return (City*)Cities->Items[Index];
}
//---------------------------------------------------------------------------
// Description: Build a route connecting the last two cities selected with
//              [Ctrl] + [LeftClick]
int Civilization::BuildRoad(City *Dest)
{
 if(CityBuildingRoad != Dest)
  {
   Roads->Add( new Route(CityBuildingRoad,Dest,VirtualTerrain) );
   CityBuildingRoad = NULL;
  }

 Rebuild(VirtualCiv,1.0);
 return 1;
}
//---------------------------------------------------------------------------
// Description: Verifies if a certain amount of food was collected in a given
//              range of turns
bool Civilization::FoodRateReached(int Range, int Target)
{
 int StartYear = Epoch - Range;
 int FCollected = 0;

 for(int i=0; i<DeliveryTime->Count; i++)
  {
   if( *((int*)DeliveryTime->Items[i]) >= StartYear ) FCollected++;
  }

 if(FCollected>=Target) return true;

 return false;
}

//---------------------------------------------------------------------------
// Interface Methods
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// File Map:
// int: index of the Anthill
// int: index of the FoodSourceCity
// int: number of cities
// ....
// int: X coordinate of the city
// int: Y coordinate of the city
// ....
// int: number of roads
// ....
// int: index of city A (begin of the road)
// int: index of city B (end   of the road)
// ....
// Description: Load an environment from a file
void Civilization::LoadFromFile(FILE *stream)
{
 int AnthillIndex = -1;
 fread(&AnthillIndex,sizeof(int),1,stream);

 int FoodSourceIndex = -1;
 fread(&FoodSourceIndex,sizeof(int),1,stream);

 int CitiesCount = -1;
 fread(&CitiesCount,sizeof(int),1,stream);

 int A = 0;
 int B = 0;
 for(int i=0; i<CitiesCount; i++)
  {
   fread(&A,sizeof(int),1,stream);
   fread(&B,sizeof(int),1,stream);
   AddCity(A,B);
   // if the current city being loaded is the Nest...
   if(i==AnthillIndex)
    {
     Nest = ((City*)Cities->Items[i]);
     Nest->SetColor(clBlue);
    }
   // if the current city being loaded is the Food Source...
   if(i==FoodSourceIndex)
    {
     FoodSourceCity = ((City*)Cities->Items[i]);
     FoodSourceCity->SetColor(clRed);
    }
  }

   int RoadsCount = -1;
   fread(&RoadsCount,sizeof(int),1,stream);

   for(int i=0; i<RoadsCount; i++)
    {
     fread(&A,sizeof(int),1,stream);
     fread(&B,sizeof(int),1,stream);
     CityBuildingRoad = (City*)Cities->Items[A];
     BuildRoad((City*)Cities->Items[B]);
    }
}
//---------------------------------------------------------------------------
void Civilization::SaveToFile(FILE *stream)
{
 int n = Nest->GetCityName();
 fwrite(&n,sizeof(int),1,stream);
 n = FoodSourceCity->GetCityName();
 fwrite(&n,sizeof(int),1,stream);
 n = Cities->Count;
 fwrite(&n,sizeof(int),1,stream);
 City *nCity;
 for(int i=0; i<Cities->Count; i++)
  {
   nCity = (City*)Cities->Items[i];
   n = nCity->GetCityPositionX();
   fwrite(&n,sizeof(int),1,stream);
   n = nCity->GetCityPositionY();
   fwrite(&n,sizeof(int),1,stream);
  }
 n = Roads->Count;
 fwrite(&n,sizeof(int),1,stream);
 Route *nRoad;
 for(int i=0; i<Roads->Count; i++)
  {
   nRoad = (Route*)Roads->Items[i];

   n = nRoad->GetCityName(1);
   fwrite(&n,sizeof(int),1,stream);
   n = nRoad->GetCityName(2);
   fwrite(&n,sizeof(int),1,stream);
  }
}
//---------------------------------------------------------------------------
// Description: Redraw the environment in a TImage object with a given [Scale]
int Civilization::Rebuild(TImage *ImageBox, const float Scale)
{
 // Clear the virtual terrain
 Graphics::TBitmap *Bitmap;
 Bitmap = new Graphics::TBitmap();
 Bitmap->Width =  ImageBox->Width;
 Bitmap->Height = ImageBox->Height;
 ImageBox->Picture->Graphic = Bitmap;
 delete Bitmap;

 // Draw all the roads
 for(int i=0; i<Roads->Count; i++)
  {
   ((Route*)Roads->Items[i])->DrawRoad(ImageBox,clPurple,Scale);
  }

 return 1;
}
//---------------------------------------------------------------------------
// Description: This method update the preview panel drawing the road with
//              the heigher intensity of pheromone in red
bool __fastcall Civilization::DrawPreviewBoard()
{
 // Scale factor
 const float Scale  = 0.25;
 const int   Radius = 5;
 City *mCity = NULL;

 for(int i=0; i<Roads->Count; i++)
  {
   ((Route*)Roads->Items[i])->DrawRoad(Preview,clBlue,Scale);
  }

 FindMainRoads(25,Preview,3,Scale);

 for(int i=0; i<Cities->Count; i++)
  {
   mCity = (City*)Cities->Items[i];

   int X = Scale*mCity->GetCityPositionX();
   int Y = Scale*mCity->GetCityPositionY() + 2;

   Preview->Canvas->Pen->Color =   clGreen;
   Preview->Canvas->Brush->Color =   clGreen;
   Preview->Canvas->Ellipse(X-Radius, Y-Radius, X+Radius, Y+Radius);//, X+Radius, Y+Radius, X+Radius, Y+Radius);
   Preview->Canvas->Brush->Color =   clWhite;
  }

 return true;
}
//---------------------------------------------------------------------------
// Description: Highlights the routes with the heigher pheromone intesity
//              starting from the Nest. If the Food source is not reached
//              after a given number of tries, stop the search and draw the
//              result.
bool __fastcall Civilization::FindMainRoads(int Ntries, TImage *ImageBox, const int RWidth, const float Scale)
{
 // Start from the Anthill...
 City *CurrentCity = Nest;
 TList *MainRoads = new TList();

 while(CurrentCity!=FoodSourceCity && Ntries>0)
  {

     int PheroLevel = -MAXINT;
     Route *CurrentRoad = NULL;
     City* NextCity;
     Route* thisRoad;
     // the following loop select the best road acording to the pheromone level
     for(int j=0; j<Roads->Count; j++)
      {
       thisRoad = (Route*)Roads->Items[j];
       // if the road has a conection with the current city...
       NextCity = thisRoad->GetConection(CurrentCity);

       // Test the highest Pheromone level among the possible roads...

       // if 'thisRoad' was not used before...
       if(NextCity!=NULL && MainRoads->IndexOf(thisRoad)==-1)
        {
         if(thisRoad->GetPheromone() > PheroLevel)
          {
           CurrentRoad = thisRoad;
           PheroLevel = thisRoad->GetPheromone();
          }
        }
      }
     // Go to next city using the selected road...
     if(CurrentCity!=NULL && CurrentRoad!=NULL)
      {
       CurrentCity = CurrentRoad->GetConection(CurrentCity);
       MainRoads->Add(CurrentRoad);
      }
    Ntries--;
  }

 // Draw the MainRoad
 Rebuild(ImageBox,Scale);
  // Draw all the roads
 for(int i=0; i<MainRoads->Count; i++)
  {
   ImageBox->Canvas->Pen->Width = RWidth;
   ((Route*)MainRoads->Items[i])->DrawRoad(ImageBox,clRed,Scale);
   ImageBox->Canvas->Pen->Width = 1;
  }

 return (Ntries>0)?true:false;
}
//---------------------------------------------------------------------------
// Description: Handle mouse clicks on the cities.
//              [Ctrl] + [LeftClick]: build route
//              [RightClick]: set a city as the Nest
//              [Ctrl] + [RightClick]: set a city as the Food Source
void __fastcall Civilization::CityMouseDown(TObject *Sender,
      TMouseButton Button, TShiftState Shift, int X, int Y)
{
 if(Button == mbLeft)
  {
     // If Ctrl is down, we are creating a road...
     if(Shift.Contains(ssCtrl) && !Shift.Contains(ssShift))
      if (CityBuildingRoad!=NULL)
       {
        BuildRoad( GetCityAddress( ((TShape*)Sender)->Tag ) );
       }
        else  CityBuildingRoad = GetCityAddress( ((TShape*)Sender)->Tag );
  }
 else if(Button == mbRight)
       {
        if(Shift.Contains(ssCtrl))
         {
          FoodSourceCity = GetCityAddress( ((TShape*)Sender)->Tag );
          ((TShape*)Sender)->Brush->Color = clRed;
         }
        else
          {
           Nest = GetCityAddress( ((TShape*)Sender)->Tag );
           ((TShape*)Sender)->Brush->Color = clBlue;
          }
       }
}
//---------------------------------------------------------------------------
