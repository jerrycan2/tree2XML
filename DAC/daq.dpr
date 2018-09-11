program daq;

uses
  Vcl.Forms,
  mainform in 'mainform.pas' {ButlerForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TButlerForm, ButlerForm);
  Application.Run;
end.
