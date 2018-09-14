unit colorpickform;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, davColorBox, ExtCtrls, ComCtrls, HSLUtils, StdCtrls, Buttons, System.Math,
    VirtualTrees;

type
    Cparam = set of (Hue, Sat, Lum);

type
    TForm3 = class(TForm)
        SatBar: TTrackBar;
        Sresultbox: TPanel;
        HueBar: TTrackBar;
        LumBar: TTrackBar;
        HPanel1: TPanel;
        HPanel2: TPanel;
        HPanel3: TPanel;
        HPanel4: TPanel;
        HPanel5: TPanel;
        SPanel1: TPanel;
        SPanel2: TPanel;
        SPanel3: TPanel;
        pickbtn: TBitBtn;
        RadioGroup1: TRadioGroup;
        SetFG: TRadioButton;
        SetBG: TRadioButton;
        resetbtn: TBitBtn;
        fetchbtn: TBitBtn;
        SetBothBtn: TBitBtn;
        davColorBox1: TdavColorBox;
        Label1: TLabel;
        VarHue: TButton;
        VarSat: TButton;
        VarLum: TButton;
        Label4: TLabel;
        Label2: TLabel;
        FromPanel: TPanel;
        ToPanel: TPanel;
        Label3: TLabel;
        HexEdit: TEdit;
        autoFG: TRadioButton;
        procedure FormCreate(Sender: TObject);
        procedure SatBarChange(Sender: TObject);
        procedure LumBarChange(Sender: TObject);
        procedure HueBarChange(Sender: TObject);
        procedure pickbtnClick(Sender: TObject);
        procedure resetbtnClick(Sender: TObject);
        procedure fetchbtnClick(Sender: TObject);
        procedure SetBothBtnClick(Sender: TObject);
        procedure davColorBox1Select(Sender: TObject; color: Integer);
        procedure setHSL(color: TColor);
        procedure varyHSL(color: TColor; which: Cparam; down: boolean);
        procedure SPanel1Click(Sender: TObject);
        procedure LPanel1Click(Sender: TObject);
        procedure VarHueClick(Sender: TObject);
        procedure VarLumClick(Sender: TObject);
        procedure VarSatClick(Sender: TObject);
        procedure SresultboxClick(Sender: TObject);
        function InterpolateColor(color1, color2: TColor; index: Integer; steps: Integer): TColor;
        procedure FromPanelClick(Sender: TObject);
        procedure HPanel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure SetResultBoxColor(color: TColor);
        procedure HexEditKeyPress(Sender: TObject; var Key: Char);
        function ContrastColor(color: TColor): TColor;
    private
        HToggle, SToggle, LToggle: boolean;
    public
        { Public declarations }
        HColors: array [0 .. 9] of TPanel;
        SColors: array [0 .. 5] of TPanel;
        LColors: array [0 .. 5] of TPanel;
    end;

type
    HSLdata = record
        H: Integer;
        S: Integer;
        L: Integer;
        Hpos: Integer;
        Spos: Integer;
        Lpos: Integer;
    end;

var
    Form3: TForm3;
    HSL: HSLdata;
    SavePick: TColor;

const
    scale = 1;

implementation

