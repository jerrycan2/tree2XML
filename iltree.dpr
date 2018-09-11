program iltree;

uses
  Forms,
  treeview in 'treeview.pas' {Form1},
  colorpickform in 'colorpickform.pas' {Form3},
  editor in 'editor.pas',
  helpscreen in 'helpscreen.pas' {HelpForm},
  ChooseDir in 'ChooseDir.pas' {SetMapForm},
  AlfabetHelp in 'AlfabetHelp.pas' {AlfabetForm},
  Vcl.Themes,
  Vcl.Styles,
  gs_dialog in 'gs_dialog.pas' {GreekSaveDialog},
  butlerview in 'DAC\butlerview.pas' {ButlerForm},
  compareform in 'DAC\compareform.pas' {CompForm};

{$R *.res}

begin
Try
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(THelpForm, HelpForm);
  Application.CreateForm(TSetMapForm, SetMapForm);
  Application.CreateForm(TAlfabetForm, AlfabetForm);
  Application.CreateForm(TGreekSaveDialog, GreekSaveDialog);
  Application.CreateForm(TButlerForm, ButlerForm);
  Application.CreateForm(TCompForm, CompForm);
  Application.Run;
Finally
	Form1.TreeTop := Form1.Iltree.TopNode;
    if Form1.is_changed.Checked then Form1.Iltree.SaveToFile('iltree.rescue');
End;

end.
