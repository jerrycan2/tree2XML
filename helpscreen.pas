unit helpscreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  THelpForm = class(TForm)
    TabControl1: TTabControl;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure SaveFiles;
  private
    { Private declarations }
    help_changed: Boolean;
    butler_changed: Boolean;
    notes_changed: Boolean;
  public
    { Public declarations }
  end;

var
  HelpForm: THelpForm;

implementation

{$R *.dfm}

procedure THelpForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	SaveFiles;
end;

procedure THelpForm.FormCreate(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
  RichEdit1.Lines.LoadFromFile( 'iltree.help' );
end;

procedure THelpForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if not (Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_END,
    	VK_HOME, VK_PRIOR, VK_NEXT]) then
        begin
            if TabControl1.TabIndex = 0 then begin
                help_changed := True;
            end
            else if TabControl1.TabIndex = 1 then begin
                butler_changed := True;
            end
            else if TabControl1.TabIndex = 2 then begin
                notes_changed := True;
            end;
        end;


end;

procedure THelpForm.SaveFiles;
begin
  if help_changed then
  begin
    RichEdit1.Lines.SaveToFile( 'iltree.help' );
    help_changed := False;
  end;
  if butler_changed then
  begin
    RichEdit1.Lines.SaveToFile( 'iltree.but' );
    butler_changed := False;
  end;
  if notes_changed then
  begin
    RichEdit1.Lines.SaveToFile( 'iltree.notes' );
    notes_changed := False;
  end;
end;

procedure THelpForm.FormShow(Sender: TObject);
begin
    //changed := False;
end;

procedure THelpForm.TabControl1Change(Sender: TObject);
begin

  With RichEdit1.Lines do begin
    if TabControl1.TabIndex = 0 then begin
        SaveFiles;
     	LoadFromFile( 'iltree.help' );
        help_changed := False;
    end
    else if TabControl1.TabIndex = 1 then begin
        SaveFiles;
        LoadFromFile( 'iltree.but' );
        butler_changed := False;
    end
    else if TabControl1.TabIndex = 2 then begin
        SaveFiles;
        LoadFromFile( 'iltree.notes' );
        notes_changed := False;
    end;
  end;
end;

end.
