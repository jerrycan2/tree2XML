unit davColorBox;
{ color picker component

  supply rectangle with selectable colors

  properties:

  - direction : cbHor, cbVert for horizontal or vertical orientation
  - colordepth : cb8, cb64 , cb512 for amount of colors
  - Csquare : 5 .. 40, edge of each colored square
  - border : 0 .. 10 , the width of the border
  - borderlight : color of left and top of border
  - borderdark : color of bottom and right side of border

  methods:

  - create

  events:

  - OnSelect : mouse-up over a color supplies selected color
}

interface

uses windows, vcl.controls, classes;

type
  TcolorDepth = (cb8, cb64, cb512);
  Tcolorboxdir = (cbHor, cbVert);
  TColorSelect = procedure(sender: TObject; color: LongInt) of object;

  TColorSquare = record
    x1: integer;
    y1: integer;
    color: LongInt;
  end;

  TdavColorBox = class(TGraphicControl)
  private
    FColorDepth: TcolorDepth;
    FDirection: Tcolorboxdir;
    FColor: LongInt;
    FOnSelect: TColorSelect;
    FBorderwidth: byte;
    FBorderlight: LongInt;
    FBorderdark: LongInt;
    FCsquare: byte;
    procedure setDirection(cbDir: Tcolorboxdir);
    procedure setColorDepth(cbDepth: TcolorDepth);
    procedure setDimensions;
    function number2color(w: word): TColorSquare;
  protected
    procedure Paint; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure setSquare(edge: byte);
    procedure setBorderwidth(w: byte);
    procedure setBorderlight(c: LongInt);
    procedure setBorderdark(c: LongInt);
    procedure select(sender: TObject; selcolor: LongInt);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnSelect: TColorSelect read FOnSelect write FOnSelect;
    property direction: Tcolorboxdir read FDirection write setDirection
      default cbHor;
    property colordepth: TcolorDepth read FColorDepth write setColorDepth
      default cb512;
    property Csquare: byte read FCsquare write setSquare default 10;
    property border: byte read FBorderwidth write setBorderwidth default 2;
    property borderlight: LongInt read FBorderlight write setBorderlight
      default $FFFFFF;
    property borderdark: LongInt read FBorderdark write setBorderdark
      default $0;
    property visible;
    property enabled;
  end;

procedure Register;

implementation

//uses colorpickform;

procedure Register;
begin
  RegisterComponents('davColorBox', [TdavColorBox]);
end;

procedure TdavColorBox.setDimensions;
const
  dimlist: array [cb8 .. cb512] of byte = (2, 4, 8);
var
  xx, yy: integer;
begin
  yy := dimlist[FColorDepth] * FCsquare;
  xx := yy * dimlist[FColorDepth] + 2 * border + 1;
  yy := yy + 2 * border + 1;
  if FDirection = cbHor then
  begin
    width := xx;
    height := yy;
  end
  else
  begin
    height := xx;
    width := yy;
  end;
end;

constructor TdavColorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCsquare := 10;
  FBorderwidth := 4;
  FColorDepth := cb512;
  FDirection := cbHor;
  FBorderlight := $FFFFFF;
  FBorderdark := $0;
  FColor := $0;
  setDimensions;
end;

procedure TdavColorBox.setDirection(cbDir: Tcolorboxdir);
begin
  FDirection := cbDir;
  setDimensions;
end;

procedure TdavColorBox.setColorDepth(cbDepth: TcolorDepth);
begin
  FColorDepth := cbDepth;
  setSquare(FCsquare);
  setDimensions;
end;

function TdavColorBox.number2color(w: word): TColorSquare;
var
  r, g, b: byte;
