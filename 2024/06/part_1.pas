program part1;

{ FPC 3.2.2 }

{$codepage utf8}

const
  DIM = 130;

type
  TDir = (TOP, RIGHT, BOTTOM, LEFT);
  TGuard = record
    x: integer;
    y: integer;
    dir: TDir;
  end;
  TObstacles = array[1..DIM, 1..DIM] of boolean;
  TVisited = array[1..DIM, 1..DIM] of boolean;

procedure LoadFile(var obs: TObstacles; var guard: TGuard);
var
  f: Text;
  x, y: integer;
  c: char;
begin
  Assign(f, 'input.txt');
  Reset(f);
  x := 1; y := 1;
  while not EOF(f) do begin
    Read(f, c);
    case c of
      '#': obs[x,y] := True;
      '^': begin
        guard.x := x;
        guard.y := y;
        guard.dir := TOP;
      end;
      #10: begin
        x := 0;
        y := y + 1;
      end;
    end;
    x := x + 1;
  end;
  Close(f);
end;

procedure RunSimulation(
  var obs: TObstacles;
  guard: TGuard;
  var visited: TVisited
);
begin
  with guard do begin
    while
      ((dir <> TOP) or (y > 1))
      and ((dir <> RIGHT) or (x < DIM))
      and ((dir <> BOTTOM) or (y < DIM))
      and ((dir <> LEFT) or (x > 1))
    do begin
      visited[x, y] := True;
      case dir of
        TOP: begin
          if obs[x, y - 1] then dir := RIGHT
          else y := y - 1;
        end;
        RIGHT: begin
          if obs[x + 1, y] then dir := BOTTOM
          else x := x + 1;
        end;
        BOTTOM: begin
          if obs[x, y + 1] then dir := LEFT
          else y := y + 1;
        end;
        LEFT: begin
          if obs[x - 1, y] then dir := TOP
          else x := x - 1;
        end;
      end;
    end;
    visited[x, y] := True;
  end;
end;

var
  visited: TVisited;
  obs: TObstacles;
  guard: TGuard;
  count: integer;
  x, y: integer;
begin
  for x := 1 to DIM do begin
    for y := 1 to DIM do begin
      visited[x,y] := False;
      obs[x,y] := False;
    end;
  end;

  LoadFile(obs, guard);

  RunSimulation(obs, guard, visited);
  
  count := 0;
  for x := 1 to DIM do begin
    for y := 1 to DIM do begin
      if visited[x, y] then count := count + 1;
    end;
  end;
  WriteLn('Total visited: ', count);
end.
