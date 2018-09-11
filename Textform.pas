unit Textform;

interface

uses
  Windows, WinApi.Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Vcl.Forms,
  Dialogs, VirtualTrees, Grids, StdCtrls, Vcl.Menus, Vcl.ExtCtrls, AlfabetHelp, ShellApi, ChooseDir,
  System.UITypes;

type
  TForm2 = class(TForm)
    grid: TStringGrid;
    Panel1: TPanel;
    GoTranslate: TButton;
    GoWord: TButton;
    GoLine: TButton;
    MainMenu1: TMainMenu;
    Alfabet1: TMenuItem;
    Show1: TMenuItem;
    LookupList: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Show1Click(Sender: TObject);   // onmouseup event of editor
    function  ConvertToLatinAlf( greek: String ): String;
	  function  ConvertToGreekAlf( latin: String ): String;
    procedure GoTranslateClick(Sender: TObject);
    procedure LookupListKeyPress(Sender: TObject; var Key: Char);
    procedure GoWordClick(Sender: TObject);
    procedure GoLineClick(Sender: TObject);
    procedure gridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure gridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure gridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    ConvOK: boolean; // global output for conversion routines
  public
    LastPos: integer;
    LastText: String;
    SelectionText: String;
    GridColors: array of array of TColor;
   function searchtext( SearchText:String;
    	StartLine: integer=1; SearchUp: Boolean=True ): integer;
  end;
type
  TGridCracker = class(TStringGrid);
const
  GRalfabet = 'αβγδεζηθικλμνξοπρστυφχψωΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ';
  alfconvert = 'abgdezhqiklmncoprstufxyw';
  dicturl1 = 'http://www.perseus.tufts.edu/hopper/resolveform?redirect=false&lang=greek&type=begin&formentry=1&doc=Perseus%253Atext%253A1999.04.0073&layout=&lookup=';
  dicturl2a = 'http://www.perseus.tufts.edu/hopper/morph?l=';
  dicturl2b = '&la=greek';
  url1 = 'http://www.perseus.tufts.edu/hopper/text.jsp?doc=Perseus%3Atext%3A1999.01.0133%3Abook%3D';
  url2 = '%3Acard%3D';
  transl1 = 'http://www.perseus.tufts.edu/hopper/text?doc=Hom.%20Il.%20'; // + booknr.linenr + transl2
  transl2 = '&lang=original';

var
  Form2: TForm2;

implementation

uses treeview;

{$R *.dfm}

procedure TForm2.LookupListKeyPress(Sender: TObject; var Key: Char);
var
  s, temp: String;
  i: integer;
begin
  s := ConvertToGreekAlf( String( Key ));
  s := WideLowerCase( s );
  if( LookupList.SelLength > 0 ) then LookupList.SelText := s
  else begin
  	i := LookupList.SelStart+1;
  	temp := LookupList.Text;
  	insert( s, temp, i );
  	LookupList.Text := temp;
    LookupList.SelStart := i;
  end;
  Key := #0;
end;

procedure TForm2.FormCreate(Sender: TObject);
var i: integer;
begin
  grid.RowCount := 16000;
  Font := Form1.Font;
  Font.Size := Form1.Font.Size;
  //grid.Cols[ 2 ].LoadFromFile('iliad-extended-greek.txt', TEncoding.UTF8); (*hier*)
  grid.Canvas.Font.Size := Font.Size;
  grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsBold];
  if Form1.autoload.State = cbChecked then
    Form1.loadxmlbtnClick(nil);
  //TGridCracker(grid).InplaceEditor.OnMouseUp := gridMouseUp; //doesn't work


  if( FileExists(ChooseDir.HomeDir + '/lookup.list')) then
  	LookupList.Items.LoadFromFile(ChooseDir.HomeDir + '/lookup.list');

  Setlength( GridColors, 2, 16000 );
  grid.Color := Form1.DefaultBG;
  grid.Font.Color := Form1.DefaultFG;
  for i := 0 to 15999 do begin
    GridColors[ 0, i ] := Form1.DefaultBG;
    GridColors[ 1, i ] := Form1.DefaultFG;
  end;
end;

procedure TForm2.FormResize(Sender: TObject);
var
  h, w, wb: integer;
begin
  Top := Form1.Top;
  Height := Form1.Height;
  w := Screen.Width - (Form1.Left + Form1.Width + 10);
  if w < 400 then begin
    Width := 400;
    tile;
  end
  else begin
  Width := w;
  Left := Screen.Width - (w+5);
  end;

  grid.ColWidths[ 0 ] := 48;
  grid.ColWidths[ 1 ] := (ClientWidth - 72);
  //grid.ColWidths[ 2 ] := (ClientWidth - 72) div 2;
  Font.Size := Trunc( Form1.SpinEdit1.Value );
  grid.Font.Size := Font.Size;
  grid.Canvas.Font.Size := Font.Size;
  h := -Font.Height + 8;
  grid.DefaultRowHeight :=  h;
  h := h + 4;
  LookupList.Height := h;
  GoWord.Height := h;
  GoLine.Height := h;
  GoTranslate.Height := h;
  grid.Top := h + 1;
  LookupList.Width := Form2.ClientWidth div 2;
  wb := (Form2.ClientWidth - LookupList.Width) div 3;
  GoWord.Width := wb; GoWord.Left := LookupList.Width;
  GoLine.Width := wb; GoLine.Left := GoWord.Left + wb;
  GoTranslate.Width := wb; GoTranslate.Left := GoLine.Left + wb;
  grid.Repaint;
  Refresh;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  if not (Form1.WindowState=wsMaximized) then FormResize(nil);
end;

procedure TForm2.GoTranslateClick(Sender: TObject);
var
  s, letter: String;
  i: integer;
