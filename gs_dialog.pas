unit gs_dialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TGreekSaveDialog = class(TForm)
    htmlbutton: TButton;
    datbutton: TButton;
    cancelbutton: TButton;
    Label1: TLabel;
    procedure htmlbuttonClick(Sender: TObject);
    procedure datbuttonClick(Sender: TObject);
    procedure cancelbuttonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GreekSaveDialog: TGreekSaveDialog;

implementation

{$R *.dfm}

procedure TGreekSaveDialog.cancelbuttonClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TGreekSaveDialog.datbuttonClick(Sender: TObject);
begin
    ModalResult := mrYes;
end;

procedure TGreekSaveDialog.htmlbuttonClick(Sender: TObject);
begin
    ModalResult := mrNo;
end;

end.
