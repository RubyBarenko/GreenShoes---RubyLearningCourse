//---------------------------------------------------------------------------

#ifndef MainFormH
#define MainFormH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Dialogs.hpp>
#include <Menus.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class TMainWindow : public TForm
{
__published:	// IDE-managed Components
        TScrollBox *EditorScrollBox;
        TImage *ImageEditor;
        TMainMenu *MainMenu1;
        TMenuItem *FileMenuItem;
        TMenuItem *SaveCivMenuItem;
        TMenuItem *OpenCivMenuItem;
        TMenuItem *N1;
        TMenuItem *CloseMenuItem;
        TOpenDialog *OpenDialog;
        TSaveDialog *SaveDialog;
        TStatusBar *StatusBar;
        TGroupBox *GroupBoxAnt;
        TButton *Restart;
        TBevel *Bevel1;
        TBevel *Bevel2;
        TMenuItem *CivMenuItem;
        TMenuItem *EvoluteMenuItem;
        TMenuItem *RestartMenuItem;
        TButton *ButtonEvolute;
        TScrollBox *ScrollBoxMini;
        TImage *ImagePreview;
        TLabel *LabelEpoch;
        TMenuItem *N2;
        TMenuItem *AboutMenuItem;
        TEdit *EditTurns;
        TLabel *Label1;
        TLabel *Label2;
        TEdit *EditRate;
        TEdit *EditRange;
        TLabel *Label3;
        TLabel *Label4;
        void __fastcall ImageEditorMouseDown(TObject *Sender,
          TMouseButton Button, TShiftState Shift, int X, int Y);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall SaveCivMenuItemClick(TObject *Sender);
        void __fastcall OpenCivMenuItemClick(TObject *Sender);
        void __fastcall CloseMenuItemClick(TObject *Sender);
        void __fastcall ClearMenuItemClick(TObject *Sender);
        void __fastcall RestartMenuItemClick(TObject *Sender);
        void __fastcall ButtonEvoluteClick(TObject *Sender);
        void __fastcall AboutMenuItemClick(TObject *Sender);
private:
        void __fastcall ClearTerrain();	// User declarations
public:		// User declarations
        __fastcall TMainWindow(TComponent* Owner);
        int __fastcall CreateNewNode(int X, int Y);
};
//---------------------------------------------------------------------------
extern PACKAGE TMainWindow *MainWindow;
//---------------------------------------------------------------------------
#endif
