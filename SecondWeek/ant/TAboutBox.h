//---------------------------------------------------------------------------

#ifndef TAboutBoxH
#define TAboutBoxH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TAboutBox : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label2;
        TButton *ButtonOK;
        TBevel *Bevel1;
        TMemo *Memo1;
        TLabel *Label1;
        void __fastcall ButtonOKClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TAboutBox(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TAboutBox *AboutBox;
//---------------------------------------------------------------------------
#endif
