//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
#include "MainForm.h"
#include "TAboutBox.h"
//---------------------------------------------------------------------------
#include "DCivilization.h"
//---------------------------------------------------------------------------
#include "DAnt.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TMainWindow *MainWindow;
//---------------------------------------------------------------------------
Civilization *TheCivilization;                              // The ant colony
//---------------------------------------------------------------------------
__fastcall TMainWindow::TMainWindow(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::ImageEditorMouseDown(TObject *Sender,
      TMouseButton Button, TShiftState Shift, int X, int Y)
{
 if(Button == mbLeft)
  {
   CreateNewNode(X,Y);
  }
}
//---------------------------------------------------------------------------
int __fastcall TMainWindow::CreateNewNode(int X, int Y)
{
 TheCivilization->AddCity(X,Y);

 return 1;
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::FormCreate(TObject *Sender)
{
 ClearTerrain();

 TheCivilization = new Civilization(ImageEditor,EditorScrollBox,ImagePreview,LabelEpoch);

 LabelEpoch->Caption = "Turn: -\nPopulation: -\nFood Collected: -";
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::ClearTerrain()
{
 // Clear ImageEditor's bitmap area:
 Graphics::TBitmap *Bitmap;
 Bitmap = new Graphics::TBitmap();
 Bitmap->Width =  ImageEditor->Width;
 Bitmap->Height = ImageEditor->Height;
 ImageEditor->Picture->Graphic = Bitmap;
 delete Bitmap;

 Bitmap = new Graphics::TBitmap();
 Bitmap->Width =  ImagePreview->Width;
 Bitmap->Height = ImagePreview->Height;
 ImagePreview->Picture->Graphic = Bitmap;
 delete Bitmap;
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::SaveCivMenuItemClick(TObject *Sender)
{
 SaveDialog->FileName = "";
 if(SaveDialog->Execute())
  {
   FILE *stream;
   stream = fopen(SaveDialog->FileName.c_str(),"wb");
   TheCivilization->SaveToFile(stream);
   fclose(stream);
  }
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::OpenCivMenuItemClick(TObject *Sender)
{
 OpenDialog->FileName = "";
 if(OpenDialog->Execute())
  {
   FILE *stream;
   stream = fopen(OpenDialog->FileName.c_str(),"rb");
   TheCivilization->LoadFromFile(stream);
   fclose(stream);
   TheCivilization->Rebuild(ImageEditor,1.0);
   TheCivilization->Rebuild(ImagePreview,0.25);
  }
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::CloseMenuItemClick(TObject *Sender)
{
 Close();
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::ClearMenuItemClick(TObject *Sender)
{
 ClearTerrain();
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::RestartMenuItemClick(TObject *Sender)
{
 delete TheCivilization;

 ClearTerrain();

 TheCivilization = new Civilization(ImageEditor,EditorScrollBox,ImagePreview,LabelEpoch);

 LabelEpoch->Caption = "Turn: -\nPopulation: -\nFood Collected: -";
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::ButtonEvoluteClick(TObject *Sender)
{
 TheCivilization->PerformEvolution();
}
//---------------------------------------------------------------------------
void __fastcall TMainWindow::AboutMenuItemClick(TObject *Sender)
{
 AboutBox->ShowModal();
}
//---------------------------------------------------------------------------

