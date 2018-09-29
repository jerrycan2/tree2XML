unit outputs;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, xmldom, XMLIntf, msxmldom, XMLDoc, StrUtils, Vcl.StdCtrls,
    Vcl.ComCtrls, System.JSON.Types, System.JSON.Writers, System.JSON.Builders, System.JSON.Readers;


type
    TLinenumber = record
        chap: integer;
        line: integer;
    end;

type
    TTreeItemData = class
        tr_itemListindex: integer; // points to item in lv_Tree
        tr_itemLevel: integer; // from xml localname
        tr_itemHasChildren: boolean; // false for textlines
        tr_itemExpanded: boolean;
        tr_itemVisible: boolean;
        tr_itemItalic: boolean;
        tr_itemBGcolor: TAlphaColor;
        tr_itemFGcolor: TAlphaColor;
        tr_itemFirst: TLinenumber;
        tr_itemLast: TLinenumber;
        tr_itemGR: string; // Greek text if not HasChildren
        tr_itemEN: string; // NodeText if HasChildren, Butlertext alinea otherwise
        tr_itemREM: string; // remark
    end;

type
    TOutputForm = class(TForm)
        ProgressBar1: TProgressBar;
        SaveHtmlButton: TButton;
        StatusBar1: TStatusBar;
        ListButton: TButton;
    tempbutton: TButton;
        greekdatbutton: TButton;
        Button1: TButton;
        Button2: TButton;
    Memo1: TMemo;
        procedure SaveHtmlButtonClick(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure ListButtonClick(Sender: TObject);
        procedure Button1Click(Sender: TObject);
    procedure tempbuttonClick(Sender: TObject);
    private
        { Private declarations }
    public
        procedure ParseJSON;
        procedure Tree2JSON(tree: TVirtualStringTree);
        procedure Tree2XMLList(tree: TVirtualStringTree);
        procedure Tree2XML(tree: TVirtualStringTree);
        procedure Tree2HTML(tree: TVirtualStringTree); // create html collapsible list
        procedure greek2html(tree: TVirtualStringTree);
        procedure greek2dat(tree: TVirtualStringTree);
        function ColorString(kleur: TColor): string;
        function EscString(s: string): string;
    end;

var
    OutputForm: TOutputForm;

implementation

uses treeview, butlerview;
{$R *.dfm}

// ******************EscString***********************
function TOutputForm.EscString(s: string): string;
var
    i: integer;
    new: string;
begin
    for i := 0 to Length(s) - 1 do
    begin
        if s[i] = '&' then
        begin
            new := MidStr(s, 0, i - 1) + '&amp; ' + MidStr(s, i + 1, Length(s) - i);
            s := new;
        end;

    end;
    Result := s;
end;

procedure TOutputForm.FormResize(Sender: TObject);
begin
    StatusBar1.Panels[0].Width := StatusBar1.Width div 2;
    StatusBar1.Panels[1].Width := StatusBar1.Width - StatusBar1.Panels[0].Width;
end;
{$REGION 'JSON'}

procedure TOutputForm.Tree2JSON(tree: TVirtualStringTree);
var
    Writer: TJsonTextWriter;
    StringWriter: TStringWriter;
    globalcounter: integer;
    s: string;

    function VisitTreeItem(node: PVirtualNode): string;
    var
        tdata: ^rTreedata;
        level: integer;
    begin
        if node = nil then exit;

        while node <> nil do
        begin
            tdata := tree.GetNodeData(node);
            level := tree.GetNodeLevel(node);
            inc(globalcounter);
            Writer.WriteStartObject;
            Writer.WritePropertyName('item');
            Writer.WriteValue(globalcounter);
            Writer.WritePropertyName('level');
            Writer.WriteValue(level);
            Writer.WritePropertyName('children');
            Writer.WriteValue(node.ChildCount);
            Writer.WritePropertyName('lnr');
            Writer.WriteValue(tdata.line);
            Writer.WritePropertyName('bg');
            Writer.WriteValue(tdata.BGColor);
            Writer.WritePropertyName('fg');
            Writer.WriteValue(tdata.FGColor);
            Writer.WritePropertyName('text');
            Writer.WriteValue(tdata.Data);
            Writer.WritePropertyName('rem');
            Writer.WriteValue(tdata.remark);
            Writer.WriteEndObject;
            if node.ChildCount > 0 then VisitTreeItem(node.FirstChild);

            node := node.NextSibling;
        end;

    end;
     //------------------------------------------------------//
begin
    globalcounter := 0;
    StringWriter := TStringWriter.Create();
    Writer := TJsonTextWriter.Create(StringWriter);
    Writer.Formatting := TJsonFormatting.Indented;

    Writer.WriteStartObject;
    Writer.WritePropertyName('The Iliad');
    Writer.WriteStartArray;
    VisitTreeItem(tree.GetFirst);
    Writer.WriteEndArray;
    Writer.WriteEndObject;

    s := StringWriter.ToString;
    Memo1.Text := s;
    Memo1.Lines.SaveToFile('json.test');
    StringWriter.Destroy;
    Writer.Destroy;
end;

//procedure TOutputForm.ParseJSON;
//var
//  LIterator: TJSONIterator;
//  LJsonTextReader: TJsonTextReader;
//  FileStream: TFileStream;
//  LReader: TReader;
//begin
//  { Create the TFileStream object and the TReader used to read data from files. }
//  FileStream := TFileStream.Create
//    ('json.test', fmOpenRead);
//  { $FF = 255. Used in creating the TReader object as the second parameter : Buffer size. }
//  LReader := TReader.Create(FileStream, $FF);
//  LJsonTextReader := TJsonTextReader.Create(LReader);
//
//end;

{$ENDREGION}

{$REGION 'CLICKS'}

procedure TOutputForm.Button1Click(Sender: TObject);
begin
    ButlerForm.CreateNewDoc;
end;

function TOutputForm.ColorString(kleur: TColor): string;
var
    bstr: string;
    bg: Longint;
begin
    bg := ColorToRGB(kleur);
    bstr := IntToHex(bg, 6);
    Result := string(bstr);
end;


procedure TOutputForm.ListButtonClick(Sender: TObject);
begin
    Tree2JSON(Form1.Iltree);
end;

procedure TOutputForm.SaveHtmlButtonClick(Sender: TObject);
begin
    StatusBar1.Panels[1].text := 'Create HTML-file from XML tree';
    Tree2HTML(Form1.Iltree);
end;

procedure TOutputForm.tempbuttonClick(Sender: TObject);
var
    list: TStringList;
    n: integer;
begin
    list := TStringList.Create;
    list.LoadFromFile('greek_il.json');

    list.Destroy;
end;

{$ENDREGION}
{$REGION 'OLD PROCS'}
//Result := GreekSaveDialog.ShowModal;
// if result = mrNo then greek2html
// else if result = mrYes then greek2dat;

// *************** TREE2XMLList for use by site index.html ************************
procedure TOutputForm.Tree2XMLList(tree: TVirtualStringTree);
var
    tn: PVirtualNode;
    XMLDoc: TXMLDocument;
    iNode: IXMLNode;
    td: ^rTreeData;
    text, name, colstr: string;
    kleur: TColor;
    totalsize: integer; // if ok, number of lines in the Iliad
    function ProcessTreeItem(treechildnode: PVirtualNode; XMLparentNode: IXMLNode): integer;
    var // node has Greek text IFF it's a leaf
        XMLchildNode: IXMLNode;
        text: string;
        tdata, ttemp: ^rTreeData;
        nodetemp: PVirtualNode;
        i: integer;
        linenumber, chap, line: string;
        lvl: integer;
        size: integer; // number of textlines the node refers to
    begin
        if (treechildnode = nil) then
        begin
            Result := 0;
            Exit;
        end;

        tdata := tree.GetNodeData(treechildnode);
        lvl := tree.GetNodeLevel(treechildnode);

        if tdata.XMLName = 'line' then
        begin
            name := 'line'; // leaf. keep this name!
            XMLchildNode := XMLparentNode.AddChild(name); // --
            ProgressBar1.Position := tdata.index;
        end else begin
            name := 'lvl' + string(IntToStr(lvl));
            XMLchildNode := XMLparentNode.AddChild(name);

            nodetemp := treechildnode;
            ttemp := tree.GetNodeData(nodetemp);
            while ttemp.line = '' do
            begin // go get chapter+linenr (line empty except leaves)
                nodetemp := nodetemp.FirstChild; // line contains chapter+linenr (A 1 etc)
                ttemp := tree.GetNodeData(nodetemp);
            end;
            chap := Copy(ttemp.line, 1, 1);
            line := Copy(ttemp.line, 2);
            i := Pos(chap, GRalfabet); // letter to index
            linenumber := string(IntToStr(i)) + '.' + line;
            XMLchildNode.Attributes['ln'] := linenumber;
        end;
        size := 0;
        if treechildnode.ChildCount > 0 then // if not a leaf, then...
        begin
            text := tdata.Data;
            if text <> '' then
            begin
                XMLchildNode.Attributes['d'] := text;
            end else begin
                if (lvl >= 1) and (name <> 'line') then XMLchildNode.Attributes['d'] := 'descr';
            end;
            kleur := tdata.BGColor;
            colstr := ColorString(kleur);
            colstr := colstr.Substring(4, 2) + colstr.Substring(2, 2) + colstr.Substring(0, 2);
            if (kleur <> Form1.DefaultBG) then
            begin
                XMLchildNode.Attributes['c'] := colstr;
            end;
            kleur := tdata.FGColor;
            colstr := ColorString(kleur);
            colstr := colstr.Substring(4, 2) + colstr.Substring(2, 2) + colstr.Substring(0, 2);
            if (kleur <> Form1.DefaultFG) then
            begin
                XMLchildNode.Attributes['f'] := colstr;
            end;

            // if tdata.remark <> '' then XMLchildNode.Attributes[ 'rem' ] := tdata.remark;
        end else begin // leaf
            size := 1;
            XMLchildNode.text := tdata.Data; // --
        end;
        // child nodes, depth first
        treechildnode := treechildnode.FirstChild;
        while treechildnode <> nil do
        begin
            size := size + ProcessTreeItem(treechildnode, XMLchildNode);
            treechildnode := treechildnode.NextSibling;
        end;
        if size > 1 then XMLchildNode.Attributes['sz'] := IntToStr(size);
        Result := size;
    end; (* local ProcessTreeItem *)

// *************************************************
begin (* Tree2XMLList (same as tree2xml but without greek text & some changes) *)
    ProgressBar1.Position := 0;

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := True;
    tn := tree.GetFirst;
    td := tree.GetNodeData(tn);
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
    ProgressBar1.Position := 0;
end; (* Tree2XMLList *)

// *************************************************
// *************************************************

procedure TOutputForm.Tree2XML(tree: TVirtualStringTree);
var
    tn: PVirtualNode;
    XMLDoc: TXMLDocument;
    iNode: IXMLNode;
    td: ^rTreeData;
    text, name: string;
    kleur: TColor;
    totalsize: integer; // if ok, number of lines in the Iliad
    function ProcessTreeItem(treechildnode: PVirtualNode; XMLparentNode: IXMLNode): integer;
    var // node has Greek text IFF it's a leaf
        XMLchildNode: IXMLNode;
        text: string;
        tdata: ^rTreeData;
        lvl: integer;
        size: integer; // number of textlines the node refers to
    begin
        if (treechildnode = nil) then
        begin
            Result := 0;
            Exit;
        end;
        tdata := tree.GetNodeData(treechildnode);
        lvl := tree.GetNodeLevel(treechildnode);

        if tdata.XMLName = 'line' then
        begin
            name := 'line'; // leaf. keep this name!
            ProgressBar1.Position := tdata.index;
        end
        else name := 'lvl' + string(IntToStr(lvl));

        size := 0;
        XMLchildNode := XMLparentNode.AddChild(name);
        if treechildnode.ChildCount > 0 then // if not a leaf, then...
        begin
            text := tdata.Data;
            if text <> '' then
            begin
                XMLchildNode.Attributes['d'] := text;
            end else begin
                if (lvl >= 1) and (name <> 'line') then XMLchildNode.Attributes['d'] := 'descr';
            end;
            kleur := tdata.BGColor;
            if (kleur <> Form1.DefaultBG) then XMLchildNode.Attributes['c'] := ColorString(kleur);
            kleur := tdata.FGColor;
            if (kleur <> Form1.DefaultFG) then XMLchildNode.Attributes['f'] := ColorString(kleur);

            if tdata.remark <> '' then XMLchildNode.Attributes['rem'] := tdata.remark;
            if tdata.italic then XMLchildNode.Attributes['ital'] := '1';

        end else begin // leaf
            XMLchildNode.NodeValue := tdata.Data;
            XMLchildNode.Attributes['ltr'] := Copy(tdata.line, 1, 1);
            XMLchildNode.Attributes['nr'] := Copy(tdata.line, 2);
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
        if size > 1 then XMLchildNode.Attributes['sz'] := IntToStr(size);
        Result := size;
    end; // local ProcessTreeItem

// *************************************************
begin // Tree2XML
    ProgressBar1.Position := 0;

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := True;
    tn := tree.GetFirst;
    td := tree.GetNodeData(tn);
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
    XMLfilename := Form1.choosefile.Items[Form1.choosefile.ItemIndex];
    if not XMLDoc.IsEmptyDoc then
    begin
        Form1.RenameBackups(XMLfilename);
        XMLDoc.SaveToFile(XMLfilename);
    end;
    ProgressBar1.Position := 0;
end; // Tree2XML

// *************** TREE2HTML ************************
procedure TOutputForm.Tree2HTML(tree: TVirtualStringTree); // create html collapsible list
var
    TekstBuf: TStringList;
    txt: string;
    chap, line, linenumber: string;
    i: integer;
    s, bstr, fstr: string;

    procedure walk(Node: PVirtualNode);
    var
        td, ttemp: ^rTreeData;
        nodetemp: PVirtualNode;
        lvl: integer;
        empty: boolean;
    begin
        if Node <> nil then
        begin
            lvl := tree.GetNodeLevel(Node);
            txt := '<ol';
            if lvl <= 8 then
            begin // level class id's voor html DOM manipulatie
                case lvl of
                    0: txt := txt + ' class="v0">';
                    1: txt := txt + ' class="v1">';
                    2: txt := txt + ' class="v2">';
                    3: txt := txt + ' class="v3">';
                    4: txt := txt + ' class="v4">';
                    5: txt := txt + ' class="v5">';
                    6: txt := txt + ' class="v6">';
                    7: txt := txt + ' class="v7">';
                    8: txt := txt + ' class="v8">';
                end;
            end else begin
                txt := txt + '>';
            end;
            TekstBuf.Add(txt);

            empty := True;
            repeat
                td := tree.GetNodeData(Node);
                ttemp := td;
                nodetemp := Node;
                txt := '';
                while ttemp.line = '' do
                begin // go get chapter+linenr (line empty except leaves)
                    nodetemp := nodetemp.FirstChild; // line contains chapter+linenr (A 1 etc)
                    ttemp := tree.GetNodeData(nodetemp);
                end;
                chap := Copy(ttemp.line, 1, 1);
                line := Copy(ttemp.line, 2);
                i := Pos(chap, GRalfabet); // letter to index
                linenumber := '[' + string(IntToStr(i)) + '.' + line + ']';
                // len := 8 - Length( linenumber );
                // for n := 1 to len do begin
                // linenumber := linenumber + '&nbsp;'; // align levels on page
                // end;
                txt := '<span class="ln">' + linenumber + '</span>';
                if td.line = '' then // exclude the greek text, too cumbersome otherwise
                begin
                    empty := false;
                    TekstBuf.Add('<li>');
                    TekstBuf.Add(txt);
                    bstr := ColorString(td.BGColor);
                    bstr := bstr.Substring(4, 2) + bstr.Substring(2, 2) + bstr.Substring(0, 2);
                    fstr := ColorString(td.FGColor);
                    fstr := fstr.Substring(4, 2) + fstr.Substring(2, 2) + fstr.Substring(0, 2);
                    s := '<span style="color: #' + fstr + '; background-color: #' + bstr + '">';
                    TekstBuf.Add(string(s));
                    if lvl = 0 then txt := ' The Iliad '
                    else txt := '&nbsp;' + EscString(td.Data) + '&nbsp;';
                    TekstBuf.Add(txt);
                    TekstBuf.Add('</span>');
                    if Node.ChildCount <> 0 then
                    begin
                        ttemp := tree.GetNodeData(Node.FirstChild);
                        if ttemp.line = '' then TekstBuf.Add('<span>&nbsp;<b>+</b></span>');
                        walk(Node.FirstChild);
                    end;
                    TekstBuf.Add('</li>');
                end
                else ProgressBar1.Position := td.index;
                Node := Node.NextSibling;
            until Node = nil;
            if not empty then TekstBuf.Add('</ol>')
            else TekstBuf.Delete(TekstBuf.Count - 1);
        end;
    end;

begin
    TekstBuf := TStringList.Create;
    // TekstBuf.Add( '<h1>Semantic Structure</h1>' );
    ProgressBar1.Position := 0;

    walk(tree.GetFirst); // create the <OL> part of the html file

    TekstBuf.SaveToFile('list.html');
    TekstBuf.Destroy;
    ProgressBar1.Position := 0;
end;

// ****************** GREEK HTML ********************
procedure TOutputForm.greek2html(tree: TVirtualStringTree);
var
    TekstBuf: TStringList;
    c, currchap: string;

    procedure walk(Node: PVirtualNode);
    var
        tdata: ^rTreeData;
        txt, lineID: string;
    begin
        if Node = nil then Exit;
        txt := '';
        lineID := '';
        repeat
            if Node.ChildCount > 0 then walk(Node.FirstChild)
            else
            begin
                tdata := Node.GetData;
                if lineID = '' then
                begin
                    lineID := tdata.line;
                    c := lineID.Substring(0, 1);
                    if currchap <> c then
                    begin
                        currchap := c;
                        TekstBuf.Add('<h4>Book ' + IntToStr(GRalfabet.IndexOf(c) + 1) + '</h4>');
                    end;
                end;
                txt := txt + tdata.Data + '<br>' + sLineBreak;
            end;
            Node := Node.NextSibling;
        until Node = nil;
        if lineID <> '' then TekstBuf.Add('<p><a>' + lineID + '</a>' + txt + '</p>');
    end;

begin
    TekstBuf := TStringList.Create;
    // TekstBuf.Add( '<h1>Semantic Structure</h1>' );
    ProgressBar1.Position := 0;
    currchap := #0;

    walk(tree.GetFirst); // create the <OL> part of the html file

    TekstBuf.SaveToFile('greeklist.html', TEncoding.UTF8);
    TekstBuf.Destroy;
    ProgressBar1.Position := 0;
end;

// ****************** GREEK_IL.DAT ********************
procedure TOutputForm.greek2dat(tree: TVirtualStringTree);
var
    TekstBuf: TStringList;
    c, currchap: string;

    procedure walk(Node: PVirtualNode);
    var
        tdata: ^rTreeData;
        txt, lineID: string;
    begin
        if Node = nil then Exit;
        txt := '';
        lineID := '';
        repeat
            if Node.ChildCount > 0 then walk(Node.FirstChild)
            else
            begin
                tdata := Node.GetData;
                if lineID = '' then
                begin
                    lineID := tdata.line;
                    c := lineID.Substring(0, 1);
                    if currchap <> c then
                    begin
                        currchap := c;
                        TekstBuf.Add('Book ' + IntToStr(GRalfabet.IndexOf(c) + 1));
                    end;
                end;
                txt := txt + tdata.Data + sLineBreak;
            end;
            Node := Node.NextSibling;
        until Node = nil;
        if lineID <> '' then TekstBuf.Add(lineID + ' ' + txt);
    end;

begin
    TekstBuf := TStringList.Create;
    TekstBuf.LineBreak := #1;
    ProgressBar1.Position := 0;
    currchap := #0;

    walk(tree.GetFirst);

    TekstBuf.SaveToFile('greeklist.txt', TEncoding.UTF8);
    TekstBuf.Destroy;
    ProgressBar1.Position := 0;
end;
{$ENDREGION}
end.
