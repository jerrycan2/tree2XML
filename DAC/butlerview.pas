unit butlerview;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.IOUtils,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom, Xml.XMLIntf, Vcl.ExtCtrls, Vcl.ComCtrls, Xml.XMLDoc,
    Xml.Win.msxmldom, System.Diagnostics, System.Generics.Collections, Vcl.StdCtrls, System.UITypes, Vcl.Menus,
    helpscreen, compareform, Vcl.Buttons;

type
    TListColor = record
        FG, BG: TColor;
    end;

type
    TLinenumber = record
        line: integer;
        chap: integer;
    end;

type
    undo_type = (u_set, u_merge, u_split);

type
    TIDtype = (id_alf, id_num);

type
    TLine = record
    private
        ln: TLinenumber;
        procedure setln(const l: integer);
        function getln: integer;
        procedure setch(const l: integer);
        function getch: integer;
        procedure setdata(const lnr: TLinenumber);
        function getdata: TLinenumber;
    public
        class operator Equal(a: TLine; b: TLine): boolean;
        class operator GreaterThan(a: TLine; b: TLine): boolean;
        class operator LessThan(a: TLine; b: TLine): boolean;
        class operator LessThanOrEqual(a: TLine; b: TLine): boolean;
        class operator GreaterThanOrEqual(a: TLine; b: TLine): boolean;

    var
    const
        GRalfabet: String = ('ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ');
        chaplen: array [1 .. 24] of integer = // iliad book lengths
          (611, 877, 461, 544, 909, 529, 482, 561, 709, 579, 847, 471, 837, 521, 746, 867, 761, 617, 424, 503, 611, 515,
          897, 804);
        property chap: integer read getch write setch;
        property line: integer read getln write setln;
        property data: TLinenumber read getdata write setdata;
        function previous: TLine;
        function next: TLine;
        procedure zero;
        procedure SetFromID(s: string);
        function GetID(idtype: TIDtype): string;
        function is_firstline: boolean;
        function is_lastline: boolean;
    end;

type
    TCard = class
    private
        cf: TLine;
        cl: TLine;
        t: string;
        procedure setfirst(const Value: TLine);
        procedure setlast(const Value: TLine);
        procedure SetText(const Value: string);
    public
        property first: TLine read cf write setfirst;
        property last: TLine read cl write setlast;
        property text: string read t write SetText;
    end;

type
    TUndoRec = class
        thisfirst, thislast, nextfirst, nextlast, prevfirst, prevlast: TLine;
        thistext, nexttext, prevtext: string;
        cardindex: integer;
        actiontype: undo_type;
    end;

type
    TButlerForm = class(TForm)
        MainMenu1: TMainMenu;
        file1: TMenuItem;
        load1: TMenuItem;
        save1: TMenuItem;
        OpenDialog1: TOpenDialog;
        check1: TMenuItem;
        Panel2: TPanel;
        GreekView: TListView;
        undobutton: TButton;
        splitbutton: TButton;
        mergebutton: TButton;
        Button2: TButton;
    helpbutton: TBitBtn;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    nextMemo: TMemo;
    nextPanel: TPanel;
    thisMemo: TMemo;
    thisPanel: TPanel;
    prevMemo: TMemo;
    prevPanel: TPanel;
    Splitter1: TSplitter;
    uncheckAll: TPanel;
        procedure FormCreate(Sender: TObject);
        procedure GreekViewSelectItem(Sender: TObject; Item: TListItem; Selected: boolean);
        procedure FormDestroy(Sender: TObject);
        function searchLine(ln: TLine): TListItem;
        function searchCard(ln: TLine): integer;
        procedure ClearCheckStack;
        procedure GreekViewCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: integer;
          State: TCustomDrawState; var DefaultDraw: boolean);
        procedure setchecks(first, last: TLine);
        procedure prevPanelClick(Sender: TObject);
        procedure nextPanelClick(Sender: TObject);
        procedure thisPanelClick(Sender: TObject);
        procedure SetListColors(itemindex: integer; FG, BG: TColor);
        procedure GreekViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
          var DefaultDraw: boolean);
        procedure FormResize(Sender: TObject);
        procedure ScrollTo(index: integer);
        procedure loadButlerXMLClick(Sender: TObject);
        procedure save1Click(Sender: TObject);
        procedure CreateNewDoc;
        procedure SetButtonClick(Sender: TObject);
        procedure printlines(p: TPanel; c: TCard);
        procedure CheckButlerText;
        procedure check1Click(Sender: TObject);
        procedure splitbuttonClick(Sender: TObject);
        procedure mergebuttonClick(Sender: TObject);
        procedure undobuttonClick(Sender: TObject);
        procedure LoadCardsFromXML;
    procedure helpbuttonClick(Sender: TObject);
    procedure load1Click(Sender: TObject);
    procedure uncheckAllClick(Sender: TObject);
    private
        cards: TObjectList<TCard>;
        CheckedItemStack: TStack<TListItem>;
        CurrentCardNr: integer;
        GreekColor: TColor;
        DefaultColor: TColor;
        ListItemHeight: integer;
        ListColors: array of TListColor;
        UndoStack: TStack<TUndoRec>;
        ButlerXMLDoc: TXMLDocument;

    end;

