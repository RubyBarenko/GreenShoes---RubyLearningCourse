//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
#include "DAntCity.h"
//---------------------------------------------------------------------------
#include <math.h>   // for the sqrt function
#define CITY_DIM 30 // Size of cities in pixels
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
// Constructors/Destructors
//---------------------------------------------------------------------------
City::City(TShape* newCity)
{
 CityAddress = newCity;
}
//---------------------------------------------------------------------------
City::~City()
{
 delete CityAddress;
}
//---------------------------------------------------------------------------
// Auxiliary Methods
//---------------------------------------------------------------------------
// Description: Returns the distance between this city and the [otherCity]
float City::GetDistance(City* otherCity)
{
 return sqrt( (GetCityPositionX()-otherCity->GetCityPositionX()) *
              (GetCityPositionX()-otherCity->GetCityPositionX())
              +
              (GetCityPositionY()-otherCity->GetCityPositionY()) *
              (GetCityPositionY()-otherCity->GetCityPositionY())
            );
}
//---------------------------------------------------------------------------
// Interface Methods
//---------------------------------------------------------------------------
void City::SetColor(TColor Color)
{
 ((TShape*)CityAddress)->Brush->Color = Color;
}
//---------------------------------------------------------------------------
int City::GetCityPositionX()
{
 return CityAddress->Left + CITY_DIM/2;
}
//---------------------------------------------------------------------------
void City::SetCityPositionX(int p)
{
 CityAddress->Left  = p - CITY_DIM/2;
}
//---------------------------------------------------------------------------
int City::GetCityPositionY()
{
 return CityAddress->Top + CITY_DIM/2;
}
//---------------------------------------------------------------------------
void City::SetCityPositionY(int p)
{
 CityAddress->Top = p - CITY_DIM/2;
}
//---------------------------------------------------------------------------
int City::GetCityName()
{
 return CityAddress->Tag;
}
