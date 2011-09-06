//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
#include "DAntRoad.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
// Constructors/Destructors
//---------------------------------------------------------------------------
Route::Route(City *Orig, City *Dest,TScrollBox *Terrain)
{
 FirstCity  = Orig;
 SecondCity = Dest;

 Length = FirstCity->GetDistance(SecondCity);   // Calculate the length of the route

 Pheromone = 30;                                // Pheromore level at the beginning

 // Create and position a label on the window
 Info = new TLabel(Terrain);
 int sgx = (Orig->GetCityPositionX() > Dest->GetCityPositionX())?-1:1;
 int sgy = (Orig->GetCityPositionY() > Dest->GetCityPositionY())?-1:1;
 int X = Orig->GetCityPositionX() + sgx*GetPositionX(GetLength()/2);
 int Y = Orig->GetCityPositionY() + sgy*GetPositionY(GetLength()/2);
 Info->Left = X;
 Info->Top  = Y;
 Info->Parent = Terrain;

 UpdateStatusInfo();
}
//---------------------------------------------------------------------------
Route::~Route()
{
 delete Info;          // Free the label memory
}
//---------------------------------------------------------------------------
// Auxiliary Methods
//---------------------------------------------------------------------------
// Description: Returns the length of the route
float Route::GetLength()
{
 return Length;
}
//---------------------------------------------------------------------------
// Description: Calculates the X coordinate of a point along the road based on
//              the % remaining to cross it.
int Route::GetPositionX(int Remaining)
{
 float PercentDone = 1.0 - Remaining/GetLength();

 return (int)(PercentDone * abs(FirstCity->GetCityPositionX()-SecondCity->GetCityPositionX()));
}
//---------------------------------------------------------------------------
// Description: Calculates the Y coordinate of a point along the road based on
//              the % remaining to cross it.
int Route::GetPositionY(int Remaining)
{
 float PercentDone = 1.0 - Remaining/GetLength();

 return (int)(PercentDone * abs(FirstCity->GetCityPositionY()-SecondCity->GetCityPositionY()));
}
//---------------------------------------------------------------------------
// Description: Returns the index of one of the cities in the Civilization's list
int Route::GetCityName(int N)
{
 if(N==1) return FirstCity->GetCityName();
 if(N==2) return SecondCity->GetCityName();

 return -1;
}
//---------------------------------------------------------------------------
// Description: Returns a pointer to one of the cities liked by this road to
//              the [CurrentCity]. Return NULL if there is no connection.
City* Route::GetConection(City* CurrentCity)
{
 if(CurrentCity==FirstCity)  return SecondCity;
 if(CurrentCity==SecondCity) return FirstCity;

 return NULL;
}
//---------------------------------------------------------------------------
// Description: Set the pheromone intensity. Used just to restart the simulation.
void Route::SetPheroTrail(int v)
{
 Pheromone = v;
}
//---------------------------------------------------------------------------
// Interface Methods
//---------------------------------------------------------------------------
void Route::DrawRoad(TImage* Terrain, TColor thColor, const float Scale)
{
 Terrain->Canvas->Pen->Color = thColor;
 Terrain->Canvas->MoveTo(Scale*FirstCity->GetCityPositionX(),
                         Scale*FirstCity->GetCityPositionY());
 Terrain->Canvas->LineTo(Scale*SecondCity->GetCityPositionX(),
                         Scale*SecondCity->GetCityPositionY());
}
//---------------------------------------------------------------------------
void Route::UpdateStatusInfo()
{
 Info->Caption = IntToStr(Pheromone) + " | " + IntToStr((int)GetLength());
}
//---------------------------------------------------------------------------
