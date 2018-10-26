unit treeview;

interface

uses
    Windows, Messages, ActiveX, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ImgList, ComCtrls, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls,
    ExtCtrls, Grids, Spin, Buttons, VirtualTrees, Textform,
    colorpickform, davColorBox, editor, Math, System.UITypes,
    StrUtils, OleCtnrs, OleCtrls, SHDocVw, Menus, jpeg, helpscreen,
    GIFImg, ChooseDir, System.ImageList, butlerview, gs_dialog;

// *************** TYPEDEFS ************************
type
    TForm1 = class(TForm)
        XMLDocument1: TXMLDocument;
        Panel1: TPanel;
        Label1: TLabel;
        Expandbtn: TBitBtn;
        ShowTextBtn: TBitBtn;
        loadxmlbtn: TBitBtn;
        savexmlbtn: TBitBtn;
        autosave: TCheckBox;
        ColorPickbtn: TBitBtn;
        collapsebtn: TBitBtn;
        HidecolBtn: TBitBtn;
        ShowcolBtn: TBitBtn;
        ImageList1: TImageList;
        insertbtn: TBitBtn;
        deletebtn: TBitBtn;
        savetree: TBitBtn;
        loadtree: TBitBtn;
        autoload: TCheckBox;
        RadioGroup1: TRadioGroup;
        greeksearchbtn: TBitBtn;
        bookmarkbtn: TBitBtn;
        Button1: TButton;
        Iltree: TVirtualStringTree;
        SpinEdit1: TSpinEdit;
        Label2: TLabel;
        Label3: TLabel;
        clearselbm: TPanel;
        clrallbm: TPanel;
        helpbutton: TBitBtn;
        bookmarklist: TComboBox;
        Label4: TLabel;
        is_changed: TCheckBox;
        GreekHidden: TCheckBox;
        MainMenu1: TMainMenu;
        F1: TMenuItem;
        Setworkingdirectory1: TMenuItem;
        StatusBar1: TStatusBar;
        choosefile: TComboBox;
        ProgressBar1: TProgressBar;
        linesearch: TRadioButton;
        capsearch: TRadioButton;
        bkmarksearch: TRadioButton;
        remarks: TRichEdit;
        textbox: TEdit;
        searchtextlbl: TLabel;
        ListButton: TButton;
        OpenDialog1: TOpenDialog;
        greekbutton: TButton;
        DragDropOK: TCheckBox;

        procedure FormCreate(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure FormResize(Sender: TObject);
        procedure DownLevelClick(Sender: TObject);
        procedure UpLevelClick(Sender: TObject);
        procedure IltreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
          TextType: TVSTTextType; var CellText: String);
        procedure IltreeAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
          ItemRect: TRect);
        procedure IltreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
          out EditLink: IVTEditLink);
        procedure ShowTextBtnClick(Sender: TObject);
        procedure loadxmlbtnClick(Sender: TObject);
        procedure IltreeDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
          Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
        procedure IltreeDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
          var Allowed: Boolean);
        procedure IltreeDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState;
          Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
        procedure savexmlbtnClick(Sender: TObject);
        procedure SpinEdit1Change(Sender: TObject);
        procedure ColorPickbtnClick(Sender: TObject);
        procedure SetNodeBGColor(kleur: TColor);
        procedure SetNodeFGColor(kleur: TColor);
        procedure IltreeAfterItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
          ItemRect: TRect);
        procedure HidecolBtnClick(Sender: TObject);
        procedure ShowcolBtnClick(Sender: TObject);
        procedure IltreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
          var Allowed: Boolean);
        procedure IltreeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure IltreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure IltreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure remarksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure remarksExit(Sender: TObject);
        procedure remarksEnter(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure InsertBtnClick(Sender: TObject);
        procedure deletebtnClick(Sender: TObject);
        procedure savetreeClick(Sender: TObject);
        procedure IltreeSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Stream: TStream);
        procedure IltreeLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Stream: TStream);
        procedure IltreeIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: String;
          var Result: Integer);
        procedure IltreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
        procedure RadioGroup1Click(Sender: TObject);
        procedure textboxKeyPress(Sender: TObject; var Key: Char);
        procedure textboxExit(Sender: TObject);
        procedure bookmarkbtnClick(Sender: TObject);
        procedure greeksearchbtnClick(Sender: TObject);
        procedure IltreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
          var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: String);
        procedure HTMLButtonClick(Sender: TObject);
        procedure IltreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
          Column: TColumnIndex; TextType: TVSTTextType);
        procedure clrallbmMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure clrallbmMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure clearselbmMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure clearselbmMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure helpbuttonClick(Sender: TObject);
        procedure bookmarklistChange(Sender: TObject);
        procedure findbm(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
        procedure IltreeStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode; Reason: TChangeReason);
        procedure IltreeEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
        procedure hideLeaves(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
        procedure notextlinesClick(Sender: TObject);
        procedure GreekHiddenClick(Sender: TObject);
        procedure Setworkingdirectory1Click(Sender: TObject);
        procedure choosefileClick(Sender: TObject);
        procedure autosaveClick(Sender: TObject);
        procedure autoloadClick(Sender: TObject);
        procedure loadtreeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure collapsebtnClick(Sender: TObject);
        procedure ExpandbtnClick(Sender: TObject);
        procedure ListButtonClick(Sender: TObject);
        procedure ScrollToTextline(Node: PVirtualNode);
        procedure FormDestroy(Sender: TObject);
        procedure greekbuttonClick(Sender: TObject);
        procedure IltreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
        procedure IltreeGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
          Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex; var ImageList: TCustomImageList);
        function EscString(s: String): String;
        function ColorString(kleur: TColor): String;
        procedure RenameBackups(filename: String);
        procedure XML2Tree(Iltree: TVirtualStringTree; XMLDoc: TXMLDocument);
        procedure Tree2XMLList(Iltree: TVirtualStringTree);
        procedure Tree2XML(Iltree: TVirtualStringTree);
        procedure Tree2HTML; // create html collapsible list
        procedure greek2html;
        procedure greek2dat;
        procedure ColorTextlines(SetTreeColor: Boolean = True);
    procedure StatusBar1MouseEnter(Sender: TObject);
    procedure choosefileMouseEnter(Sender: TObject);
    function getchapter(lineID: string): integer;
    function getlinenr(lineID: string): integer;
    function ReverseColor(colstr: string):string;

    private
        EditingBookmark: Boolean;
        procedure GetTextLines(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
        procedure setheight(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
        // :        TVTGetNodeProc;
        procedure clearbm(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
        // :        TVTGetNodeProc;
        procedure SaveRemarks;
        procedure LoadRemarks;
        function convertchar(c: String): String;

    public
        ButlerFileName: string;
        DefaultFG: TColor;
        DefaultBG: TColor;
        TreeTop: PVirtualNode;
        HiddenCols: Integer;
        Settings: TStringList;
        HTMLfile: TStringList;
        icons: TBitMap;
        mask: TBitMap;
        FormLeft, FormTop, FormWidth, FormHeight: Integer;
    end;

type
    rTreeData = record // VirtualTreeNode's attributes
        XMLName: String; // the XML identifier of the node
        Data: String; // the greek text appearing on screen for this node (if any)
        remark: String; // F3 shows it
        linenumber: String; // iliad linenumber if this is a leaf
        bookmark: String; // bookmark chars if appl.
        BGColor: TColor; // foreground color
        FGColor: TColor; // backgr. color
        Changed: Boolean; // used in editor-escape
        rem: Boolean; // flag: node has a 'remark' string
        index: Integer; // lineindex ( iliad line nr )
        italic: Boolean; // style italic
    end;

    // *************** GLOBALS *************************
var
    Form1: TForm1;
    FirstLineOfSel: Boolean;
    Linecount: Integer;
    Maxlines: Integer;
    Levelcount: Integer;
    Maxlevel: Integer;
    proportion: double;
    XMLfilename: string;
    SelNodes: TNodeArray;
    SaveScrollPos: Integer;
    NumLines: Integer;
    Lineindex: Integer;
    Chapindex: Integer;

const
    NofColors = 20;
    GRalfabet: String = ('ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψω');
    Lalfabet: String = ('ABGDEZHQIKLMNCOPRSTUFXYWabgdezhqiklmncoprstufxyw');
    BOM: Char = #$FEFF;
    chaplen: array [1 .. 24] of Integer = // iliad book lengths
      (611, 877, 461, 544, 909, 529, 482, 561, 713, 579, 848, 471, 837, 522, 746, 867, 761, 617, 424, 503, 611, 515,
      897, 804);

implementation

{$R *.dfm}

// ******************EscString***********************
function TForm1.EscString(s: String): String;
var
    i: Integer;
    new: String;
begin
    for i := 0 to Length(s) - 1 do
    begin
        if s[i] = '&' then
        begin
            new := MidStr(s, 0, i - 1) + '&amp; ' + MidStr(s, i + 1, Length(s) - i);
            s := new;
        end;
//        else if (s[i] = #34) or (s[i] = #39)  then
//        begin
//            new := MidStr(s, 0, i - 1) + '&#34; ' + MidStr(s, i + 1, Length(s) - i);
//            s := new;
//        end;


    end;
    Result := s;
end;

function TForm1.ColorString(kleur: TColor): String;
var
    bstr: string;
    bg: Longint;
begin
    bg := ColorToRGB(kleur);
    bstr := IntToHex(bg, 6);
    Result := String(bstr);
end;

function TForm1.ReverseColor(colstr: string):string;
begin  //Delphi has wrong Endian
    Result := colstr.Substring(4, 2) + colstr.Substring(2, 2) + colstr.Substring(0, 2);
end;

//********************LINE NUMBERS******************
function TForm1.getchapter(lineID: string): integer;
var
    pos: integer;
begin
    pos := lineID.indexOf('.');
    result := StrToInt(lineID.Substring(0, pos));
end;

function TForm1.getlinenr(lineID: string): integer;
var
    pos: integer;
begin
    pos := lineID.indexOf('.') + 1;
    result := StrToInt(lineID.Substring(pos));
end;

// *******************RenameBackups*****************
procedure TForm1.RenameBackups(filename: String);
var
    n, found, pos: Integer;
    ext: string;
begin
    ext := '.bk';

    pos := filename.IndexOf('.xml'); // remove extension
    if pos >= 0 then SetLength(filename, pos);

    found := 0;
    for n := 9 downto 1 do
        if (FileExists(filename + ext + IntToStr(n))) then
        begin
            found := n;
            break;
        end;

    if found = 9 then
    begin
        DeleteFile(filename + ext + IntToStr(found));
        Dec(found);
    end
    else
        Form1.choosefile.Items.Append(filename + ext + IntToStr(found + 1));

    for n := found downto 1 do
    begin
        RenameFile(filename + ext + IntToStr(n), filename + ext + IntToStr(n + 1));
    end;
    RenameFile(filename + '.xml', filename + '.bk1');
end; // *************end rename backups**************


// ******************XML2TREE***********************

procedure TForm1.XML2Tree(Iltree: TVirtualStringTree; XMLDoc: TXMLDocument);
var
    error_shown: boolean;
    jNode: IXMLNode;

    procedure ProcessNode(XNode: IXMLNode; VNode: PVirtualNode);
    var
        firstXNode: IXMLNode;
        tdata: ^rTreeData;
        text, textoud, line, chap: String;
        item: TListItem;
        chapnr, linenr: integer;
    begin
        if (XNode = nil) or ((XNode.LocalName = 'line') and (XNode.NodeValue = null)) then
            Exit;
        if VNode = nil then
        begin
            VNode := Iltree.GetFirst;
        end else begin
            VNode := Iltree.AddChild(VNode);
        end;
        Iltree.ValidateNode(VNode, false);
        tdata := Iltree.GetNodeData(VNode);
        tdata.XMLName := XNode.LocalName;
        if XNode.HasAttribute('d') then
            tdata.Data := XNode.Attributes['d'];
        // node screentext
        if XNode.HasAttribute('c') then
            tdata.BGColor := StrToInt('$' + ReverseColor(XNode.Attributes['c'])) // bg color
        else
            tdata.BGColor := Form1.DefaultBG; // no color yet

        if XNode.HasAttribute('f') then
        begin
            tdata.FGColor := StrToInt('$' + ReverseColor(XNode.Attributes['f'])) // foregroundcolor
        end
        else
            tdata.FGColor := Form1.DefaultFG;

        if XNode.HasAttribute('rem') then
        begin
            tdata.remark := XNode.Attributes['rem'];
        end;

        if XNode.HasAttribute('ital') then
        begin
            tdata.italic := True;
        end;

        if XNode.HasAttribute('bm') then
        begin
            tdata.bookmark := XNode.Attributes['bm'];
            Form1.bookmarklist.Items.Add(tdata.bookmark);
        end;

        if XNode.LocalName = 'line' then
        begin // "leaf" node contains Greek text
            // Form2.grid.RowCount := Form2.grid.RowCount + 1;
            tdata.XMLName := XNode.LocalName;
            item := ButlerForm.GreekView.Items.Add;
            item.SubItems.Add(XNode.NodeValue); (* hier *)
            // Form2.grid.Cells[ 1, Linecount ] := Form2.grid.Cells[ 2, Linecount ];  (*hier*)
            tdata.Data := XNode.NodeValue;
            // tdata.Data := Form2.grid.Cells[ 2, Linecount ];

            if (Lineindex > chaplen[Chapindex]) then
            begin
                Lineindex := 1;
                Chapindex := Chapindex + 1;
            end;
            chapnr := getchapter(XNode.Attributes[ 'lnr' ]);
            linenr := getlinenr(XNode.Attributes[ 'lnr' ]);
            chap := IntToStr(Chapindex);
            line := IntToStr(Lineindex);
            text := chap + '.' + line; //temp
            textoud := String(XNode.Attributes[ 'lnr' ]);
            if ((Chapindex <> chapnr) or (Lineindex <> linenr)) then
            begin
                if not error_shown then
                begin
                    ShowMessage('Linenumber error in: ' + text + ',oud: ' + textoud);
                    error_shown := True;
                end;
            end;

            // Form2.grid.Cells[ 0, Linecount ] := text;
            item.Caption := textoud; //in case of renumbering after error: use text instead
            ButlerForm.SetListColors(Linecount, Form1.DefaultFG, Form1.DefaultBG);

            tdata.linenumber := textoud; //in case of renumbering after error: use text instead
            tdata.index := Linecount;
            Lineindex := Lineindex + 1;
            Linecount := Linecount + 1;

        end else begin // not a leaf: must have children
            firstXNode := XNode.ChildNodes.First;
            while firstXNode <> nil do
            begin
                ProcessNode(firstXNode, VNode);
                Form1.ProgressBar1.Position := Linecount;
                firstXNode := firstXNode.NextSibling;
            end;
        end;
    end; (* ProcessNode *)

begin (* XML2TREE *)
    Linecount := 0;
    Lineindex := 1;
    Chapindex := 1;
    error_shown := False;
    // Form2.grid.Clear;
    // Form2.grid.RowCount := 0;
    Form1.ProgressBar1.Position := 0;
    if XMLDoc.ChildNodes.First = nil then
    begin
        ShowMessage('no XML!');
        Exit;
    end;
    ButlerForm.GreekView.Items.BeginUpdate;
    ButlerForm.GreekView.Items.Clear;
    jNode := XMLDoc.DocumentElement;
    Form1.ProgressBar1.Max := StrToInt(jNode.Attributes['sz']);
    ProcessNode(jNode, nil);

    ButlerForm.GreekView.Items.EndUpdate;
    Maxlines := Linecount;
    Form1.ProgressBar1.Position := 0;
end;

// *************** TREE2XMLList for use by site index.html ************************
procedure TForm1.Tree2XMLList(Iltree: TVirtualStringTree);
var
    tn: PVirtualNode;
    XMLDoc: TXMLDocument;
    iNode: IXMLNode;
    td: ^rTreeData;
    text, name, colstr: String;
    kleur: TColor;
    totalsize: Integer; // if ok, number of lines in the Iliad
    function ProcessTreeItem(treechildnode: PVirtualNode; XMLparentNode: IXMLNode): Integer;
    var // node has Greek text IFF it's a leaf
        XMLchildNode: IXMLNode;
        text: String;
        tdata, ttemp: ^rTreeData;
        nodetemp: PVirtualNode;
        i: Integer;
        linenumber, chap, line: string;
        lvl: Integer;
        size: Integer; // number of textlines the node refers to
    begin
        if (treechildnode = nil) then
        begin
            Result := 0;
            Exit;
        end;

        tdata := Iltree.GetNodeData(treechildnode);
        lvl := Iltree.GetNodeLevel(treechildnode);

        if tdata.XMLName = 'line' then
        begin
            //name := 'line'; // leaf. keep this name!
            //XMLchildNode := XMLparentNode.AddChild(name);  //--
            Form1.ProgressBar1.Position := tdata.index;
        end else begin
            name := 'lvl' + String(IntToStr(lvl));
            XMLchildNode := XMLparentNode.AddChild(name);

            nodetemp := treechildnode;
            ttemp := Form1.Iltree.GetNodeData(nodetemp);
            while ttemp.linenumber = '' do
            begin // go get chapter+linenr (line empty except leaves)
                nodetemp := nodetemp.FirstChild; // line contains chapter+linenr (A 1 etc)
                ttemp := Form1.Iltree.GetNodeData(nodetemp);
            end;
//            chap := Copy(ttemp.line, 1, 1);
//            line := Copy(ttemp.line, 2);
//            i := Pos(chap, GRalfabet); // letter to index
//            linenumber := String(IntToStr(i)) + '.' + line;
            XMLchildNode.Attributes['ln'] := ttemp.linenumber;
        end;
        size := 0;
        if treechildnode.ChildCount > 0 then // if not a leaf, then...
        begin
            text := tdata.Data;
            if text <> '' then
            begin
                XMLchildNode.Attributes['d'] := text;
            end else begin
                if (lvl >= 1) and (name <> 'line') then
                    XMLchildNode.Attributes['d'] := 'descr';
            end;
            kleur := tdata.BGColor;
            colstr := ColorString(kleur);
            colstr := ReverseColor(colstr);
            if (kleur <> Form1.DefaultBG) then
            begin
                XMLchildNode.Attributes['c'] := colstr;
            end;
            kleur := tdata.FGColor;
            colstr := ColorString(kleur);
            colstr := ReverseColor(colstr);
            if (kleur <> Form1.DefaultFG) then
            begin
                XMLchildNode.Attributes['f'] := colstr;
            end;

            // if tdata.remark <> '' then XMLchildNode.Attributes[ 'rem' ] := tdata.remark;
        end else begin // leaf
            size := 1;
            //XMLchildNode.Text := tdata.Data; //--
        end;
        // child nodes, depth first
        treechildnode := treechildnode.FirstChild;
        while treechildnode <> nil do
        begin
            size := size + ProcessTreeItem(treechildnode, XMLchildNode);
            treechildnode := treechildnode.NextSibling;
        end;
        if size > 1 then
            XMLchildNode.Attributes['sz'] := IntToStr(size);
        Result := size;
    end; (* local ProcessTreeItem *)

// *************************************************
begin (* Tree2XMLList (same as tree2xml but without greek text & some changes) *)
    Form1.ProgressBar1.Position := 0;

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := True;
    tn := Iltree.GetFirst;
    td := Iltree.GetNodeData(tn);
    text := td.XMLName;
    iNode := XMLDoc.AddChild(text);
    iNode.Attributes['d'] := 'The Iliad';
    totalsize := 0;
    tn := tn.FirstChild;
    while tn <> nil do
    begin
        totalsize := totalsize + ProcessTreeItem(tn, iNode);

        tn := tn.NextSibling;
    end;
    iNode.Attributes['sz'] := IntToStr(totalsize);
    XMLfilename := 'list.xml';
    if not XMLDoc.IsEmptyDoc then
    begin
        XMLDoc.SaveToFile(XMLfilename);
    end;
    Form1.ProgressBar1.Position := 0;
end; (* Tree2XMLList *)

// *************************************************
// *************************************************

procedure TForm1.Tree2XML(Iltree: TVirtualStringTree);
var
    tn: PVirtualNode;
    XMLDoc: TXMLDocument;
    iNode: IXMLNode;
    td: ^rTreeData;
    text, name: String;
    kleur: TColor;
    totalsize: Integer; // if ok, number of lines in the Iliad
    function ProcessTreeItem(treechildnode: PVirtualNode; XMLparentNode: IXMLNode): Integer;
    var // node has Greek text IFF it's a leaf
        XMLchildNode: IXMLNode;
        text: String;
        tdata: ^rTreeData;
        lvl: Integer;
        size: Integer; // number of textlines the node refers to
    begin
        if (treechildnode = nil) then
        begin
            Result := 0;
            Exit;
        end;
        tdata := Iltree.GetNodeData(treechildnode);
        lvl := Iltree.GetNodeLevel(treechildnode);

        if tdata.XMLName = 'line' then
        begin
            name := 'line'; // leaf. keep this name!
            Form1.ProgressBar1.Position := tdata.index;
        end
        else
            name := 'lvl' + String(IntToStr(lvl));

        size := 0;
        XMLchildNode := XMLparentNode.AddChild(name);
        if treechildnode.ChildCount > 0 then // if not a leaf, then...
        begin
            text := tdata.Data;
            if text <> '' then
            begin
                XMLchildNode.Attributes['d'] := text;
            end else begin
                if (lvl >= 1) and (name <> 'line') then
                    XMLchildNode.Attributes['d'] := 'descr';
            end;
            kleur := tdata.BGColor;
            if (kleur <> Form1.DefaultBG) then
                XMLchildNode.Attributes['c'] := ReverseColor(ColorString(kleur));
//                XMLchildNode.Attributes['c'] := ColorString(kleur);
            kleur := tdata.FGColor;
            if (kleur <> Form1.DefaultFG) then
                XMLchildNode.Attributes['f'] := ReverseColor(ColorString(kleur));
//                XMLchildNode.Attributes['f'] := ColorString(kleur);

            if tdata.remark <> '' then
                XMLchildNode.Attributes['rem'] := tdata.remark;
            if tdata.italic then
                XMLchildNode.Attributes['ital'] := '1';

        end else begin // leaf
            XMLchildNode.NodeValue := tdata.Data;
            XMLchildNode.Attributes['lnr'] := tdata.linenumber;
            size := 1;
        end;
        if tdata.bookmark <> '' then
        begin
            XMLchildNode.Attributes['bm'] := tdata.bookmark;
        end;

        // child nodes, depth first
        treechildnode := treechildnode.FirstChild;
        while treechildnode <> nil do
        begin
            size := size + ProcessTreeItem(treechildnode, XMLchildNode);
            treechildnode := treechildnode.NextSibling;
        end;
        if size > 1 then
            XMLchildNode.Attributes['sz'] := IntToStr(size);
        Result := size;
    end; // local ProcessTreeItem
// *************************************************
begin // Tree2XML
    Form1.ProgressBar1.Position := 0;

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := True;
    tn := Iltree.GetFirst;
    td := Iltree.GetNodeData(tn);
    text := td.XMLName;
    iNode := XMLDoc.AddChild(text);
    iNode.Attributes['d'] := 'The Iliad';
    totalsize := 0;
    tn := tn.FirstChild;
    while tn <> nil do
    begin
        totalsize := totalsize + ProcessTreeItem(tn, iNode);

        tn := tn.NextSibling;
    end;
    iNode.Attributes['sz'] := IntToStr(totalsize);
    XMLfilename := 'iliad.xml'; //Form1.choosefile.Items[Form1.choosefile.ItemIndex];
    if not XMLDoc.IsEmptyDoc then
    begin
        RenameBackups(XMLfilename);
        XMLDoc.SaveToFile(XMLfilename);
    end;
    Form1.ProgressBar1.Position := 0;
end; // Tree2XML

// *************** TREE2HTML ************************
procedure TForm1.Tree2HTML; // create html collapsible list
var
    TekstBuf: TStringList;
    txt: String;
    chap, line, linenumber: String;
    i: Integer;
    s, bstr, fstr: String;

    procedure walk(Node: PVirtualNode);
    var
        td, ttemp: ^rTreeData;
        nodetemp: PVirtualNode;
        lvl: Integer;
        empty: Boolean;
    begin
        if Node <> nil then
        begin
            lvl := Form1.Iltree.GetNodeLevel(Node);
            txt := '<ol';
            if lvl <= 8 then
            begin // level class id's voor html DOM manipulatie
                case lvl of
                    0:
                        txt := txt + ' class="v0">';
                    1:
                        txt := txt + ' class="v1">';
                    2:
                        txt := txt + ' class="v2">';
                    3:
                        txt := txt + ' class="v3">';
                    4:
                        txt := txt + ' class="v4">';
                    5:
                        txt := txt + ' class="v5">';
                    6:
                        txt := txt + ' class="v6">';
                    7:
                        txt := txt + ' class="v7">';
                    8:
                        txt := txt + ' class="v8">';
                end;
            end else begin
                txt := txt + '>';
            end;
            TekstBuf.Add(txt);

            empty := True;
            repeat
                td := Form1.Iltree.GetNodeData(Node);
                ttemp := td;
                nodetemp := Node;
                txt := '';
                while ttemp.linenumber = '' do
                begin // go get chapter+linenr (line empty except leaves)
                    nodetemp := nodetemp.FirstChild; // line contains chapter+linenr (A 1 etc)
                    ttemp := Form1.Iltree.GetNodeData(nodetemp);
                end;
//                chap := Copy(ttemp.line, 1, 1);
//                line := Copy(ttemp.line, 2);
//                i := Pos(chap, GRalfabet); // letter to index
                linenumber := ttemp.linenumber;
                // len := 8 - Length( linenumber );
                // for n := 1 to len do begin
                // linenumber := linenumber + '&nbsp;'; // align levels on page
                // end;
                txt := '<span class="ln">' + linenumber + '</span>';
                if td.linenumber = '' then // exclude the greek text, too cumbersome otherwise
                begin
                    empty := false;
                    TekstBuf.Add('<li>');
                    TekstBuf.Add(txt);
                    bstr := ColorString(td.BGColor);
                    bstr := ReverseColor(bstr);
                    fstr := ColorString(td.FGColor);
                    fstr := ReverseColor(fstr);
                    s := '<span style="color: #' + fstr + '; background-color: #' + bstr + '">';
                    TekstBuf.Add(String(s));
                    if lvl = 0 then
                        txt := ' The Iliad '
                    else
                        txt := '&nbsp;' + EscString(td.Data) + '&nbsp;';
                    TekstBuf.Add(txt);
                    TekstBuf.Add('</span>');
                    if Node.ChildCount <> 0 then
                    begin
                        ttemp := Form1.Iltree.GetNodeData(Node.FirstChild);
                        if ttemp.linenumber = '' then
                            TekstBuf.Add('<span>&nbsp;<b>+</b></span>');
                        walk(Node.FirstChild);
                    end;
                    TekstBuf.Add('</li>');
                end
                else
                    Form1.ProgressBar1.Position := td.index;
                Node := Node.NextSibling;
            until Node = nil;
            if not empty then
                TekstBuf.Add('</ol>')
            else
                TekstBuf.Delete(TekstBuf.Count - 1);
        end;
    end;

begin
    TekstBuf := TStringList.Create;
    // TekstBuf.Add( '<h1>Semantic Structure</h1>' );
    Form1.ProgressBar1.Position := 0;

    walk(Form1.Iltree.GetFirst); // create the <OL> part of the html file

    TekstBuf.SaveToFile('list.html');
    TekstBuf.Destroy;
    Form1.ProgressBar1.Position := 0;
end;

// ****************** GREEK HTML ********************
procedure TForm1.greek2html;
var
    TekstBuf: TStringList;
    c, currchap: integer;

    procedure walk(Node: PVirtualNode);
    var
        tdata: ^rTreeData;
        txt, lineID: string;
    begin
        if Node = nil then
            Exit;
        txt := '';
        lineID := '';
        repeat
            if Node.ChildCount > 0 then
                walk(Node.FirstChild)
            else
            begin
                tdata := Node.GetData;
                if lineID = '' then
                begin
                    lineID := tdata.linenumber;
                    c := getchapter(lineID);
                    if currchap <> c then
                    begin
                        currchap := c;
                        TekstBuf.Add('<h4>Book ' + IntToStr(c) + '</h4>');
                    end;
                end;
                txt := txt + tdata.Data + '<br>' + sLineBreak;
            end;
            Node := Node.NextSibling;
        until Node = nil;
        if lineID <> '' then
            TekstBuf.Add('<p><a>' + lineID + '</a>' + txt + '</p>');
    end;

begin
    TekstBuf := TStringList.Create;
    // TekstBuf.Add( '<h1>Semantic Structure</h1>' );
    Form1.ProgressBar1.Position := 0;
    currchap := 0;

    walk(Form1.Iltree.GetFirst); // create the <OL> part of the html file

    TekstBuf.SaveToFile('greeklist.html', TEncoding.UTF8);
    TekstBuf.Destroy;
    Form1.ProgressBar1.Position := 0;
end;


// ****************** GREEK_IL.DAT ********************
procedure TForm1.greek2dat;
var
    TekstBuf: TStringList;
    c, currchap: integer;

    procedure walk(Node: PVirtualNode);
    var
        tdata: ^rTreeData;
        txt, lineID: string;
    begin
        if Node = nil then
            Exit;
        txt := '';
        lineID := '';
        repeat
            if Node.ChildCount > 0 then
                walk(Node.FirstChild)
            else
            begin
                tdata := Node.GetData;
                if lineID = '' then
                begin
                    lineID := tdata.linenumber;
                    c := getchapter(lineID);
                    if currchap <> c then
                    begin
                        currchap := c;
                        TekstBuf.Add('Book ' + IntToStr(c));
                    end;
                end;
                txt := txt + tdata.Data + sLineBreak;
            end;
            Node := Node.NextSibling;
        until Node = nil;
        if lineID <> '' then
            TekstBuf.Add(lineID + ' ' + txt);
    end;

begin
    TekstBuf := TStringList.Create;
    TekstBuf.LineBreak := #1;
    // TekstBuf.Add( '<h1>Semantic Structure</h1>' );
    Form1.ProgressBar1.Position := 0;
    currchap := 0;

    walk(Form1.Iltree.GetFirst);

    TekstBuf.SaveToFile('greeklist.txt', TEncoding.UTF8);
    TekstBuf.Destroy;
    Form1.ProgressBar1.Position := 0;
end;


// ****************** COLOR TEXT ********************

procedure TForm1.ColorTextlines(SetTreeColor: Boolean = True);
var { color all lines (in Form2.grid) that are in (children of) all
      selected nodes. if SetTreeColor = false then replace color by default }
    sel: PVirtualNode;

    procedure NodeOut(this, last: PVirtualNode; fg, bg: TColor; setit: Boolean);
    var // this, last: firstchild, lastchild of mother node
        tdata: ^rTreeData;
        exitloop: Boolean;
    begin
        if this = nil then
            Exit;
        repeat
        begin
            if this = last then
                exitloop := True // also do the last one
            else
                exitloop := false;
            tdata := Form1.Iltree.GetNodeData(this);
            // OutputDebugString(PWideChar(IntToStr(tdata.index)));
            if setit = True then
                fg := tdata.FGColor;
            if setit = True then
                bg := tdata.BGColor;
            if this.ChildCount = 0 then // this is a leaf, with greek text
            begin
                if SetTreeColor = True then
                begin
                    ButlerForm.SetListColors(tdata.index, fg, bg);
                end else begin // wipe colors
                    ButlerForm.SetListColors(tdata.index, Form1.DefaultFG, Form1.DefaultBG);
                end;
            end
            else // not a leaf:
            begin
                NodeOut(this.FirstChild, this.LastChild, fg, bg, false); // recurse depth-first
            end;

            this := this.NextSibling;
        end;
        until exitloop = True;

    end; // NodeOut, no doubt

// ********ColorTextlines****************************************
begin
    if not ButlerForm.Visible then
        Exit;

    for sel in SelNodes do
    begin // more than 1 node may be selected, not consecutive
        NodeOut(sel.Parent.FirstChild, sel.Parent.LastChild, -1, 0, True);
    end;
end; // ColorTextlines

// *************************************************
// ************** TForm1 METHODS *******************
// *************************************************

procedure TForm1.ScrollToTextline(Node: PVirtualNode);
var
    index: Integer;
    tdata: ^rTreeData;
begin
    while Node.ChildCount > 0 do
        Node := Node.FirstChild;
    tdata := Node.GetData;
    index := tdata.index;
    // if index > 0 then index := index - 1;
    ButlerForm.ScrollTo(index);
    ButlerForm.GreekViewSelectItem(nil, ButlerForm.GreekView.Items[index], false);
end;

// *************** FORMRESIZE **********************
procedure TForm1.FormResize(Sender: TObject);
var
    i: Integer;
    viscolcount: Integer; // nr of visible columns
begin
    if WindowState = wsNormal then
    begin
        FormLeft := Form1.Left;
        FormTop := Form1.Top;
        FormWidth := Form1.Width;
        FormHeight := Form1.Height;
    end;

    with Iltree.Header.Columns do
    begin
        viscolcount := Count - HiddenCols; // num of hidden columns on the left

        for i := 0 to Count - 1 do // colcount > 0
        begin
            if coVisible in Items[i].Options then
                Items[i].Width := Iltree.ClientWidth div viscolcount;
        end;
    end;

    Iltree.Font.size := SpinEdit1.Value;
    remarks.Font.size := SpinEdit1.Value;
    Iltree.DefaultNodeHeight := -Font.Height + 8;

    StatusBar1.Panels[0].Width := StatusBar1.Width - 300;
    StatusBar1.Panels[1].Width := 300;

    Form1.Refresh;
    Iltree.Refresh;
end;

procedure TForm1.greeksearchbtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Search in Greek text';
    // Form2.Visible := True;
    // Form2.searchtext(textbox.Text);
    // Form2.grid.SetFocus;
end;

procedure TForm1.helpbuttonClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Show Help/Notes form';
    HelpForm.Show;
end;

procedure TForm1.setheight(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
// callback from iteratesubtree
begin
    Iltree.NodeHeight[Node] := Integer(Data^); // points to 'newheight'
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
var
    newheight: Integer;
begin
    StatusBar1.Panels[1].text := 'adjusting font size';
    Iltree.Font.size := SpinEdit1.Value;
    Form1.Font.size := SpinEdit1.Value;
    newheight := -Iltree.Font.Height + 8;
    Iltree.DefaultNodeHeight := newheight;
    Iltree.IterateSubtree(nil, setheight, @newheight, [], false, false); // takes some time
    Form1.FormResize(nil);
    if ButlerForm <> nil then ButlerForm.FormResize(nil);
//    Iltree.SetFocus;
end;

procedure TForm1.StatusBar1MouseEnter(Sender: TObject);
begin
    StatusBar1.Hint := StatusBar1.Panels[0].text;
end;

procedure TForm1.textboxExit(Sender: TObject);
var // bookmark is set when textbox loses focus
    sel: PVirtualNode;
    seldata: ^rTreeData;
begin
    if not EditingBookmark then
        Exit;
    if Iltree.SelectedCount <> 0 then
    begin
        sel := Iltree.GetSortedSelection(True)[0];
        seldata := Iltree.GetNodeData(sel);
        if textbox.text <> '' then
        begin
            if bookmarklist.Items.IndexOf(textbox.text) = -1 then
            begin
                seldata.bookmark := textbox.text;
                bookmarklist.Items.Add(textbox.text);
                is_changed.Checked := True;
                EditingBookmark := false;
                textbox.Color := clWindow;
            end else begin
                ShowMessage('This bookmark name exists already. Try again:');
                textbox.text := '';
                textbox.SetFocus;
            end;
        end
        else
            textbox.Color := clWindow;
    end else begin
        ShowMessage('No caption selected. Try again:');
        textbox.Color := clWindow;
    end;
end;

procedure TForm1.textboxKeyPress(Sender: TObject; var Key: Char);
var
    s: String;
begin
    if not EditingBookmark then // writing Greek text
        if ((Key >= 'a') and (Key <= 'z')) or ((Key >= 'A') and (Key <= 'Z')) then
        begin
            StatusBar1.Panels[1].text := 'writing Greek for searching';
            s := convertchar(Key);
            textbox.SelText := s;
            Key := #0;
        end
        else
            StatusBar1.Panels[1].text := 'writing bookmark name';
end;

// *************** SHOW FORM 3 *********************
procedure TForm1.ColorPickbtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'show/hide colorpickform';
    if Form3.Visible then
        Form3.Hide
    else
        Form3.Show;
end;

// *************** ITEMPAINT ***********************
procedure TForm1.IltreeAfterItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect);
var
    tdata: ^rTreeData;
    level, Left, right, cols: Integer;
    colrect: TRect;
    BGColor: TColor;
begin
    tdata := Sender.GetNodeData(Node);
    cols := Iltree.Header.Columns.Count - 1;
    level := Sender.GetNodeLevel(Node);
    if level > cols then
        Exit;

    if tdata.BGColor = 0 then // black resets the color to Iltree default
        BGColor := DefaultBG
    else
        BGColor := tdata.BGColor;

    try
        Iltree.Header.Columns.GetColumnBounds(level, Left, right); // left,right: var params
    except
        ShowMessage('level=' + IntToStr(level) + ' cols=' + IntToStr(cols));
    end;
    colrect.Left := Left;
    colrect.right := right;
    colrect.Top := ItemRect.Top;
    colrect.Bottom := ItemRect.Bottom;
    TargetCanvas.Brush.Color := BGColor;
    TargetCanvas.FillRect(colrect);
end;

procedure TForm1.IltreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType);
var
    tdata: ^rTreeData;
    cols, level: Integer;
begin
    cols := Iltree.Header.Columns.Count - 1;
    level := Sender.GetNodeLevel(Node);
    if level > cols then
        Exit; // Node.Data.
    if Column > 0 then
    begin
        tdata := Sender.GetNodeData(Node);
        if tdata.FGColor <> 0 then
            TargetCanvas.Font.Color := tdata.FGColor;
        if tdata.italic then
            TargetCanvas.Font.Style := [fsItalic];
    end;
end;

procedure TForm1.IltreeAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect);
begin // reset local color & style
    TargetCanvas.Font.Color := DefaultFG;
    TargetCanvas.Font.Style := [];
end;

procedure TForm1.SetNodeBGColor(kleur: TColor); // callback from colorpickform
var
    tdata: ^rTreeData;
    i, Max: Integer;
    Node: PVirtualNode;
    fg: TColor;
begin
    SelNodes := Iltree.GetSortedSelection(True);
    Max := High(SelNodes);
    if Max >= 0 then
    begin
        for i := 0 to Max do
        begin
            Node := SelNodes[i];
            tdata := Iltree.GetNodeData(Node);
            tdata.BGColor := kleur;
            fg := tdata.FGColor;
            Iltree.InvalidateNode(SelNodes[i]); // force repaint
            if (Node.ChildCount > 0) and (Node.FirstChild.ChildCount = 0) then
            begin
                Node := Node.FirstChild;
                while Node <> nil do
                begin
                    tdata := Iltree.GetNodeData(Node);
                    ButlerForm.SetListColors(tdata.index, fg, kleur);
                    Node := Node.NextSibling;
                end;

            end;
        end;
    end;
    is_changed.Checked := True;
end;

procedure TForm1.SetNodeFGColor(kleur: TColor); // callback from colorpickform
var
    tdata: ^rTreeData;
    i, Max: Integer;
    Node: PVirtualNode;
    bg: TColor;
begin
    SelNodes := Iltree.GetSortedSelection(True);
    Max := High(SelNodes);
    if Max >= 0 then
    begin
        for i := 0 to Max do
        begin
            Node := SelNodes[i];
            tdata := Iltree.GetNodeData(Node);
            tdata.FGColor := kleur;
            bg := tdata.BGColor;
            Iltree.InvalidateNode(Node);
            if (Node.ChildCount > 0) and (Node.FirstChild.ChildCount = 0) then
            begin
                Node := Node.FirstChild;
                while Node <> nil do
                begin
                    tdata := Iltree.GetNodeData(Node);
                    ButlerForm.SetListColors(tdata.index, kleur, bg);
                    Node := Node.NextSibling;
                end;
            end;
        end;
    end;
    is_changed.Checked := True;
end;

procedure TForm1.Setworkingdirectory1Click(Sender: TObject);
var
    n: Integer;
begin // sets ChooseDir.WorkDir also sets working dir for .SaveToFile etc.
    choosefile.Items.Clear;
    choosefile.Items.Add('browse');
    StatusBar1.Panels[1].text := 'set working directory';
    SetMapForm.ShowModal;
    for n := 0 to ChooseDir.SetMapForm.FileListBox1.Items.Count - 1 do
    begin
        if ChooseDir.SetMapForm.FileListBox1.Selected[n] then
            choosefile.Items.Add(ChooseDir.SetMapForm.FileListBox1.Items[n]);
    end;
    if choosefile.Items.Count = 0 then
    begin
        choosefile.Items.Add('(empty)');
        StatusBar1.Panels[1].text := 'please select one or more xml files';
    end;
    choosefile.ItemIndex := ChooseDir.SetMapForm.FileListBox1.ItemIndex;
    if (choosefile.ItemIndex = -1) then
        choosefile.ItemIndex := 0;
    StatusBar1.Panels[0].text := 'Working in: ' + ChooseDir.WorkDir;
    choosefile.Hint := StatusBar1.Panels[0].text;
end;

// *************** GETIMAGEINDEX *******************
procedure TForm1.IltreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: String);
var
    tdata, td2: ^rTreeData;
    Lineindex, i1, i2: Integer;
    bg, nd: String;
    n2: PVirtualNode;
