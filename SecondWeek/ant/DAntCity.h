//---------------------------------------------------------------------------
#ifndef DAntCityH
#define DAntCityH
//---------------------------------------------------------------------------
class City
{
 public:
 TShape *CityAddress;              // Pointer to a TShape object: the interface of the city

 City(TShape*);                    // Default constructor
 ~City();                          // Default destructor

 // Auxiliary Methods:
 float GetDistance(City*);         // Get the distance from this city to another

 // Interface Methods:
 int GetCityPositionX();           // Get left distance in pixels
 int GetCityPositionY();           // Get top distance in pixels
 void SetCityPositionX(int p);     // Set left distance in pixels
 void SetCityPositionY(int p);     // Set top distance in pixels
 void SetColor(TColor Color);      // Set color of the TShape Object
 int GetCityName();                // Returns the index of the city stored in the 'Tag' propertie
};
//---------------------------------------------------------------------------
#endif
 