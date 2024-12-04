-- VHDL 1076-2002, tested on Active-HDL 15

library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
library std;
use std.TEXTIO.all;

entity Part2 is end;

architecture Driver of Part2 is
begin
  process
    file f: Text;
    variable l: Line;
    variable c: Character;
    variable good: Boolean;
    variable enabled: Boolean := True;
    variable op1, op2: Integer;
    variable total: Integer := 0;
  begin
    file_open(f, "input.txt", read_mode);
    while not endfile(f) loop
      readline(f, l);
      good := True;
      while l'Length > 0 and good loop
        read(l, c, good);
        if enabled and good and c = 'm' then
          read(l, c, good);
          next when not good or c /= 'u';
          read(l, c, good);
          next when not good or c /= 'l';
          read(l, c, good);
          next when not good or c /= '(';
          op1 := 0;
          read(l, c, good);
          while good and c >= '0' and c <= '9' loop
            op1 := op1*10 + integer'value("" & c);
            read(l, c, good);
          end loop;
          next when not good or op1 = 0 or c /= ',';
          op2 := 0;
          read(l, c, good);
          while good and c >= '0' and c <= '9' loop
            op2 := op2*10 + integer'value("" & c);
            read(l, c, good);
          end loop;
          next when not good or op2 = 0 or c /= ')';
          total := total + op1*op2;
        elsif good and c = 'd' then
          read(l, c, good);
          next when not good or c /= 'o';
          read(l, c, good);
          if good and c = '(' then
            read(l, c, good);
            next when not good or c /= ')';
            enabled := True;
          elsif good and c = 'n' then
            read(l, c, good);
            next when not good or c /= ''';
            read(l, c, good);
            next when not good or c /= 't';
            read(l, c, good);
            next when not good or c /= '(';
            read(l, c, good);
            next when not good or c /= ')';
            enabled := False;
          end if;
        end if;
      end loop;
    end loop;
    report "Total = " & integer'image(total);
    file_close(f);
    wait;
  end process;
end;