begin
    try
        if Iltree.RootNode.FirstChild.ChildCount = 0 then
            Exit;
        tdata := Iltree.GetNodeData(Node);
    except
        ShowMessage('hint error');
        Exit;
    end;
    // 1: get begin- and end line
    n2 := Node;
    while (n2.ChildCount > 0) do
    begin
        n2 := n2.FirstChild;
    end;

    td2 := Iltree.GetNodeData(n2);
    Lineindex := td2.index;
    bg := ButlerForm.GreekView.Items[Lineindex].Caption; // Form2.grid.Cells[ 0, lineindex ];
    if bg = '' then
        Exit;

    n2 := Node;
    if (n2.NextSibling = nil) then
    begin
        repeat
            n2 := n2.Parent;
            if (n2 = nil) then
                break;
        until (n2.NextSibling <> nil);
    end;
    if (n2 = nil) then
        nd := '24.804'
    else
    begin
        n2 := n2.NextSibling;
        while (n2.ChildCount > 0) do
        begin
            n2 := n2.FirstChild;
        end;
        td2 := Iltree.GetNodeData(n2);
        Lineindex := td2.index;
        nd := ButlerForm.GreekView.Items[Lineindex].Caption;
        if nd = '' then
            Exit;

        i1 := getchapter(nd);
        i2 := getlinenr(nd);
        if i2 = 1 then
        begin
            Dec(i1);
            if i1 = 0 then
                i1 := 24;
            i2 := chaplen[i1];
        end
        else
            Dec(i2);
        nd := IntToStr(i1) + '.' + IntToStr(i2);
    end;

    if tdata.linenumber <> '' then
        HintText := String(bg)
    else
        HintText := String(bg) + '-' + String(nd);
    HintText := HintText + #13 + '-------' + #13 + tdata.Data + ' ';
    if tdata.remark <> '' then
        HintText := HintText + #13 + '-------' + #13 + tdata.remark;