var
    ButlerForm: TButlerForm;

implementation

uses treeview;
{$R *.dfm}

procedure TLine.setln(const l: integer);
begin
    ln.line := l;
end;

function TLine.getln: integer;
begin
    result := ln.line;
end;

procedure TLine.setch(const l: integer);
begin
    ln.chap := l;
end;

function TLine.getch: integer;
begin
    result := ln.chap;
end;

procedure TLine.setdata(const lnr: TLinenumber);
begin
    ln := lnr;
end;

function TLine.getdata: TLinenumber;
begin
    result := ln;
end;

function TLine.is_firstline: boolean;
begin
    if (ln.chap = 1) and (ln.line = 1) then Result := true
    else Result := False;
end;

function TLine.is_lastline: boolean;
begin
    if (ln.chap = 24) and (ln.line = chaplen[24]) then Result := true
    else Result := False;
end;

procedure TCard.setfirst(const Value: TLine);
begin
    cf := Value;
end;

procedure TCard.setlast(const Value: TLine);
begin
    cl := Value;
end;

procedure TCard.SetText(const Value: string);
begin
    t := Value;
end;

// procedure TCard.SetEqualTo(const Value: TCard);
// begin
// cf := Value.cf;
// cl := Value.cl;
// t := Value.t;
// end;

class operator TLine.Equal(a: TLine; b: TLine): boolean;
begin
    result := (a.chap = b.chap) and (a.line = b.line);
end;

class operator TLine.GreaterThan(a: TLine; b: TLine): boolean;
begin
    result := ((a.chap > b.chap) or ((a.chap = b.chap) and (a.line > b.line)));
end;

class operator TLine.LessThan(a: TLine; b: TLine): boolean;
begin
    result := ((a.chap < b.chap) or ((a.chap = b.chap) and (a.line < b.line)));
end;

class operator TLine.LessThanOrEqual(a: TLine; b: TLine): boolean;
begin
    result := not(a > b);
end;

class operator TLine.GreaterThanOrEqual(a: TLine; b: TLine): boolean;
begin
    result := not(a < b);
end;

procedure TLine.zero;
begin
    ln.line := 0;
    ln.chap := 0;
end;

function TLine.previous: TLine; // by val
var
    lnr: TLine;
begin
    lnr.data := ln;
    lnr.line := lnr.line - 1;
    if lnr.line = 0 then
    begin
        lnr.chap := lnr.chap - 1;
        lnr.line := chaplen[lnr.chap];
    end;
    result := lnr;
end;

function TLine.next: TLine;
var
    lnr: TLine;
