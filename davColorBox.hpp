// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Davcolorbox.pas' rev: 11.00

#ifndef DavcolorboxHPP
#define DavcolorboxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Davcolorbox
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TcolorDepth { cb8, cb64, cb512 };
#pragma option pop

#pragma option push -b-
enum Tcolorboxdir { cbHor, cbVert };
#pragma option pop

typedef void __fastcall (__closure *TColorSelect)(System::TObject* sender, int color);

#pragma pack(push,4)
struct TColorSquare
{
	
public:
	int x1;
	int y1;
	int color;
} ;
#pragma pack(pop)

class DELPHICLASS TdavColorBox;
class PASCALIMPLEMENTATION TdavColorBox : public Controls::TGraphicControl 
{
	typedef Controls::TGraphicControl inherited;
	
private:
	TcolorDepth FColorDepth;
	Tcolorboxdir FDirection;
	int FColor;
	TColorSelect FOnSelect;
	int Fx;
	int Fy;
	Byte FBorderwidth;
	int FBorderlight;
	int FBorderdark;
	Byte FCsquare;
	void __fastcall setDirection(Tcolorboxdir cbDir);
	void __fastcall setColorDepth(TcolorDepth cbDepth);
	void __fastcall setDimensions(void);
	TColorSquare __fastcall number2color(Word w);
	
protected:
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall MouseUp(Controls::TMouseButton Button, Classes::TShiftState Shift, int X, int Y);
	void __fastcall setSquare(Byte edge);
	void __fastcall setBorderwidth(Byte w);
	void __fastcall setBorderlight(int c);
	void __fastcall setBorderdark(int c);
	void __fastcall select(System::TObject* sender, int selcolor);
	
public:
	__fastcall virtual TdavColorBox(Classes::TComponent* AOwner);
	
__published:
	__property TColorSelect OnSelect = {read=FOnSelect, write=FOnSelect};
	__property Tcolorboxdir direction = {read=FDirection, write=setDirection, default=0};
	__property TcolorDepth colordepth = {read=FColorDepth, write=setColorDepth, default=2};
	__property Byte Csquare = {read=FCsquare, write=setSquare, default=10};
	__property Byte border = {read=FBorderwidth, write=setBorderwidth, default=2};
	__property int borderlight = {read=FBorderlight, write=setBorderlight, default=16777215};
	__property int borderdark = {read=FBorderdark, write=setBorderdark, default=0};
	__property visible  = {default=1};
	__property enabled  = {default=1};
public:
	#pragma option push -w-inl
	/* TGraphicControl.Destroy */ inline __fastcall virtual ~TdavColorBox(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Davcolorbox */
using namespace Davcolorbox;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Davcolorbox
