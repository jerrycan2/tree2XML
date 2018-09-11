unit editor;

interface
uses
  Windows, WinApi.Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VirtualTrees, ExtDlgs, ImgList, Buttons, ExtCtrls, System.UITypes, ComCtrls;

type
    TIltreeEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;        // One of the property editor classes.
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
  protected
  public
    destructor Destroy; override;

    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
	procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; 
    				Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;

implementation

uses treeview;

destructor TIltreeEditLink.Destroy;
begin
  FEdit.Free;
  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------
procedure TIltreeEditLink.EditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Fedit.Refresh;
end;

procedure TIltreeEditLink.EditKeyDown(Sender: TObject;
		var Key: Word; Shift: TShiftState);
var
  CanAdvance: Boolean;
  td: ^rTreeData;
begin
  CanAdvance := true;

  case Key of
    VK_ESCAPE:
      if CanAdvance then
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
    VK_RETURN:
      if CanAdvance then
      begin
        FTree.EndEditNode;
        Key := 0;
      end;

    VK_UP,
    VK_DOWN:
      begin
        if CanAdvance then
        begin
          // Forward the keypress to the tree. It will asynchronously change the focused node.
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
    VK_F11:
      begin
      	td := FTree.GetNodeData( FTree.GetFirstSelected );
        with TEdit(FEdit).Font do begin
          if fsItalic in Style then begin
            Style := Style - [fsItalic];
            td.italic := False;
          end
          else begin
            Style := Style + [fsItalic];
            td.italic := True;
          end;
        end;
        td.Changed := True;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TIltreeEditLink.BeginEdit: Boolean;
var
  td: ^rTreeData;
begin
  td := FTree.GetNodeData( FTree.GetFirstSelected );
  Result := True;
  with FEdit as TEdit do begin
  	Font.Size := Form1.Iltree.Font.Size;
    Show;
    SetFocus;
    if td.italic then begin
    	Font.Style := Font.Style + [fsItalic];
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TIltreeEditLink.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

//----------------------------------------------------------------------------------------------------------------------

function TIltreeEditLink.EndEdit: Boolean;
var
  Buffer: array[0..1024] of Char;
  S: String;
  td: ^rTreeData;

begin
  Result := True;

  td := FTree.GetNodeData(FNode);
  if FEdit is TEdit then
    S := TEdit(FEdit).Text
  else
  begin
    GetWindowText(FEdit.Handle, Buffer, 1024);
    S := Buffer;
  end;

  if S <> td.Data then
  begin
    td.Data := S;
    td.Changed := True;
    FTree.InvalidateNode(FNode);
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

//----------------------------------------------------------------------------------------------------------------------

function TIltreeEditLink.GetBounds: TRect;

begin
  Result := FEdit.BoundsRect;
end;

//----------------------------------------------------------------------------------------------------------------------

function TIltreeEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode;
	Column: TColumnIndex): Boolean;

var
  td: ^rTreeData;

begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;

  FEdit.Free;
  FEdit := nil;
  td := FTree.GetNodeData(Node);
  FEdit := TEdit.Create(nil);
  with FEdit as TEdit do
  begin
  	Visible := False;
    Parent := Tree;
    Text := td.Data;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
    //OnClick := EditClick;
  end;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TIltreeEditLink.ProcessMessage(var Message: TMessage);

begin
  FEdit.WindowProc(Message);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TIltreeEditLink.SetBounds(R: TRect);

var
  Dummy: Integer;

begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  R.Top := R.Top - 4;
  R.Bottom := R.Bottom + 4;
  FEdit.BoundsRect := R;
end;

end.

