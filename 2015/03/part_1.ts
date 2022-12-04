const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);

type Point = `${number},${number}`;

const visited = new Set<Point>(["0,0"]);
const current = { x: 0, y: 0 };

for (const move of input) {
  if (move === "^") current.y++;
  else if (move === ">") current.x++;
  else if (move === "v") current.y--;
  else current.x--;

  visited.add(`${current.x},${current.y}`);
}

console.log(visited.size);