begin
    lnr.data := ln;
    lnr.line := lnr.line + 1;
    if lnr.line > chaplen[lnr.chap] then
    begin
        lnr.chap := lnr.chap + 1;
        lnr.line := 1;
    end;
    result := lnr;
end;

procedure TLine.SetFromID(s: string);
var
    pos, letterindex: integer;
begin
    try
        letterindex := GRalfabet.IndexOf(s.Substring(0, 1));
        if letterindex >= 0 then
        begin
            Self.chap := letterindex + 1;
            pos := 0;
        end else begin
            pos := s.IndexOf('.');
            if pos >= 0 then
                Self.chap := StrToInt(s.Substring(0, pos))
            else
                raise Exception.Create('');
        end;
        Self.line := StrToInt(s.Substring(pos + 1));
    except
        ShowMessage('Not a line number: ' + s);
        Self.chap := 0;
        Self.line := 0;
    end;
end;

function TLine.GetID(idtype: TIDtype): string;
begin
    if idtype = id_alf then
    begin
        result := Self.GRalfabet[Self.chap];
    end else begin
        result := IntToStr(Self.chap) + '.';
    end;
    result := result + IntToStr(Self.line);
end;

// ********************************************************************
// ********************BUTLERFORM**************************************
// ********************************************************************
procedure TButlerForm.FormCreate(Sender: TObject);
var
    Item: TListItem;
    rect: TRect;
begin
{$IFDEF Debug}
    System.ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
    Font.Name := Form1.Font.Name;
    cards := TObjectList<TCard>.Create;
    cards.OwnsObjects := True;
    CheckedItemStack := TStack<TListItem>.Create;
    UndoStack := TStack<TUndoRec>.Create;
    cards.Capacity := 8000;
    SetLength(ListColors, 16000);
    GreekColor := $0079E1BF;
    DefaultColor := $00C695B4;
    loadButlerXMLClick(nil);
    // get itemheight:
    Item := GreekView.Items.Add;
    Item.Caption := '0.0';
    Item.SubItems.Add('greek text'); // dummy list entry
    rect := GreekView.Items[0].DisplayRect(drBounds);
    ListItemHeight := rect.Height;
end;

procedure TButlerForm.FormDestroy(Sender: TObject);
begin
    if UndoStack.Count > 0 then
    begin
        CreateNewDoc;
        while UndoStack.Count > 0 do
            UndoStack.Pop.Free;
    end;
    UndoStack.Free;
    cards.Free;
    CheckedItemStack.Free;
end;

procedure TButlerForm.FormResize(Sender: TObject);
var
    h, w, fs: integer;
begin
    fs := Form1.SpinEdit1.Value;
    Font.Size := fs;
    Top := Form1.Top;
    Height := Form1.Height;
    w := Screen.Width - (Form1.Left + Form1.Width + 10);
    if w < 400 then
    begin
        Width := 400;
        tile;
    end else begin
        Width := w;
        Left := Screen.Width - (w + 5);
    end;
    h := (Height div 3) - thisPanel.Height;
    thisMemo.Height := h;
    nextMemo.Height := h;
    prevMemo.Height := h;
    StatusBar1.Panels[0].Width := StatusBar1.Width div 2;
    StatusBar1.Panels[1].Width := StatusBar1.Width - StatusBar1.Panels[0].Width;

end;

procedure TButlerForm.SetButtonClick(Sender: TObject);
var
    startcardindex: integer;
    checking: TLine;
    new_card_first, new_card_last: TLine;
    Item: TListItem;
    bottom: boolean;
    undorec: TUndoRec;
