//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "TAboutBox.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TAboutBox *AboutBox;
//---------------------------------------------------------------------------
__fastcall TAboutBox::TAboutBox(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TAboutBox::ButtonOKClick(TObject *Sender)
{
 Close();        
}
//---------------------------------------------------------------------------
