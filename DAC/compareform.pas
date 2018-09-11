unit compareform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TCompForm = class(TForm)
    OldMemo: TMemo;
    NewMemo: TMemo;
    Panel1: TPanel;
    SyncCheck: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure comparetexts;
  end;

var
  CompForm: TCompForm;

implementation

{$R *.dfm}

procedure TCompForm.FormResize(Sender: TObject);
begin
    OldMemo.Width := CompForm.ClientWidth div 2;
    NewMemo.Width := CompForm.ClientWidth - OldMemo.Width;
end;

procedure TCompForm.FormShow(Sender: TObject);
begin
    comparetexts;
end;

procedure TCompForm.comparetexts;
begin
    if OldMemo.Text <> NewMemo.Text then ShowMessage('not equal')
    else ShowMessage('equal');
end;
end.