begin
    if (CurrentCardNr = 0) or (CurrentCardNr = cards.Count - 1) then
    begin
        ShowMessage('Not on the first or the last item');
        exit;
    end;

    undorec := TUndoRec.Create;
    undorec.thisfirst := cards[CurrentCardNr].first;
    undorec.thislast := cards[CurrentCardNr].last;
    undorec.thistext := cards[CurrentCardNr].text;
    undorec.nextfirst := cards[CurrentCardNr+1].first;
    undorec.nextlast := cards[CurrentCardNr+1].last;
    undorec.nexttext := cards[CurrentCardNr+1].text;
    undorec.prevfirst := cards[CurrentCardNr-1].first;
    undorec.prevlast := cards[CurrentCardNr-1].last;
    undorec.prevtext := cards[CurrentCardNr-1].text;
    undorec.actiontype := undo_type.u_set;
    undorec.cardindex := CurrentCardNr;
    UndoStack.Push(undorec);
    undobutton.Caption := IntToStr(UndoStack.Count);

    new_card_first.zero;
    new_card_last.zero;
    checking := cards[CurrentCardNr + 1].last; // 0 < CurrentCardNr < cards.Count-1
    Item := searchLine(checking);
    while Item.Checked = false do
    begin
        checking := checking.previous;
        if (checking < cards[CurrentCardNr - 1].first) then exit;
        Item := searchLine(checking);
    end;
    bottom := False;
    while Item.Checked = True do
    begin
        if new_card_last.chap = 0 then
        begin
            new_card_last := checking;
        end;
        new_card_first := checking;
        CheckedItemStack.Push(Item);
        if (checking = cards[CurrentCardNr - 1].first) or (checking.is_firstline) then
        begin
            bottom := True;
            break;
        end;
        checking := checking.previous;
        Item := searchLine(checking);
    end;
    if bottom and (not checking.is_firstline) and (searchLine(checking.previous).Checked = True) then
    begin
        ShowMessage('checkmarks out of range');
        ClearCheckStack;
        exit;
    end;

    while checking >= cards[CurrentCardNr - 1].first do
    begin
        Item := searchLine(checking);
        if Item.Checked then
        begin
            ShowMessage('non-consecutive checkmarks');
            ClearCheckStack;
            exit;
        end;
        checking := checking.previous;
    end;
    // now we have a stack of consec. checked items
    if not(new_card_first.previous = cards[CurrentCardNr - 1].last) then
    begin
        cards[CurrentCardNr].first := new_card_first;
        cards[CurrentCardNr - 1].last := new_card_first.previous;
    end;
    if not(new_card_last.next = cards[CurrentCardNr + 1].first) then
    begin
        cards[CurrentCardNr].last := new_card_last;
        cards[CurrentCardNr + 1].first := new_card_last.next;
    end;
    cards[CurrentCardNr].text := thisMemo.text;
    cards[CurrentCardNr - 1].text := prevMemo.text;
    cards[CurrentCardNr + 1].text := nextMemo.text;
    GreekViewSelectItem(nil, searchLine(new_card_first), false);
    StatusBar1.Panels[1].Text := 'set: ' + cards[CurrentCardNr].first.GetID(id_num);
end;

procedure TButlerForm.ClearCheckStack;
var
    Item: TListItem;
begin
    while CheckedItemStack.Count > 0 do
    begin
        Item := CheckedItemStack.Pop;
        Item.Checked := false;
    end;
end;

function TButlerForm.searchLine(ln: TLine): TListItem; // search chap+line, return listitem or nil
begin
    result := GreekView.FindCaption(0, ln.GetID(id_alf), false, True, false);
end;

function TButlerForm.searchCard(ln: TLine): integer;
var // finds only cards with first line ln
    n: integer;
begin
    for n := 0 to cards.Count - 1 do
    begin
        if cards[n].first = ln then
        begin
            result := n;
            exit;
        end;
        if cards[n].first > ln then
            break;
    end;
    result := -1;
end;

procedure TButlerForm.SetListColors(itemindex: integer; FG, BG: TColor);
begin
    ListColors[itemindex].BG := BG;
    ListColors[itemindex].FG := FG;
    GreekView.Items[itemindex].Update;
end;

procedure TButlerForm.splitbuttonClick(Sender: TObject);
var
    s1: string;
    newcard, oldcard: TCard;
    Item, firstitem: TListItem;
    index: integer;
    undorec: TUndoRec;
