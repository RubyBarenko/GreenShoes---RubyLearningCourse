//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("AntSim.res");
USEFORM("MainForm.cpp", MainWindow);
USEUNIT("DAntCity.cpp");
USEUNIT("DAntRoad.cpp");
USEUNIT("DCivilization.cpp");
USEUNIT("DAnt.cpp");
USEFORM("TAboutBox.cpp", AboutBox);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->Title = "Ant Colony Simulation";
                 Application->CreateForm(__classid(TMainWindow), &MainWindow);
                 Application->CreateForm(__classid(TAboutBox), &AboutBox);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
