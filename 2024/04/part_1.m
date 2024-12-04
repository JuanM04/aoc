% MATLAB 2024b

clear all; close all; clc;

f = fopen("input.txt", "r", "n", "UTF-8");

lines = [];
while ~feof(f)
  lines = [lines; fgetl(f)];
end

L = length(lines); % It's a square, so width = height = L

total = 0;

for i = 1:L
  for j = 1:L
    if lines(i,j) == 'X'
      if i-3 >= 1 % Top
        total = total + strcmp(lines(i:-1:(i-3),j)', 'XMAS');
      end
      if i-3 >= 1 && j+3 <= L % Top-right
        total = total + strcmp(diag(lines(i:-1:(i-3),j:(j+3)))', 'XMAS');
      end
      if j+3 <= L % Right
        total = total + strcmp(lines(i,j:(j+3)), 'XMAS');
      end
      if i+3 <= L && j+3 <= L % Bottom-right
        total = total + strcmp(diag(lines(i:(i+3),j:(j+3)))', 'XMAS');
      end
      if i+3 <= L % Bottom
        total = total + strcmp(lines(i:(i+3),j)', 'XMAS');
      end
      if i+3 <= L && j-3 >= 1 % Bottom-left
        total = total + strcmp(diag(lines(i:(i+3),j:-1:(j-3)))', 'XMAS');
      end
      if j-3 >= 1 % Left
        total = total + strcmp(lines(i,j:-1:(j-3)), 'XMAS');
      end
      if i-3 >= 1 && j-3 >= 1 % Top-left
        total = total + strcmp(diag(lines(i:-1:(i-3),j:-1:(j-3)))', 'XMAS');
      end
    end
  end
end

fprintf("Total: %d\n", total);

fclose(f);