end;

procedure TForm1.IltreeGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex; var ImageList: TCustomImageList);
var // set/reset select checkboxes
    level: Integer;
    tdata: ^rTreeData;
begin
    level := Iltree.GetNodeLevel(Node);

    if (level = Column) and (level > 0) then
    begin
        tdata := Iltree.GetNodeData(Node);
        if vsSelected in Node.States then
            if tdata.bookmark <> '' then
                if tdata.remark <> '' then
                    ImageIndex := 0
                else
                    ImageIndex := 4
            else // no bookmark
                if tdata.remark <> '' then
                    ImageIndex := 6
                else
                    ImageIndex := 2
        else // not selected
            if tdata.bookmark <> '' then
                if tdata.remark <> '' then
                    ImageIndex := 7
                else
                    ImageIndex := 3
            else if tdata.remark <> '' then
                ImageIndex := 5
            else
                ImageIndex := 1;
    end;
end;

// *************** GETTEXT *************************
procedure TForm1.IltreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: String);
var
    tdata: ^rTreeData;
    txt, descr: String;
begin
    tdata := Sender.GetNodeData(Node);
    txt := tdata.XMLName;
    descr := tdata.Data;
    case Column of
        0:
            CellText := txt;
        1 .. 12:
            if Column = Integer(Sender.GetNodeLevel(Node)) then
            begin
                if txt = 'line' then
                begin
                    CellText := tdata.linenumber + ' ' + tdata.Data;
                end
                else
                    CellText := descr;
            end
            else
                CellText := '';
    end;