begin
    undorec := TUndoRec.Create;
    undorec.thisfirst := cards[CurrentCardNr].first;
    undorec.thislast := cards[CurrentCardNr].last;
    undorec.thistext := cards[CurrentCardNr].text;
    undorec.actiontype := undo_type.u_split;
    undorec.cardindex := CurrentCardNr;
    UndoStack.Push(undorec);
    undobutton.Caption := IntToStr(UndoStack.Count);

    newcard := TCard.Create;
    oldcard := cards[CurrentCardNr];
    newcard.last := oldcard.last;
    Item := searchLine(oldcard.first);
    firstitem := Item;
    index := Item.index;
    while Item.Checked do
    begin
        inc(index);
        if index >= GreekView.Items.Count then
            exit;
        Item := GreekView.Items[index];
    end;
    newcard.first.SetFromID(GreekView.Items[index].Caption);
    oldcard.last.SetFromID(GreekView.Items[index - 1].Caption);
    cards.Insert(CurrentCardNr + 1, newcard);
    thisMemo.SelLength := Length(thisMemo.text) - thisMemo.SelStart;
    s1 := thisMemo.SelText;
    newcard.text := s1;
    thisMemo.SetSelText('');
    oldcard.text := thisMemo.text;
    GreekViewSelectItem(nil, firstitem, false);
    StatusBar1.Panels[1].Text := 'split: ' + cards[CurrentCardNr].first.GetID(id_num);
end;

procedure TButlerForm.mergebuttonClick(Sender: TObject);
var
    Item: TListItem;
    undorec: TUndoRec;
begin
    undorec := TUndoRec.Create;
    undorec.thisfirst := cards[CurrentCardNr].first;
    undorec.thislast := cards[CurrentCardNr].last;
    undorec.nextfirst := cards[CurrentCardNr + 1].first;
    undorec.nextlast := cards[CurrentCardNr + 1].last;
    undorec.thistext := cards[CurrentCardNr].text;
    undorec.nexttext := cards[CurrentCardNr + 1].text;
    undorec.actiontype := undo_type.u_merge;
    undorec.cardindex := CurrentCardNr;
    UndoStack.Push(undorec);
    undobutton.Caption := IntToStr(UndoStack.Count);

    thisMemo.text := thisMemo.text + nextMemo.text;
    cards[CurrentCardNr].text := thisMemo.text;
    cards[CurrentCardNr].last := cards[CurrentCardNr + 1].last;
    Item := searchLine(cards[CurrentCardNr].first);
    cards.Delete(CurrentCardNr + 1);
    GreekViewSelectItem(nil, Item, false);
    StatusBar1.Panels[1].Text := 'merge: ' + cards[CurrentCardNr].first.GetID(id_num);
end;

procedure TButlerForm.undobuttonClick(Sender: TObject);
var
    card: TCard;
    Item: TListItem;
    undorec: TUndoRec;
    status: String;
begin
    if UndoStack.Count = 0 then
        exit;
    undorec := UndoStack.Pop;
    CurrentCardNr := undorec.cardindex;
    cards[CurrentCardNr].first := undorec.thisfirst;
    cards[CurrentCardNr].last := undorec.thislast;
    cards[CurrentCardNr].text := undorec.thistext;
    case undorec.actiontype of
        undo_type.u_merge:
            begin
                card := TCard.Create; // recreate next card
                card.first := undorec.nextfirst;
                card.last := undorec.nextlast;
                card.text := undorec.nexttext;
                cards.Insert(CurrentCardNr + 1, card);
                status := 'Undo Merge: ';
            end;
        undo_type.u_split:
            begin
                cards.Delete(CurrentCardNr + 1);
                status := 'Undo Split: ';
            end;
        undo_type.u_set:
            begin
                cards[CurrentCardNr-1].first := undorec.prevfirst;
                cards[CurrentCardNr-1].last := undorec.prevlast;
                cards[CurrentCardNr-1].text := undorec.prevtext;
                cards[CurrentCardNr+1].first := undorec.nextfirst;
                cards[CurrentCardNr+1].last := undorec.nextlast;
                cards[CurrentCardNr+1].text := undorec.nexttext;
                status := 'Undo Set: ';
            end;
        end;
    Item := searchLine(cards[CurrentCardNr].first);
    GreekViewSelectItem(nil, Item, false);
    undorec.Free;
    undobutton.Caption := IntToStr(UndoStack.Count);
    StatusBar1.Panels[1].Text := status + cards[CurrentCardNr-1].first.GetID(id_num);