begin
  s := grid.Cells[ 0, grid.Row ];
  letter := s[ 1 ];
  i := Pos( letter, GRalfabet );
  if i > 24 then i := i - 24;
  s := transl1 + IntToStr( i ) + '.' + MidStr( s, 2, 3 ) + transl2;
  ShellExecute(Form2.Handle, 'open', PWideChar( s ), nil, nil, SW_SHOWNORMAL)
end;

procedure TForm2.GoLineClick(Sender: TObject);
var
  s, letter: String;
  i: integer;
begin
  s := grid.Cells[ 0, grid.Row ];
  letter := s[ 1 ];
  i := Pos( letter, GRalfabet );
  if i > 24 then i := i - 24;
  s := url1 + String( IntToStr( i )) + url2 + MidStr( s, 2, 3 );
  ShellExecute(Form2.Handle, 'open', PWideChar( s ), nil, nil, SW_SHOWNORMAL)
end;

procedure TForm2.GoWordClick(Sender: TObject);
var
  s: String;
  greek: String;
begin
  greek := LookupList.Text;
  s := ConvertToLatinAlf( greek );
  if( (ConvOK = true) and (LookupList.Items.IndexOf( greek ) = -1) ) then
  	LookupList.Items.Insert( 0, greek );
  if( LookupList.Items.Count > 24 ) then LookupList.Items.Delete( 24 );
  s := dicturl2a + s + dicturl2b;
  ShellExecute(Form2.Handle, 'open', PWideChar( s ), nil, nil, SW_SHOWNORMAL)
end;

function  TForm2.ConvertToLatinAlf( greek: String ): String;
var
  i, len, p: integer;
  c: char;
  temp: String;
begin
  len := Length( greek );
  ConvOK := true;
  for i := 1 to len do begin
  	c := greek[ i ];
    p := Pos( c, GRalfabet );
    if p > 24 then p := p - 24;
    if( p <> 0 ) then temp := temp + alfconvert[ p ]
    else begin
      ShowMessage('illegal character: ' + c);
  	  ConvOK := false;
      //exit;
    end;
  end;
  Result := temp;
end;

function  TForm2.ConvertToGreekAlf( latin: String ): String;
var
  i, len, p: integer;
  c: char;
  temp: String;
begin
  len := Length( latin );
  ConvOK := true;
  for i := 1 to len do begin
  	c := LowerCase( latin[ i ] )[ 1 ];
    p := Pos( c, alfconvert );
    if( p <> 0 ) then temp := temp + GRalfabet[ p ]
    else begin
      ShowMessage('illegal character: ' + c);
  	  ConvOK := false;
      //exit;
    end;
  end;
  Result := temp;
end;

procedure TForm2.gridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
  if ACol = 0 then
  begin
    grid.Canvas.Brush.Color := GridColors[0, ARow];  //bg
    grid.Canvas.Font.Color := GridColors[1, ARow];   //fg
  end
  else
  begin
    if (gdSelected in State) or (gdFocused in State) then grid.Canvas.Brush.Color := $FFC0A0
    else grid.Canvas.Brush.Color := Form1.DefaultBG;  //bg
    grid.Canvas.Font.Color := Form1.DefaultFG;   //fg
  end;
  grid.Canvas.FillRect(Rect);
  grid.Canvas.TextRect(Rect, Rect.Left, Rect.Top, grid.Cells[ACol, ARow]);
end;

procedure TForm2.gridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
i: integer;
s: string;
begin
  if ssCtrl in Shift then begin
    if Key = VK_DOWN then begin
      searchtext( LastText, LastPos+1, True );
      Key := 0;
    end
    else if Key = VK_UP then begin
      searchtext( LastText, LastPos-1, False );
      Key := 0;
    end;
  end;
  if key = VK_F11 then begin
    with TGridCracker(grid) do begin
      i :=  InplaceEditor.SelLength;
      s :=  InplaceEditor.Text;
      if( (i > 0) and ( i <> Length(s)  ) ) then
        LookupList.Text := InplaceEditor.SelText;
    end;
  end;
end;

procedure TForm2.gridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
i: integer;
s: string;
begin
    with TGridCracker(grid) do begin
      i :=  InplaceEditor.SelLength;
      s :=  InplaceEditor.Text;
      if( (i > 0) and ( i <> Length(s)  ) ) then
        LookupList.Text := InplaceEditor.SelText;
    end;
end;

procedure TForm2.gridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ACol = 0 then CanSelect := False
  else grid.EditorMode := true;
end;

function TForm2.searchtext( SearchText:String; StartLine: integer=1;
		SearchUp: Boolean=True ): integer;
var
  i, position: integer;
  found: Boolean;
begin
  grid.SetFocus;
  found := False;

  if SearchUp then begin
    for i := StartLine to grid.RowCount - 1 do begin
      position := Pos( WideLowerCase(SearchText), //must be widelowercase ?!
      			WideLowerCase(grid.Cells[ 1, i ]));
      if position > 0 then begin found := True; Break; end;
    end;
  end
  else begin
    for i := StartLine downto 1 do begin
      position := Pos( WideLowerCase(SearchText),
      			WideLowerCase(grid.Cells[ 1, i ] ));
      if position > 0 then begin found := True; Break; end;
    end;
  end;
  if found then begin
    LastPos := i;
    LastText := SearchText;
  end
  else i := StartLine;
  if i > 0 then grid.TopRow := i - 1
  else grid.TopRow := 0;

  grid.Row := i;
  grid.Col := 1;
  //grid.SetFocus;
  result := i;
end;

procedure TForm2.Show1Click(Sender: TObject);
begin
	AlfabetForm.Show;
end;

end.