end;

// *************** SELECT **************************
procedure TForm1.IltreeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i: Integer;
    seldata: ^rTreeData;
begin
    ColorTextlines(false); // wipe old selection
    SelNodes := Iltree.GetSortedSelection(True);
    if SelNodes <> nil then
    begin
        seldata := Iltree.GetNodeData(SelNodes[0]);
        i := High(SelNodes);
        if i >= 0 then
        begin // if any selected
            ScrollToTextline(SelNodes[0]);
            if remarks.Visible then
                LoadRemarks;
            textbox.text := seldata.bookmark;
            ColorTextlines(True);
        end;
        // Form1.Repaint;
    end;
end;

// *************** KEYBOARD HANDLING ***************
procedure TForm1.IltreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
    Node: PVirtualNode;
begin
    case Key of // F2 (goto edit mode) is a functionality of Iltree itself
        VK_F3:
            if not remarks.Visible then
            begin
                LoadRemarks;
                remarks.Show;
                Panel1.Hide;
                Form1.Refresh;
                remarks.SetFocus;
                Key := 0;
            end else begin
                SaveRemarks;
                remarks.Visible := false;
                Panel1.Visible := True;
                Iltree.SetFocus;
                Key := 0;
                Form1.Refresh;
            end;
        VK_RETURN:
            begin
                Node := Iltree.GetFirstSelected;
                if Node <> nil then
                    Iltree.Expanded[Node] := not Iltree.Expanded[Node];
            end;
    end;
