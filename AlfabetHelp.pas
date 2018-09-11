unit AlfabetHelp;

interface

uses
  Windows,  Messages,  SysUtils,  Variants,  Classes,  Graphics,  Controls,  Forms,
  Dialogs,  StdCtrls;

type
  TAlfabetForm = class(TForm)
    Label1: TLabel;
    Greek: TLabel;
    Latin: TLabel;
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlfabetForm: TAlfabetForm;

implementation

{$R *.dfm}

procedure TAlfabetForm.FormClick(Sender: TObject);
begin
    AlfabetForm.Close;
end;

end.

