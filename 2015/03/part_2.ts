const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);

type Point = `${number},${number}`;

const visited = new Set<Point>(["0,0"]);
const santa = { x: 0, y: 0 };
const roboSanta = { x: 0, y: 0 };

for (let i = 0; i < input.length; i++) {
  const move = input[i];
  const current = i % 2 === 0 ? santa : roboSanta;

  if (move === "^") current.y++;
  else if (move === ">") current.x++;
  else if (move === "v") current.y--;
  else current.x--;

  visited.add(`${current.x},${current.y}`);
}

console.log(visited.size);