end;

procedure TForm1.IltreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
    i: Integer;
    tdata: ^rTreeData;
begin
    if not((Key = VK_UP) or (Key = VK_DOWN) or (Key = VK_F12)) then
        Exit;

    if Key = VK_F12 then
    begin
        Iltree.ScrollIntoView(Iltree.GetFirstSelected, True, True);
        Exit;
    end;
    ColorTextlines(false); // wipe old selection
    SelNodes := Iltree.GetSortedSelection(True);
    i := High(SelNodes);
    if i >= 0 then
    begin
        ScrollToTextline(SelNodes[0]);
        remarks.Clear;
        tdata := Iltree.GetNodeData(SelNodes[0]);
        remarks.text := tdata.remark;
        textbox.text := tdata.bookmark;
        // Form2.grid.Repaint;
        Form1.Repaint;
    end;
end;

procedure TForm1.IltreeIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: String;
  var Result: Integer);
var
    target, st: String;
    tdata: ^rTreeData;
    s, level, i: Integer;
    a: Char;
begin
    GreekHidden.Checked := false;
    st := '';
    tdata := Sender.GetNodeData(Node);
    if linesearch.Checked then
    begin
        for a in SearchText do
            st := st + convertchar(UpperCase(a));
        target := tdata.linenumber;
    end
    else if bkmarksearch.Checked then
    begin
        st := SearchText;
        target := tdata.bookmark;
    end
    else if capsearch.Checked then
    begin
        st := LowerCase(SearchText);
        target := LowerCase(tdata.Data);
    end;
    searchtextlbl.Caption := st;
    s := Length(st);
    if target = '' then
        Result := 1
    else
        Result := CompareStr(st, Copy(target, 1, s));
    if Result = 0 then
    begin
        SelNodes := Iltree.GetSortedSelection(True);
        for i := 0 to High(SelNodes) do
        begin
            Iltree.Selected[SelNodes[i]] := false;
            ColorTextlines(false); // deselect first...
        end; // ...we want only the LAST 'result=0' (char found) to determine the selection

        Iltree.VisiblePath[Node] := True; // not necessary?
        level := Iltree.GetNodeLevel(Node);
        while Levelcount < (level + 1) do
        begin
            UpLevelClick(Sender); // this sets levelcount
        end;

        Iltree.Selected[Node] := True;
        SelNodes := Iltree.GetSortedSelection(True);
        i := High(SelNodes);
        if i >= 0 then
            ColorTextlines(True);
        Iltree.ScrollIntoView(Node, True, True);

    end;
end;

function TForm1.convertchar(c: String): String;
var // latin to greek
    i: Integer;
begin
    i := Pos(c, Lalfabet);
    if i > 0 then
        Result := GRalfabet[i]
    else
        Result := c;
end;

// *************** EDITOR **(see editor.pas)*********
procedure TForm1.IltreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  out EditLink: IVTEditLink);
begin
    if Column = Integer(Sender.GetNodeLevel(Node)) then
        EditLink := TIltreeEditLink.Create;
end;

procedure TForm1.IltreeEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
    tdata: ^rTreeData;
begin
    tdata := Iltree.GetNodeData(Node);
    if tdata.Changed = True then
        is_changed.Checked := True;
    tdata.Changed := false;
end;

procedure TForm1.IltreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
    if Node.ChildCount = 0 then
        Allowed := True
    else if Column = Integer(Sender.GetNodeLevel(Node)) then
        Allowed := True
    else
        Allowed := false;
end;

// *************** LEVEL UP/DOWN *******************
procedure TForm1.IltreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
var
    level: Integer;
begin
    level := Sender.GetNodeLevel(Node);
    if level > Maxlevel then
        Maxlevel := level;
    if level > Levelcount - 2 then
        Allowed := false; // levelcount = n.of.columns
end;

procedure TForm1.IltreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
    TreeData: ^rTreeData;
begin
    TreeData := Sender.GetNodeData(Node);
    if TreeData <> nil then
        Finalize(TreeData^);
end;

procedure TForm1.DownLevelClick(Sender: TObject);
var
    tnode: PVirtualNode;
begin
    if (Levelcount - 1) <= HiddenCols then
        ShowcolBtnClick(nil); // first unhide
    // i := Iltree.FocusedColumn;
    // if i >= Levelcount then   // prevent column list out of bounds
    // Iltree.FocusedNode := Iltree.FocusedNode.Parent;

    try
        if Levelcount > 1 then
        begin
            Dec(Levelcount);
            Iltree.Header.Columns.Delete(Levelcount);
        end;
    except
        ShowMessage('downlevel column o.o. bounds');
    end;
    tnode := Iltree.RootNode.FirstChild;
    if (tnode <> nil) and (tnode.ChildCount <> 0) then
    begin
        Iltree.FullCollapse;
        if (GreekHidden.Checked) then
            notextlinesClick(NIL)
        else
            Form1.Iltree.FullExpand;
    end;
    if Levelcount = 1 then
    begin
        Iltree.Header.Columns[0].Options := Iltree.Header.Columns[0].Options + [coVisible];
        Iltree.FocusedNode := tnode; // ! otherwise column list out of bounds exc.
    end;
    FormResize(nil);
    Iltree.SetFocus;
    tnode := Iltree.GetFirstSelected;
    if tnode <> nil then
        Iltree.ScrollIntoView(tnode, True);
end;

procedure TForm1.ExpandbtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Expand highest level of the tree';
    UpLevelClick(Sender);
end;

procedure TForm1.UpLevelClick(Sender: TObject);
var
    tnode: PVirtualNode;
begin
    tnode := Iltree.RootNode.FirstChild;
    try
        if Levelcount <= Maxlevel then
        begin
            Iltree.Header.Columns.Insert(Levelcount);
            Iltree.Header.Columns[Levelcount].Options := Iltree.Header.Columns[Levelcount].Options + [coEnabled];
            Iltree.Header.Columns[Levelcount].text := IntToStr(Levelcount);
            Iltree.Header.Columns[Levelcount].CaptionAlignment := taCenter;
            Inc(Levelcount);
        end;
    except
        ShowMessage('column index error');
        Exit;
    end;
    if (tnode <> nil) and (tnode.ChildCount <> 0) then
    begin
        if (GreekHidden.Checked) then
            notextlinesClick(NIL)
        else
            Form1.Iltree.FullExpand;
    end;
    Iltree.SetFocus;
    tnode := Iltree.GetFirstSelected;
    if tnode <> nil then
        Iltree.ScrollIntoView(tnode, True, false);
    FormResize(nil);