end;

procedure TButlerForm.LoadCardsFromXML;
var
    n: integer;
    Inode: IXMLNode;
    newcard: TCard;
begin
    n := 0;
    cards.Clear;
    newcard := nil;

    try
        Inode := ButlerXMLDoc.DocumentElement.ChildNodes.first;
        while Inode <> nil do
        begin
            if Inode.NodeName = 'P' then
            begin
                newcard := TCard.Create;
                newcard.first.SetFromID(Inode.ChildNodes[0].text);
                newcard.text := Inode.ChildNodes[1].text;
                cards.Add(newcard);
                if n > 0 then
                begin
                    cards[n - 1].last := newcard.first.previous;
                end;
                inc(n);
            end;
            Inode := Inode.NextSibling; // no depth in this xml file
        end;
        cards[n - 1].last.chap := 24;
        cards[n - 1].last.line := TLine.chaplen[24];

    except on E: Exception do
        if newcard = nil then ShowMessage('not an xml file?')
        else ShowMessage('xml file corrupt: '+ newcard.first.GetID(id_num));
    end;
end;

procedure TButlerForm.GreekViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: boolean);
begin
    if Item.Checked then
        TListView(Sender).Canvas.Brush.Color := GreekColor
    else
        TListView(Sender).Canvas.Brush.Color := DefaultColor;

end;

procedure TButlerForm.GreekViewCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: integer;
  State: TCustomDrawState; var DefaultDraw: boolean);
var
    rect: TRect;
    FG, BG: TColor;
begin
    BG := GreekView.Canvas.Brush.Color;
    FG := GreekView.Canvas.Font.Color;
    GreekView.Canvas.Brush.Color := ListColors[Item.index].BG;
    GreekView.Canvas.Font.Color := ListColors[Item.index].FG;
    rect := Item.DisplayRect(drBounds);
    rect.Left := rect.Left + GreekView.Columns[0].Width;
    GreekView.Canvas.FillRect(rect);
    GreekView.Canvas.TextRect(rect, rect.Left + 4, rect.Top, Item.SubItems.Strings[0]);
    GreekView.Canvas.Brush.Color := BG;
    GreekView.Canvas.Font.Color := FG;
    DefaultDraw := false;
end;

procedure TButlerForm.setchecks(first, last: TLine);
var
    Item: TListItem;
    index: integer;
begin
    first := first.previous;
    Item := searchLine(last);
    index := Item.index;
    repeat
        if Item <> nil then
        begin
            Item.Checked := True;
            CheckedItemStack.Push(Item);
        end;
        last := last.previous;
        index := index - 1;
        if index < 0 then
            break;
        Item := GreekView.Items[index];
    until (first = last);
end;

procedure TButlerForm.ScrollTo(index: integer);
var
    newpos, oldpos: integer;
begin
    oldpos := GreekView.TopItem.index * ListItemHeight;
    newpos := index * ListItemHeight;
    GreekView.Scroll(0, newpos - oldpos);
    GreekView.Repaint;
end;

procedure TButlerForm.printlines(p: TPanel; c: TCard);
begin
    p.Caption := c.first.GetID(id_num) + ' to ' + c.last.GetID(id_num);
end;

procedure TButlerForm.GreekViewSelectItem(Sender: TObject; Item: TListItem; Selected: boolean);
var
    cardindex: integer;
    c: TCard;
    found: boolean;
    selectedlinenr: TLine;
