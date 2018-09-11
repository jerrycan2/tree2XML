unit ChooseDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.FileCtrl;

type
  TSetMapForm = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    FileListBox1: TFileListBox;
    DriveComboBox1: TDriveComboBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetMapForm: TSetMapForm;
  WorkDir, HomeDir:			string;

implementation

{$R *.dfm}

procedure TSetMapForm.Button1Click(Sender: TObject);
begin
	WorkDir := DirectoryListBox1.Directory;
    SetMapForm.ModalResult := mrOK;
    SetMapForm.CloseModal;
end;

procedure TSetMapForm.Button2Click(Sender: TObject);
begin
    SetMapForm.ModalResult := mrCancel;
    SetMapForm.CloseModal;
end;

procedure TSetMapForm.Button3Click(Sender: TObject);
begin
    DirectoryListBox1.Directory := HomeDir  //move to treeview!
end;

procedure TSetMapForm.FileListBox1Click(Sender: TObject);
begin
	//FileListBox1.s
end;

procedure TSetMapForm.FormCreate(Sender: TObject);
begin
    DirectoryListBox1.MultiSelect := false;
    DirectoryListBox1.Directory := WorkDir;
end;

end.