end;

// *************** SHOW HIDE COLUMN ****************
procedure TForm1.HidecolBtnClick(Sender: TObject);
var
    i, cc: Integer;
begin
    StatusBar1.Panels[1].text := 'Hide leftmost column';
    cc := Iltree.Header.Columns.Count;
    if HiddenCols < (cc - 1) then
        Inc(HiddenCols);
    for i := 0 to HiddenCols - 1 do
        Iltree.Header.Columns[i].Options := Iltree.Header.Columns[i].Options - [coVisible];
    FormResize(nil);
end;

procedure TForm1.ShowcolBtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Unhide leftmost column';
    if HiddenCols > 0 then
        Dec(HiddenCols);
    Iltree.Header.Columns[HiddenCols].Options := Iltree.Header.Columns[HiddenCols].Options + [coVisible];
    FormResize(nil);
end;

// *************** INSERT DELETE NODES *************
procedure TForm1.InsertBtnClick(Sender: TObject);
var
    i, n, lvl: Integer;
    newnode: PVirtualNode;
    sourcenodes: TNodeArray;
    tdata: ^rTreeData;
    xml: String;
begin
    StatusBar1.Panels[1].text := 'insert parent node for selected nodes';
    sourcenodes := Iltree.GetSortedSelection(True);
    i := High(SelNodes); // SelNodes is set by IltreeMouseUp and -KeyUp
    if i >= 0 then
    begin
        Iltree.BeginUpdate;
        tdata := Iltree.GetNodeData(sourcenodes[0]);
        xml := tdata.XMLName;

        newnode := Iltree.InsertNode(sourcenodes[0], amInsertBefore);
        lvl := Iltree.GetNodeLevel(newnode);
        xml := 'lvl' + String(IntToStr(lvl));
        tdata := Iltree.GetNodeData(newnode);
        tdata.XMLName := xml;
        tdata.Data := 'fill in...';
        tdata.BGColor := DefaultBG;
        tdata.FGColor := DefaultFG;
        for n := 0 to i do
        begin
            Iltree.MoveTo(sourcenodes[n], newnode, amAddChildLast, false);
        end;
        Iltree.Expanded[newnode] := True;
        Iltree.EndUpdate;
        is_changed.Checked := True;
    end;

end;

procedure TForm1.deletebtnClick(Sender: TObject);
var
    i, n, delcount, ChildCount: Integer;
    nodetodel: PVirtualNode;
    sourcenodes: TNodeArray;
    tdata: ^rTreeData;
begin
    StatusBar1.Panels[1].text := 'delete selected node';
    sourcenodes := Iltree.GetSortedSelection(True);
    delcount := High(sourcenodes);
    tdata := Iltree.GetNodeData(sourcenodes[0]);
    if tdata.XMLName = 'line' then
    begin
        MessageDlg('Geen tekstregels verwijderen!', mtWarning, [mbOK], 0);
        Exit;
    end
    else if MessageDlg('Wil je deze echt verwijderen?', mtConfirmation, mbOKCancel, 0) = mrCancel then
        Exit;

    if delcount >= 0 then
    begin
        Iltree.BeginUpdate;
        for n := 0 to delcount do
        begin

            nodetodel := sourcenodes[n];
            Iltree.Selected[nodetodel] := false;
            ChildCount := nodetodel.ChildCount;
            if nodetodel.PrevSibling <> nil then
            begin // node to del has prev sibling
                for i := ChildCount - 1 downto 0 do
                begin
                    Iltree.MoveTo(sourcenodes[n].FirstChild, nodetodel.PrevSibling, amInsertAfter, false);
                end;
            end
            else if nodetodel.NextSibling <> nil then
            begin
                for i := 0 to ChildCount - 1 do
                begin
                    Iltree.MoveTo(sourcenodes[n].LastChild, nodetodel.NextSibling, amInsertBefore, false);
                end;
            end
            else // move to nodetodel.parent
                for i := 0 to ChildCount - 1 do
                    Iltree.MoveTo(sourcenodes[n].FirstChild, nodetodel.Parent, amAddChildLast, false);

            Iltree.FocusedNode := nodetodel.Parent;
            Iltree.Selected[nodetodel.Parent] := True;
            SelNodes := Iltree.GetSortedSelection(True); // update selection, for colortextlines()
            Iltree.DeleteNode(nodetodel);
        end; // end for nodes to del
        Iltree.EndUpdate;
        Iltree.Refresh;
        is_changed.Checked := True;
    end;
end;

// *************** DRAG & DROP **********************
procedure TForm1.IltreeDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin (* not from outside Iltree, no textlines *)
    Allowed := DragDropOK.Checked;
end;

procedure TForm1.IltreeDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var // drag + shift: insert after, + ctrl: insert before
    target: PVirtualNode;
    sourcenodes: TNodeArray;
    i: Integer;
    attm: TVTNodeAttachMode;
begin
    target := Iltree.DropTargetNode;
    sourcenodes := Sender.GetSortedSelection(True);
    if (ssCtrl in Shift) then
        attm := amInsertBefore
    else if (ssShift in Shift) then
        attm := amInsertAfter
    else exit;
    // if target.ChildCount = 0 then
    // attm := amAddChildLast; // drop on a childless node
    Iltree.BeginUpdate;
    if attm = amInsertAfter then
        for i := High(sourcenodes) downto 0 do
            Iltree.MoveTo(sourcenodes[i], target, attm, false)
    else
        for i := 0 to High(sourcenodes) do
            Iltree.MoveTo(sourcenodes[i], target, attm, false);
    Iltree.EndUpdate;
    is_changed.Checked := True;
end;

procedure TForm1.IltreeDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState;
  Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var // ok if same level or  previous level & no children
    target, src: PVirtualNode;
begin
    target := Iltree.DropTargetNode;
    src := Iltree.GetFirstSelected;
    if (Iltree.GetNodeLevel(target) = Iltree.GetNodeLevel(src)) or ((src.ChildCount = 0) and (target.ChildCount = 0))
    then
    begin
        // if (Iltree.GetNodeLevel(target) = Iltree.GetNodeLevel(src)) or
        // ((Iltree.GetNodeLevel(target) = Iltree.GetNodeLevel(src)-1) and
        // (target.ChildCount = 0))  then begin
        Accept := True;
        if ssCtrl in Shift then
            StatusBar1.Panels[1].text := 'dropping selected nodes BEFORE target'
        else if ssShift in Shift then
            StatusBar1.Panels[1].text := 'dropping selected nodes AFTER target'
        else Accept := False;
    end;
end;