begin
    prevMemo.Lines.Clear;
    thisMemo.Lines.Clear;
    nextMemo.Lines.Clear;
    prevPanel.Caption := '';
    thisPanel.Caption := '';
    nextPanel.Caption := '';

    selectedlinenr.SetFromID(Item.Caption);
    found := false;
    for cardindex := 0 to cards.Count - 1 do
    begin
        c := cards[cardindex];
        if (selectedlinenr >= c.first) and (selectedlinenr <= c.last) then
        begin
            found := True;
            if cardindex = 0 then
                CurrentCardNr := 1 // keep first card in prevMemo
            else if cardindex = cards.Count - 1 then
                CurrentCardNr := cardindex - 1 // keep last card in nextMemo
            else
                CurrentCardNr := cardindex;
            break;
        end;
    end;

    if found then
    begin
        thisMemo.Lines.Add(cards[CurrentCardNr].text);
        printlines(thisPanel, cards[CurrentCardNr]);
        prevMemo.Lines.Add(cards[CurrentCardNr - 1].text);
        printlines(prevPanel, cards[CurrentCardNr - 1]);
        nextMemo.Lines.Add(cards[CurrentCardNr + 1].text);
        printlines(nextPanel, cards[CurrentCardNr + 1]);

        thisPanelClick(nil);
    end;
end;

procedure TButlerForm.helpbuttonClick(Sender: TObject);
begin
    HelpForm.Show;
end;

procedure TButlerForm.nextPanelClick(Sender: TObject);
var
    n_of_lines: integer;
    Item: TListItem;
    line, diff: integer;
    c: TCard;
begin
    if CurrentCardNr >= cards.Count - 1 then
        exit;
    c := cards[CurrentCardNr + 1];
    ClearCheckStack;
    GreekColor := $00A0CD8D;
    setchecks(c.first, c.last);
    n_of_lines := GreekView.ClientHeight div ListItemHeight;
    Item := searchLine(c.first);
    if Item <> nil then
    begin
        line := Item.index;
        if line < GreekView.TopItem.index then
            ScrollTo(line);
    end;
    Item := searchLine(c.last);
    if Item <> nil then
    begin
        line := Item.index;
        diff := line - (GreekView.TopItem.index + n_of_lines - 1);
        if diff > 0 then
            ScrollTo(GreekView.TopItem.index + diff);
    end;
end;

procedure TButlerForm.uncheckAllClick(Sender: TObject);
begin
    ClearCheckStack;
end;

procedure TButlerForm.prevPanelClick(Sender: TObject);
var
    Item: TListItem;
    line, diff, n_of_lines: integer;
    c: TCard;
begin
    if CurrentCardNr = 0 then
        exit;
    c := cards[CurrentCardNr - 1];
    ClearCheckStack;
    GreekColor := $00C7BC81;

    setchecks(c.first, c.last);
    Item := searchLine(c.first);
    if Item <> nil then
    begin
        line := Item.index;
        if line < GreekView.TopItem.index then
            ScrollTo(line);
    end;
    Item := searchLine(c.last);
    n_of_lines := GreekView.ClientHeight div ListItemHeight;
    if Item <> nil then
    begin
        line := Item.index;
        diff := line - (GreekView.TopItem.index + n_of_lines - 1);
        if diff > 0 then
            ScrollTo(GreekView.TopItem.index + diff);
    end;
end;

procedure TButlerForm.load1Click(Sender: TObject);
begin
    Form1.ButlerFileName := '';
    loadButlerXMLClick(nil);
end;