uses treeview;
{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
    HColors[0] := HPanel1;
    HColors[1] := HPanel2;
    HColors[2] := HPanel3;
    HColors[3] := HPanel4;
    HColors[4] := HPanel5;
    HColors[5] := SPanel1;
    HColors[6] := SPanel2;
    HColors[7] := SPanel3;

    Left := Form1.Left;
    Top := Form1.Top + Form1.Height + 5;
    HToggle := true;
    SToggle := true;
    LToggle := true;
end;

function TForm3.ContrastColor(color: TColor): TColor;
var
    r, g, b: single;
begin
    b := color and $FF;
    g := (color shr 8) and $FF;
    r := (color shr 16) and $FF;
    if ((r * 299) + (g * 587) + (b * 144)) / 1000 >= 125 then
        result := clBlack + 1 // 186
    else
        result := clWhite;
end;

procedure TForm3.SetResultBoxColor(color: TColor);
begin
    if SetFG.Checked then
    begin
        Sresultbox.Font.color := color;
    end else begin
        HexEdit.Text := IntToHex(color, 6);
        Sresultbox.color := color;
        // davColorBox1Select(nil, color);
        if autoFG.Checked then
        begin
            Sresultbox.Font.color := ContrastColor(color);
        end;

    end;
end;

procedure TForm3.FromPanelClick(Sender: TObject);
begin
    (Sender as TPanel).color := Sresultbox.color;
end;

function round(n: Integer): Integer;
begin
    if n >= 0 then
        result := ((n + 5) div 10) * 10
    else
        result := ((n - 5) div 10) * 10;
end;

procedure TForm3.davColorBox1Select(Sender: TObject; color: Integer);
begin
    setHSL(color);
    // varyHSL( color, [Hue,Sat,Lum], true );
    HToggle := true;
    SToggle := true;
    LToggle := true;
end;

procedure TForm3.setHSL(color: TColor);
begin
    if color = 0 then
        color := $010101; // = black enough; 0 means reset color

    SetResultBoxColor(color);
    RGBtoHSLRange(color, HSL.H, HSL.S, HSL.L); // HSL are var params
    HSL.Spos := HSL.S;
    HSL.Hpos := HSL.H;
    HSL.Lpos := HSL.L;
    SatBar.Position := HSL.Spos;
    LumBar.Position := HSL.Lpos;
    HueBar.Position := HSL.Hpos;
end;

procedure TForm3.varyHSL(color: TColor; which: Cparam; down: boolean);
var
    i, step: Integer;
begin
    RGBtoHSLRange(color, HSL.H, HSL.S, HSL.L);
    for i := 0 to 7 do
    begin
        if Hue in which then
        begin
            if down then
                step := HSL.H div 8
            else
                step := (HSL.H - 240) div 8;
            HColors[i].color := HSLRangeToRGB(HSL.H - i * step, HSL.S, HSL.L);
        end
        else if Sat in which then
        begin
            if down then
                step := HSL.S div 8
            else
                step := (HSL.S - 240) div 8;
            HColors[i].color := HSLRangeToRGB(HSL.H, HSL.S - i * step, HSL.L);
        end
        else if Lum in which then
        begin
            if down then
                step := HSL.L div 8
            else
                step := (HSL.L - 240) div 8;
            HColors[i].color := HSLRangeToRGB(HSL.H, HSL.S, HSL.L - i * step);
        end;
    end;
end;

procedure TForm3.fetchbtnClick(Sender: TObject);
var // refresh color data from first selected node/
    tn: PVirtualNode;
    td: ^rTreeData;
begin
    tn := Form1.Iltree.GetFirstSelected;
    if tn <> nil then
    begin
        td := Form1.Iltree.GetNodeData(tn);
        if td.BGColor = 0 then
            SetResultBoxColor(Form1.DefaultBG);
        if td.FGColor = 0 then
            Sresultbox.Font.color := Form1.DefaultFG;
        SetResultBoxColor(td.BGColor);
        Sresultbox.Font.color := td.FGColor;
    end else begin
        SetResultBoxColor(Form1.DefaultBG);
        Sresultbox.Font.color := Form1.DefaultFG;
    end;
    // if not SetFG.Checked then kleur := Sresultbox.Color
    // else kleur := Sresultbox.Font.Color;
    // davColorBox1Select( nil, kleur );
end;

procedure TForm3.SatBarChange(Sender: TObject); // set saturation
var
    d: Integer;
    c: TColor;
    delta: Integer;
begin
    if not SetFG.Checked then
        RGBtoHSLRange(Sresultbox.color, HSL.H, HSL.S, HSL.L)
    else
        RGBtoHSLRange(Sresultbox.Font.color, HSL.H, HSL.S, HSL.L);
    d := SatBar.Position - HSL.Spos;
    if d = 0 then
        exit;
    HSL.Spos := SatBar.Position;
    delta := d * scale;
    HSL.S := HSL.S + delta;
    if HSL.S <= 0 then
        HSL.S := 3;
    if HSL.S >= 240 then
        HSL.S := 237;
    c := HSLRangeToRGB(HSL.H, HSL.S, HSL.L);
    SetResultBoxColor(c);
    // davColorBox1Select(nil, c );
end;

procedure TForm3.SetBothBtnClick(Sender: TObject);
begin
    Form1.SetNodeBGColor(Sresultbox.color);
    if autoFG.Checked then
    begin
        Form1.SetNodeFGColor(ContrastColor(Sresultbox.Color));
    end else begin
        Form1.SetNodeFGColor(Sresultbox.Font.color);
    end;
    fetchbtnClick(nil);
end;

procedure TForm3.LumBarChange(Sender: TObject);
var
    d: Integer;
    c: TColor;
    delta: Integer;
begin
    if SetBG.Checked then
        RGBtoHSLRange(Sresultbox.color, HSL.H, HSL.S, HSL.L)
    else
        RGBtoHSLRange(Sresultbox.Font.color, HSL.H, HSL.S, HSL.L);
    d := LumBar.Position - HSL.Lpos;
    if d = 0 then
        exit;
    HSL.Lpos := LumBar.Position;
    delta := d * scale;
    HSL.L := HSL.L + delta;
    if HSL.L <= 0 then
        HSL.L := 3;
    if HSL.L >= 240 then
        HSL.L := 237;
    c := HSLRangeToRGB(HSL.H, HSL.S, HSL.L);
    SetResultBoxColor(c);
    // davColorBox1Select(nil, c );
end;

procedure TForm3.VarHueClick(Sender: TObject);
begin
    HToggle := not HToggle;
    varyHSL(Sresultbox.color, [Hue], HToggle);
end;

procedure TForm3.VarLumClick(Sender: TObject);
begin
    LToggle := not LToggle;
    varyHSL(Sresultbox.color, [Lum], LToggle);
end;

procedure TForm3.VarSatClick(Sender: TObject);
begin
    SToggle := not SToggle;
    varyHSL(Sresultbox.color, [Sat], SToggle);
end;

function TForm3.InterpolateColor(color1, color2: TColor; index: Integer; steps: Integer): TColor;
var
    r1, r2, g1, g2, b1, b2: byte;
    r, g, b: byte;
begin
    b1 := color1 and $FF;
    b := b1;
    g1 := (color1 shr 8) and $FF;
    g := g1;
    r1 := (color1 shr 16) and $FF;
    r := r1;
    b2 := color2 and $FF;
    g2 := (color2 shr 8) and $FF;
    r2 := (color2 shr 16) and $FF;

    if steps > 0 then
    begin
        r := r + ((index * (r2 - r1)) div steps);
        g := g + ((index * (g2 - g1)) div steps);
        b := b + ((index * (b2 - b1)) div steps);
    end;

    result := (r shl 16) or (g shl 8) or b;
end;

procedure TForm3.HexEditKeyPress(Sender: TObject; var Key: Char);
var
    color: TColor;
begin
    if Key = #13 then
    begin
        Key := #0;
        color := StrToInt('$' + HexEdit.Text);
        SetResultBoxColor(color);
    end;

end;

procedure TForm3.HPanel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i, n: Integer;
    steps: Integer;
begin
    if ssShift in Shift then
    begin
        for i := 0 to High(HColors) do
        begin
            if (Sender as TPanel) = HColors[i] then
            begin
                break;
            end;
        end;
        steps := i;
        for n := 0 to steps do
        begin
            HColors[n].color := InterpolateColor(FromPanel.color, ToPanel.color, n, steps);
        end;
        for n := steps + 1 to 7 do
        begin
            HColors[n].color := clBtnFace;
        end;
    end else begin
        SetResultBoxColor((Sender as TPanel).color);
    end;

end;

procedure TForm3.LPanel1Click(Sender: TObject);
begin
    SetResultBoxColor((Sender as TPanel).color);
end;

procedure TForm3.SPanel1Click(Sender: TObject);
begin
    SetResultBoxColor((Sender as TPanel).color);
end;

procedure TForm3.SresultboxClick(Sender: TObject);
begin
    if autoFG.Checked then SetResultBoxColor(Sresultbox.color);

    davColorBox1Select(nil, Sresultbox.color);
end;

procedure TForm3.HueBarChange(Sender: TObject);
var
    d: Integer;
    c: TColor;
    delta: Integer;
begin
    if not SetFG.Checked then
        RGBtoHSLRange(Sresultbox.color, HSL.H, HSL.S, HSL.L)
    else
        RGBtoHSLRange(Sresultbox.Font.color, HSL.H, HSL.S, HSL.L);
    d := HueBar.Position - HSL.Hpos;
    if d = 0 then
        exit;
    HSL.Hpos := HueBar.Position;
    delta := d * scale;
    HSL.H := HSL.H + delta;
    if HSL.H <= 0 then
        HSL.H := 3;
    if HSL.H >= 239 then
        HSL.H := 236;
    c := HSLRangeToRGB(HSL.H, HSL.S, HSL.L);
    SetResultBoxColor(c);
    // setHSL( c );
    // varyHSL( c, [Sat,Lum], HToggle );
end;

procedure TForm3.pickbtnClick(Sender: TObject);
var
    c: TColor;
begin
    if not SetFG.Checked then
    begin
        c := Sresultbox.color;
        Form1.SetNodeBGColor(c);
    end else begin
        c := Sresultbox.Font.color;
        Form1.SetNodeFGColor(c);
    end;
end;

procedure TForm3.resetbtnClick(Sender: TObject);
begin
    if not SetFG.Checked then
        Form1.SetNodeBGColor(0)
    else
        Form1.SetNodeFGColor(0);
end;

end.