// ***************** REMARKS ***********************
procedure TForm1.remarksEnter(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'showing Remarks';
    LoadRemarks;
end;

procedure TForm1.remarksExit(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'saving Remarks';
    SaveRemarks;
end;

procedure TForm1.ListButtonClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Saving XML';
    Iltree.Cursor := crHourGlass;
    Tree2XMLList(Iltree);
    Iltree.Cursor := crDefault;
    is_changed.Checked := false;
end;

procedure TForm1.LoadRemarks;
var
    tdata: ^rTreeData;
    tnode: PVirtualNode;
begin
    tnode := Iltree.GetFirstSelected;
    if tnode = nil then
        Exit;
    tdata := Iltree.GetNodeData(tnode);
    remarks.Clear;
    remarks.text := tdata.remark;
end;

procedure TForm1.SaveRemarks;
var
    tdata: ^rTreeData;
    tnode: PVirtualNode;
begin
    tnode := Iltree.GetFirstSelected;
    if tnode = nil then
        Exit;
    tdata := Iltree.GetNodeData(tnode);
    if tdata.remark <> remarks.text then
    begin
        tdata.remark := remarks.text;
        is_changed.Checked := True;
    end;
    tdata.rem := True;
end;

procedure TForm1.remarksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    case Key of
        VK_F3:
            begin
                SaveRemarks;
                remarks.Visible := false;
                Panel1.Visible := True;
                Form1.Refresh;
                Iltree.SetFocus;
            end;
        VK_ESCAPE:
            begin
                LoadRemarks;
                Iltree.SetFocus;
            end;
    end;
end;

// *************** BTN CLICKS **********************
procedure TForm1.ShowTextBtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Show/hide Greek text form';
    if ButlerForm.Visible then
    begin
        ButlerForm.Hide;
    end else begin
        ButlerForm.Show;
    end;
    // Iltree.SetFocus;
end;

// *************** LOAD & SAVE TREE ****************
procedure TForm1.savetreeClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Save tree in binary format (.undo file)';
    ProgressBar1.Position := 0;
    Iltree.Cursor := crHourGlass;
    TreeTop := Iltree.TopNode;
    Iltree.SaveToFile('iltree.undo');
    Iltree.Cursor := crDefault;
    ProgressBar1.Position := 0;//15683;
end;

procedure TForm1.GetTextLines(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var // write the text window
    tdata: ^rTreeData;
    item: TListItem;
begin
    tdata := Sender.GetNodeData(Node);
    if tdata.XMLName = 'line' then
    begin
        item := ButlerForm.GreekView.Items.Add;
        item.Caption := tdata.linenumber;
        item.SubItems.Add(tdata.Data);
        tdata.index := Linecount;
        // parentdata := Sender.GetNodeData(Node.Parent);
        ButlerForm.SetListColors(Linecount, Form1.DefaultFG, Form1.DefaultBG);
        ProgressBar1.Position := Linecount;
        Inc(Linecount);
    end;

end;

procedure TForm1.greekbuttonClick(Sender: TObject);
var
    result: TModalResult;
begin
    result := GreekSaveDialog.ShowModal;
    if result = mrNo then greek2html
    else if result = mrYes then greek2dat;

end;

procedure TForm1.GreekHiddenClick(Sender: TObject);
begin
    if (GreekHidden.Checked) then
    begin
        StatusBar1.Panels[1].text := 'Hide Greek textlines';
        notextlinesClick(nil)
    end else begin
        StatusBar1.Panels[1].text := 'Show Greek textlines';
        UpLevelClick(nil);
        DownLevelClick(nil);
    end;
end;

procedure TForm1.loadtreeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i, ok: Integer;
    filename: String;
begin
    ProgressBar1.Position := 0;
    if (ssShift in Shift) then
    begin
        StatusBar1.Panels[1].text := 'Loading .rescue-file';
        filename := 'iltree.rescue';
    end else begin
        StatusBar1.Panels[1].text := 'Loading .undo-file';
        filename := 'iltree.undo';
    end;
    StatusBar1.Panels[0].text := 'loaded: ' + ChooseDir.WorkDir + '/' + filename;
    if Iltree.TopNode.ChildCount > 0 then
    begin
        ok := MessageDlg('Tree not empty. Load a new one?', mtWarning, mbOKCancel, 0);
        if ok = mrCancel then
            Exit;
    end;
    if not FileExists(filename) then
    begin
        ShowMessage('no tree data to load' + #13 + #34 + filename + #34 + ' does not exist in this map');
        Exit;
    end;
    bookmarklist.Items.Clear;
    // ColorTextlines(false);
    if Iltree.Header.Columns.Count <> 1 then
    begin
        while HiddenCols >= 0 do
        begin
            Iltree.Header.Columns[HiddenCols].Options := Iltree.Header.Columns[HiddenCols].Options + [coVisible];
            Dec(HiddenCols);
        end;
        for i := Iltree.Header.Columns.Count - 1 downto 1 do
        begin
            Iltree.Header.Columns.Delete(i);
        end;
    end;
    Iltree.Clear;
    // Form2.grid.RowCount := 0;

    Iltree.LoadFromFile(filename);
    Linecount := 0;
    ButlerForm.GreekView.Items.Clear;
    Iltree.IterateSubtree(nil, GetTextLines, nil, [], True, false);
    Maxlines := Linecount;
    // ColorTextlines(True);
    for i := 0 to Iltree.Header.Columns.Count - 1 do
    begin
        Iltree.Header.Columns[i].text := IntToStr(i);
        Iltree.Header.Columns[i].CaptionAlignment := taCenter;
    end;

    if Iltree.GetFirstSelected <> nil then
    begin
        Iltree.ScrollIntoView(Iltree.GetFirstSelected, True, True);
    end;

    FormResize(nil);
    is_changed.Checked := false;
    ProgressBar1.Position := 0;
    // Form2.grid.Row := SaveScrollPos;
    // Form2.grid.Col := 1;
    // Form2.grid.SetFocus;
end;

procedure TForm1.IltreeSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Stream: TStream);
var
    tdata: ^rTreeData;
    size: Integer;
begin
    // save general state data with node 0
    if Iltree.AbsoluteIndex(Node) = 0 then
    begin
        Stream.Write(TreeTop, SizeOf(TreeTop));
        Stream.Write(Levelcount, SizeOf(Levelcount));
        Stream.Write(Maxlevel, SizeOf(Maxlevel));
        Stream.Write(HiddenCols, SizeOf(HiddenCols));
    end;
    begin
        tdata := Sender.GetNodeData(Node);

        size := Length(tdata.XMLName) * SizeOf(Char);
        // if size = 0 then size := 2;
        Stream.Write(size, SizeOf(size)); // store length of the string
        Stream.Write(PChar(tdata.XMLName)^, size); // now the string itself

        size := Length(tdata.linenumber) * SizeOf(Char);
        // if size = 0 then size := 2;
        Stream.Write(size, SizeOf(size));
        Stream.Write(PChar(tdata.linenumber)^, size);

        size := Length(tdata.Data) * SizeOf(Char);
        // if size = 0 then size := 2;
        Stream.Write(size, SizeOf(size));
        Stream.Write(PChar(tdata.Data)^, size);
        if size > 2 then
        begin
            ProgressBar1.Position := tdata.index;
        end;

        size := Length(tdata.remark) * SizeOf(Char);
        // if size = 0 then size := 2;
        Stream.Write(size, SizeOf(size));
        Stream.Write(PChar(tdata.remark)^, size);

        size := Length(tdata.bookmark) * SizeOf(Char);
        // if size = 0 then size := 2;
        Stream.Write(size, SizeOf(size));
        Stream.Write(PChar(tdata.bookmark)^, size);

        Stream.Write(tdata.BGColor, SizeOf(tdata.BGColor));
        Stream.Write(tdata.FGColor, SizeOf(tdata.FGColor));
        Stream.Write(tdata.Changed, SizeOf(tdata.Changed));
        Stream.Write(tdata.rem, SizeOf(tdata.rem));
        Stream.Write(tdata.italic, SizeOf(tdata.italic));
    end;
end;

procedure TForm1.IltreeStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode; Reason: TChangeReason);
begin
    if Iltree.TotalCount > 1 then
        is_changed.Checked := True;
end;

function ArrayToString(const a: array of Char): string;
begin
    if Length(a) > 0 then
        SetString(Result, PChar(@a[0]), Length(a))
    else
        Result := '';
end;

procedure TForm1.IltreeLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Stream: TStream);
var
    tdata: ^rTreeData;
    txt: array of Char;
    i, lcount, size: Integer;
begin
    if Iltree.AbsoluteIndex(Node) = 0 then
    begin
        Stream.Read(TreeTop, SizeOf(TreeTop));
        Stream.Read(Levelcount, SizeOf(Levelcount));
        Stream.Read(Maxlevel, SizeOf(Maxlevel));
        Stream.Read(HiddenCols, SizeOf(HiddenCols));
        lcount := Levelcount - 1;
        for i := 1 to lcount do
        begin
            Iltree.Header.Columns.Insert(i);
        end;
        for i := 0 to HiddenCols - 1 do
            Iltree.Header.Columns[i].Options := Iltree.Header.Columns[i].Options - [coVisible];
    end;
    // if vsSelected in Node.States then Iltree.Selected[ Node ] := True;

    tdata := Sender.GetNodeData(Node);
    Iltree.ValidateNode(Node, false); // to prevent memory leak. Nodes are only freed if validated (shown)
    Stream.Read(size, SizeOf(size));
    SetLength(txt, size div SizeOf(Char)); // size in Char
    Stream.Read(PChar(txt)^, size); // size in bytes
    tdata.XMLName := ArrayToString(txt);

    Stream.Read(size, SizeOf(size));
    SetLength(txt, size div SizeOf(Char));
    Stream.Read(PChar(txt)^, size);
    if size = 0 then
        tdata.linenumber := ''
    else
        tdata.linenumber := ArrayToString(txt);

    Stream.Read(size, SizeOf(size));
    SetLength(txt, size div SizeOf(Char));
    Stream.Read(PChar(txt)^, size);
    if size = 0 then
        tdata.Data := ''
    else
        tdata.Data := ArrayToString(txt);

    Stream.Read(size, SizeOf(size));
    SetLength(txt, size div SizeOf(Char));
    Stream.Read(PChar(txt)^, size);
    if size = 0 then
        tdata.remark := ''
    else
        tdata.remark := ArrayToString(txt);

    Stream.Read(size, SizeOf(size));
    SetLength(txt, size div SizeOf(Char));
    Stream.Read(PChar(txt)^, size);
    if size = 0 then
        tdata.bookmark := ''
    else
        tdata.bookmark := ArrayToString(txt);
    if (tdata.bookmark <> '') then
        bookmarklist.Items.Add(tdata.bookmark);

    Stream.Read(tdata.BGColor, SizeOf(tdata.BGColor));
    Stream.Read(tdata.FGColor, SizeOf(tdata.FGColor));
    Stream.Read(tdata.Changed, SizeOf(tdata.Changed));
    Stream.Read(tdata.rem, SizeOf(tdata.rem));
    Stream.Read(tdata.italic, SizeOf(tdata.italic));
end;

// *************** LOAD & SAVE XML *****************
procedure TForm1.loadxmlbtnClick(Sender: TObject);
var
    i, ok: Integer;
begin

    StatusBar1.Panels[1].text := 'Loading XML';
    if Iltree.TopNode.ChildCount > 0 then
    begin
        ok := MessageDlg('Tree not empty. Load a new one?', mtWarning, mbOKCancel, 0);
        if ok = mrCancel then
            Exit;
    end;

    if choosefile.Items[ choosefile.ItemIndex ] = 'browse' then
    begin
        OpenDialog1.Title := 'Loading Tree XML';
        if not OpenDialog1.Execute then
            Exit;
        XMLfilename := OpenDialog1.filename;
    end
    else begin
        XMLfilename := choosefile.Items[ choosefile.ItemIndex ];
    end;

    if not FileExists(XMLfilename) then
    begin
        ShowMessage('this filename does not exist in the working directory');
        Exit;
    end;
    while HiddenCols > 0 do
        ShowcolBtnClick(Sender);

    bookmarklist.Items.Clear;
    Iltree.Cursor := crHourGlass;
    Iltree.Refresh;
    if Iltree.Header.Columns.Count <> 1 then
    begin
        for i := Iltree.Header.Columns.Count - 1 downto 1 do
            Iltree.Header.Columns.Delete(i);
    end;
    Iltree.NodeDataSize := SizeOf(rTreeData);
    Linecount := 0;
    Levelcount := 1;
    Maxlevel := 2;
    HiddenCols := 0;
    Iltree.ResetNode(Iltree.GetFirst);
    XMLDocument1.filename := XMLfilename;;
    XMLDocument1.Active := True;
    XML2Tree(Iltree, XMLDocument1);
    Iltree.FullCollapse;
    XMLDocument1.Active := false;
    Iltree.Cursor := crDefault;
    is_changed.Checked := false;
    for i := 0 to Iltree.Header.Columns.Count - 1 do
    begin
        Iltree.Header.Columns[i].text := IntToStr(i);
        Iltree.Header.Columns[i].CaptionAlignment := taCenter;
    end;
    StatusBar1.Panels[0].text := 'Working with: ' + ChooseDir.WorkDir + '\' + XMLfilename;

    // Form2.grid.Row := 0;
    // Form2.grid.Col := 1;
    // Form2.grid.SetFocus;
end;

procedure TForm1.clearselbmMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    clearselbm.Color := clRed;
end;

procedure TForm1.clearselbmMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    Max, i: Integer;
    tdata: ^rTreeData;
    bm: String;
begin
    StatusBar1.Panels[1].text := 'delete selected bookmarks';
    SelNodes := Iltree.GetSortedSelection(True);
    Max := High(SelNodes);
    if Max >= 0 then
    begin
        for i := 0 to Max do
        begin
            tdata := Iltree.GetNodeData(SelNodes[i]);
            bm := tdata.bookmark;
            tdata.bookmark := '';
        end;
    end;
    clearselbm.Color := $006BACB8;
    Iltree.Refresh;
    for i := 0 to bookmarklist.Items.Count - 1 do
        if bookmarklist.Items[i] = bm then
            bookmarklist.Items.Delete(i);
end;

procedure TForm1.clrallbmMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    clrallbm.Color := clRed;
end;

procedure TForm1.clrallbmMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    StatusBar1.Panels[1].text := 'delete all bookmarks';
    Iltree.IterateSubtree(nil, clearbm, nil, [], false, false);
    bookmarklist.Items.Clear;
    clrallbm.Color := clTeal;
    Iltree.Refresh;
end;

procedure TForm1.collapsebtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Collapse highest level of the tree';
    DownLevelClick(Sender);
end;

procedure TForm1.clearbm(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
    tdata: ^rTreeData;
begin
    tdata := Iltree.GetNodeData(Node);
    tdata.bookmark := '';
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
    if linesearch.Checked then
        StatusBar1.Panels[1].text := 'typing -> linenumber search'
    else if bkmarksearch.Checked then
        StatusBar1.Panels[1].text := 'typing -> bookmark search'
    else if capsearch.Checked then
        StatusBar1.Panels[1].text := 'typing -> caption search';
    Iltree.SetFocus;
end;

procedure TForm1.savexmlbtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Saving XML';
    Iltree.Cursor := crHourGlass;
    Tree2XML(Iltree);
    Iltree.Cursor := crDefault;
    is_changed.Checked := false;
end;

procedure TForm1.autoloadClick(Sender: TObject);
begin
    if (autosave.State = cbChecked) then
        StatusBar1.Panels[1].text := 'Load XML at program start.'
    else
        StatusBar1.Panels[1].text := 'Do not load XML at program start.';
end;

procedure TForm1.autosaveClick(Sender: TObject);
begin
    if (autosave.State = cbChecked) then
        StatusBar1.Panels[1].text := 'Save XML at program exit.'
    else if (autosave.State = cbUnchecked) then
        StatusBar1.Panels[1].text := 'Do not save XML at program exit.'
    else
        StatusBar1.Panels[1].text := 'Ask to save XML at program exit.'
end;

procedure TForm1.bookmarkbtnClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'create new bookmark';
    EditingBookmark := True;
    textbox.Color := TColor($00D0CDC1);
    textbox.SetFocus;
end;

procedure TForm1.findbm(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
// callback from iteratesubtree - find bookmark
var
    tdata: ^rTreeData;
    i, Result, level: Integer;
    bm: String;
begin
    tdata := Iltree.GetNodeData(Node);
    bm := String(Data^);
    Result := CompareStr(tdata.bookmark, bm);
    if Result = 0 then
    begin
        Abort := True;
        Iltree.VisiblePath[Node] := True;
        Iltree.ScrollIntoView(Node, True);
        SelNodes := Iltree.GetSortedSelection(True);
        for i := 0 to High(SelNodes) do
        begin
            Iltree.Selected[SelNodes[i]] := false;
            ColorTextlines(false); // deselect first...
        end;
        level := Iltree.GetNodeLevel(Node);
        while Levelcount < (level + 1) do
        begin
            UpLevelClick(Sender); // this sets levelcount
        end;

        Iltree.Selected[Node] := True;
        SelNodes := Iltree.GetSortedSelection(True);
        i := High(SelNodes);
        if i >= 0 then
            ColorTextlines(True);
        Iltree.ScrollIntoView(Node, True, True);
    end;
end;

procedure TForm1.bookmarklistChange(Sender: TObject);
var
    s: String;
begin
    StatusBar1.Panels[1].text := 'goto chosen bookmark';
    s := bookmarklist.text;
    Iltree.IterateSubtree(nil, findbm, @s, [], false, false);
end;

procedure TForm1.notextlinesClick(Sender: TObject);
var
    tnode: PVirtualNode;
begin
    Iltree.FullExpand; // anders foutmelding
    Iltree.IterateSubtree(nil, hideLeaves, nil, [], false, false);
    Iltree.Refresh;
    tnode := Iltree.GetFirstSelected;
    if tnode <> nil then
        Iltree.ScrollIntoView(tnode, True, false);
end;

procedure TForm1.hideLeaves(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
    tdata: ^rTreeData;
begin
    if Node.ChildCount > 0 then
    begin
        tdata := Iltree.GetNodeData(Node.FirstChild);
        if tdata.linenumber <> '' then
        begin
            Iltree.Expanded[Node] := false;
        end;
        // else Iltree.Expanded[ Node ] := True;
    end;
end;

procedure TForm1.HTMLButtonClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Create HTML-file from XML tree';
    Tree2HTML;
end;

procedure TForm1.choosefileClick(Sender: TObject);
begin
    StatusBar1.Panels[0].text := 'Working with: ' + ChooseDir.WorkDir + '\' + choosefile.Items[choosefile.ItemIndex];
    StatusBar1.Panels[1].text := 'Load chosen xml/binary file';
end;

{ procedure TForm1.choosefileDropDown(Sender: TObject);
  var
  itemsFullWidth: integer;
  idx: integer;
  itemWidth: integer;
  begin
  itemsFullWidth := 0;

  // get the max needed width of the items in dropdown state
  for idx := 0 to -1 + choosefile.Items.Count do
  begin
  itemWidth := choosefile.Canvas.TextWidth(choosefile.Items[idx]);
  Inc( itemWidth, itemWidth div 2 ); // otherwise too small
  if (itemWidth > itemsFullWidth) then itemsFullWidth := itemWidth;
  end;

  // set the width of drop down if needed
  if (itemsFullWidth > choosefile.Width) then
  begin
  //check if there would be a scroll bar
  if choosefile.DropDownCount < choosefile.Items.Count then
  itemsFullWidth := itemsFullWidth + GetSystemMetrics(SM_CXVSCROLL);

  //SendMessage(choosefile.Handle, 352, itemsFullWidth, 0);
  end;
  end; }

procedure TForm1.choosefileMouseEnter(Sender: TObject);
begin
    choosefile.Hint := 'dir: ' + ChooseDir.WorkDir;
end;

// *************** CREATE DESTROY ******************
procedure TForm1.FormCreate(Sender: TObject);
begin
    // System.ReportMemoryLeaksOnShutdown := True;
    // no access to Form2 here!
    Settings := TStringList.Create;
    Form1.WindowState := wsNormal;
    is_changed.Checked := false;
    ChooseDir.HomeDir := GetCurrentDir;
    DragDropOK.Checked := false;

    if FileExists('iltree.inf') then
    begin
        Settings.LoadFromFile('iltree.inf');
        with Settings do
        begin
            ChooseDir.WorkDir := Values['workdir'];
            if not DirectoryExists(ChooseDir.WorkDir) then
                ChooseDir.WorkDir := ChooseDir.HomeDir;
            ButlerFileName := Values['butlerfile'];
            DefaultBG := StrToInt(Values['ilbgcolor']);
            DefaultFG := StrToInt(Values['ilfgcolor']);
            Form1.Left := StrToInt(Values['illeft']);
            Form1.Top := StrToInt(Values['iltop']);
            Form1.Width := StrToInt(Values['ilwidth']);
            Form1.Height := StrToInt(Values['ilheight']);
            Form1.Font.size := StrToInt(Values['ilfontsize']);
            SpinEdit1.Value := Form1.Font.size;
//            Form1.Font.name := Values['ilfont'];
            choosefile.Items.CommaText := 'browse,' + Values['ilfiles'];
            choosefile.ItemIndex := StrToInt(Values['ilfileindex']);
            autosave.State := TCheckBoxState(StrToInt(Values['autosave']));
            autoload.State := TCheckBoxState(StrToInt(Values['autoload']));
            GreekHidden.State := TCheckBoxState(StrToInt(Values['showleaves']));
        end;
    end else begin
        DefaultFG := Iltree.Font.Color;
        DefaultBG := Iltree.Color;
        ChooseDir.WorkDir := ChooseDir.HomeDir;
    end;

    StatusBar1.Panels[0].Width := StatusBar1.Width - 400;
    StatusBar1.Panels[1].Width := 400;

    SpinEdit1.OnChange := SpinEdit1Change;
    Iltree.NodeDataSize := SizeOf(rTreeData);
    Linecount := 0;
    Levelcount := 1;
    Maxlevel := 2;
    HiddenCols := 0;

    icons := TBitMap.Create;
    icons.LoadFromFile('checksbm.bmp');
    mask := TBitMap.Create;
    mask.LoadFromFile('checksbm_mask.bmp');
    ImageList1.Insert(0, icons, mask);

    Application.HintHidePause := 20000;

    ProgressBar1.Max := 15683;
    FormResize(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    XMLDocument1.Free;
    Iltree.OnFreeNode := IltreeFreeNode;
end;

// *************** FORMCLOSE ***********************

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if Iltree.RootNode.FirstChild.ChildCount = 0 then
        case MessageDlg('You really want to quit?', mtConfirmation, [mbYes, mbNo], 0) of
            mrYes:
                begin
                    CanClose := True;
                    StatusBar1.Panels[1].text := 'closing program';
                end;
            mrNo:
                begin
                    CanClose := false;
                end;
        end
    else if autosave.State = cbGrayed then
        case MessageDlg('Save tree items to XML?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
            mrYes:
                begin
                    StatusBar1.Panels[1].text := 'saving XML & closing';
                    Tree2XML(Iltree);
                end;
            mrNo:
                begin
                    StatusBar1.Panels[1].text := 'closing without saving XML';
                    CanClose := True;
                end;
            mrCancel:
                begin
                    StatusBar1.Panels[1].text := 'cancel closing';
                    CanClose := false;
                end;
        end
    else if autosave.State = cbUnchecked then
        Exit
    else
    begin
        StatusBar1.Panels[1].text := 'saving XML & closing';
        Tree2XML(Iltree);
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Settings.Values['workdir'] := ChooseDir.WorkDir;
    Settings.Values['butlerfile'] := ButlerFileName;
    Settings.Values['ilbgcolor'] := IntToStr(DefaultBG);
    Settings.Values['ilfgcolor'] := IntToStr(DefaultFG);
    Settings.Values['illeft'] := IntToStr(FormLeft);
    Settings.Values['iltop'] := IntToStr(FormTop);
    Settings.Values['ilwidth'] := IntToStr(FormWidth);
    Settings.Values['ilheight'] := IntToStr(FormHeight);
    //Settings.Values['ilmaximized'] := BoolToStr(Form1.WindowState = wsMaximized);
    Settings.Values['ilfontsize'] := IntToStr(Iltree.Font.size);
    //Settings.Values['ilfont'] := Iltree.Font.name;
    Settings.Values['ilfileindex'] := IntToStr(choosefile.ItemIndex);
    while choosefile.Items[0] = 'browse' do choosefile.Items.Delete(0);

    Settings.Values['ilfiles'] := choosefile.Items.CommaText;
    Settings.Values['autosave'] := IntToStr(Integer(autosave.State));
    Settings.Values['autoload'] := IntToStr(Integer(autoload.State));
    Settings.Values['showleaves'] := IntToStr(Integer(GreekHidden.State));

    Settings.SaveToFile(ChooseDir.HomeDir + '/iltree.inf');

    Settings.Destroy;
    icons.Destroy;
    mask.Destroy;

    // Form2.LookupList.Items.SaveToFile(ChooseDir.HomeDir + '/lookup.list');
end;

end.
