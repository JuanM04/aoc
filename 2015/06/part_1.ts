const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

const lights = new Array(1000)
  .fill(undefined)
  .map(() => new Array<boolean>(1000).fill(false));

const instructionRegex =
  /^(?<action>turn on|turn off|toggle) (?<from>\d+,\d+) through (?<to>\d+,\d+)$/;

function parsePosition(pos: string) {
  return pos.split(",").map((str) => parseInt(str)) as [number, number];
}

for (const instruction of lines) {
  const { action, from, to } = instruction.match(instructionRegex)!.groups!;

  const [xi, yi] = parsePosition(from);
  const [xf, yf] = parsePosition(to);

  for (let x = xi; x <= xf; x++) {
    for (let y = yi; y <= yf; y++) {
      if (action === "turn on") lights[x][y] = true;
      else if (action === "turn off") lights[x][y] = false;
      else lights[x][y] = !lights[x][y];
    }
  }
}

const lit = lights.reduce(
  (total, row) => total + row.reduce((row, cell) => row + (cell ? 1 : 0), 0),
  0
);

console.log(lit);