procedure TButlerForm.loadButlerXMLClick(Sender: TObject);
begin
    if Form1.ButlerFileName = '' then
    begin
        OpenDialog1.Title := 'Loading Butler Text';
        if OpenDialog1.Execute then
        begin
            Form1.ButlerFileName := OpenDialog1.FileName;
        end
        else exit;
    end;
    ButlerXMLDoc := TXMLDocument.Create(Self);
    Form1.ButlerFileName := Form1.ButlerFileName;
    ButlerXMLDoc.LoadFromFile(Form1.ButlerFileName);
    StatusBar1.Panels[0].Text := 'using ' + System.IOUtils.TPath.GetFullPath(Form1.ButlerFileName);
    LoadCardsFromXML;
    ButlerXMLDoc.Free;
end;

procedure TButlerForm.save1Click(Sender: TObject);
begin
    CreateNewDoc;
end;

procedure TButlerForm.thisPanelClick(Sender: TObject);
var
    Item: TListItem;
    line, diff, n_of_lines: integer;
    c: TCard;
begin
    ClearCheckStack;
    GreekColor := $00AC8FE0;
    c := cards[CurrentCardNr];
    setchecks(c.first, c.last);
    Item := searchLine(c.first);
    if Item <> nil then
    begin
        line := Item.index;
        if line < GreekView.TopItem.index then
            ScrollTo(line);
    end;
    Item := searchLine(c.last);
    n_of_lines := GreekView.ClientHeight div ListItemHeight;
    if Item <> nil then
    begin
        line := Item.index;
        diff := line - (GreekView.TopItem.index + n_of_lines - 1);
        if diff > 0 then
            ScrollTo(GreekView.TopItem.index + diff);
    end;
end;

procedure TButlerForm.CreateNewDoc;
var
    Pnode, Anode, Hnode: IXMLNode;
    n, book: integer;
    filename: string;
begin
    ButlerXMLDoc := TXMLDocument.Create(Form1);
    ButlerXMLDoc.Active := True;
    ButlerXMLDoc.DocumentElement := ButlerXMLDoc.CreateNode('text', ntElement);
    n := 0;
    book := 0;
    while n < cards.Count do
    begin
        if book <> cards[n].first.chap then
        begin
            book := cards[n].first.chap;
            Hnode := ButlerXMLDoc.DocumentElement.AddChild('H4');
            Hnode.NodeValue := 'Book ' + IntToStr(book);
        end;
        Pnode := ButlerXMLDoc.DocumentElement.AddChild('P');
        Pnode.text := cards[n].text;
        Anode := Pnode.AddChild('A', 0);
        // Tnode := ButlerXMLDoc.CreateNode(cards[n].Text, ntText);
        Anode.NodeValue := cards[n].first.GetID(id_num);
        inc(n);
    end;
    filename := System.IOUtils.TPath.GetFileNameWithoutExtension(Form1.ButlerFileName);
    Form1.RenameBackups(filename);
    ButlerXMLDoc.SaveToFile(filename + '.xml');
    StatusBar1.Panels[0].Text := 'saved ' + System.IOUtils.TPath.GetFullPath(Form1.ButlerFileName);
end;

procedure TButlerForm.check1Click(Sender: TObject);
begin
    CheckButlerText;
end;

procedure TButlerForm.CheckButlerText;
var
    oldtext, newtext: TStringList;
    response: integer;
    c: TCard;
begin
    oldtext := TStringList.Create;
    newtext := TStringList.Create;
    oldtext.Delimiter := #0;
    newtext.Delimiter := #0;
    for c in cards do
    begin
        newtext.Add(c.text);
    end;
    response := MessageBox(ButlerForm.Handle, 'save: yes, compare: no, cancel: cancel', 'saveOrCheck', MB_YESNOCANCEL);
    case response of
        idYes:
            newtext.SaveToFile('newtext.txt');
        idNo:
            begin
                OpenDialog1.Title := 'Saving newtext.txt';
                if OpenDialog1.Execute then
                begin
                    oldtext.LoadFromFile(OpenDialog1.FileName);
                    CompForm.OldMemo.text := oldtext.text;
                    CompForm.NewMemo.text := newtext.text;
                    CompForm.ShowModal;
                end;
            end;
    end;
    oldtext.Free;
    newtext.Free;
end;

end.