begin
  r := 0;
  g := 0;
  b := 0;
  case colordepth of
    cb8:
      begin
        r := w and $1;
        g := (w shr 1) and 1;
        b := (w shr 2) and $1;
        result.x1 := border + (r + 2 * g) * FCsquare;
        result.y1 := border + b * FCsquare;
        if r > 0 then
          r := $FF;
        if g > 0 then
          g := $FF;
        if b > 0 then
          b := $FF;
      end;
    cb64:
      begin
        r := (w and $3);
        g := (w shr 2) and $3;
        b := (w shr 4) and $3;
        result.x1 := border + (r + 4 * g) * FCsquare;
        result.y1 := border + b * FCsquare;
        r := r shl 6;
        g := g shl 6;
        b := b shl 6;
        if r > 0 then
          r := r + $3F;
        if g > 0 then
          g := g + $3F;
        if b > 0 then
          b := b + $3F;
      end;
    cb512:
      begin
        r := (w and $7);
        g := (w shr 3) and $7;
        b := (w shr 6) and $7;
        result.x1 := border + (r + 8 * g) * FCsquare;
        result.y1 := border + b * FCsquare;
        r := r shl 5;
        g := g shl 5;
        b := b shl 5;
        if r > 0 then
          r := r + $1F;
        if g > 0 then
          g := g + $1F;
        if b > 0 then
          b := b + $1F;
      end;
  end; // case
  result.color := RGB(r, g, b);
end;

procedure TdavColorBox.Paint;
const
  Cmaxcolor: array [cb8 .. cb512] of word = (7, 63, 511);
var
  h, i, x1, y1: integer;
  cs: TColorSquare;
begin
  with self do
    with canvas do
    begin
      pen.color := $0;
      pen.width := 1;
      for i := 0 to border - 1 do // borderpaint
      begin
        pen.color := FBorderlight;
        moveto(width - 1 - i, i);
        lineto(i, i);
        lineto(i, height - 1 - i);
        pen.color := FBorderdark;
        lineto(width - 1 - i, height - 1 - i);
        lineto(width - 1 - i, i);
      end;
      // --
      for i := 0 to Cmaxcolor[FColorDepth] do
      begin
        cs := number2color(i);
        if FDirection = cbVert then // trade x,y positions for vertical
        begin
          h := cs.x1;
          cs.x1 := cs.y1;
          cs.y1 := h;
        end;
        brush.color := cs.color;
        fillrect(rect(cs.x1, cs.y1, cs.x1 + FCsquare, cs.y1 + FCsquare));
      end; // for i
      // --
      pen.color := $0;
      for i := 0 to ((width - 2 * border) div FCsquare) do // sep. lines
      begin
        x1 := border + i * FCsquare;
        moveto(x1, border);
        lineto(x1, height - border);
      end;
      for i := 0 to ((height - 2 * border) div FCsquare) do
      begin
        y1 := border + i * FCsquare;
        moveto(border, y1);
        lineto(width - border, y1);
      end;
    end;
end;

procedure TdavColorBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  h, v, temp: byte;
  colornumber: word;
begin
  colornumber := 0;
  if (X > FBorderwidth) and (X < width - FBorderwidth - 1) and
    (Y > FBorderwidth) and (Y < height - FBorderwidth - 1) then
  begin
    h := (X - FBorderwidth) div FCsquare;
    v := (Y - FBorderwidth) div FCsquare;
  end
  else
    exit;
  // --
  if FDirection = cbVert then
  begin
    temp := h;
    h := v;
    v := temp;
  end;
  case FColorDepth of
    cb8:
      colornumber := h + v * 4;
    cb64:
      colornumber := h + v * 16;
    cb512:
      colornumber := h + v * 64;
  end;
  FColor := number2color(colornumber).color;
  if assigned(FOnSelect) then
    FOnSelect(self, FColor);
end;

procedure TdavColorBox.select(sender: TObject; selcolor: LongInt);
begin
  if assigned(FOnSelect) then
    FOnSelect(self, FColor);
end;

procedure TdavColorBox.setSquare(edge: byte);
begin
  case FColorDepth of
    cb8:
      if edge > 40 then
        edge := 40;
    cb64:
      if edge > 20 then
        edge := 20;
    cb512:
      if edge > 10 then
        edge := 10;
  end;
  if edge < 5 then
    edge := 5;
  FCsquare := edge;
  setDimensions;
end;

procedure TdavColorBox.setBorderwidth(w: byte);
begin
  if w > 10 then
    w := 10;
  FBorderwidth := w;
  setDimensions;
end;

procedure TdavColorBox.setBorderlight(c: LongInt);
begin
  FBorderlight := c;
  Paint;
end;

procedure TdavColorBox.setBorderdark(c: LongInt);
begin
  FBorderdark := c;
  Paint;
end;

end.
