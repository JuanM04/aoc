% MATLAB 2024b

clear all; close all; clc;

f = fopen("input.txt", "r", "n", "UTF-8");

lines = [];
while ~feof(f)
  lines = [lines; fgetl(f)];
end

L = length(lines); % It's a square, so width = height = L

total = 0;

for i = (1+1):(L-1)
  for j = (1+1):(L-1)
    if lines(i,j) == 'A'
      tl_br = [lines(i-1,j-1) lines(i,j) lines(i+1,j+1)];
      tr_bl = [lines(i-1,j+1) lines(i,j) lines(i+1,j-1)];
      total = total + (strcmp(tl_br, 'MAS') + strcmp(tl_br, 'SAM')) * (strcmp(tr_bl, 'MAS') + strcmp(tr_bl, 'SAM'));
    end
  end
end

fprintf("Total: %d\n", total);

fclose(f);
