const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

type Dimensions = [length: number, width: number, height: number];

function parseDimensions(input: string) {
  return input.split("x").map((str) => parseInt(str)) as Dimensions;
}

function paperNeeded([l, w, h]: Dimensions): number {
  const faces = [l * w, w * h, h * l]; // All three faces
  const boxArea = faces.reduce((total, face) => 2 * face + total, 0); // The sum of all areas times two
  const slack = faces.sort((a, b) => a - b)[0]; // The smallest face
  return boxArea + slack;
}

const totalPaper = lines
  .map(parseDimensions)
  .map(paperNeeded)
  .reduce((total, paper) => total + paper, 0);

console.log(totalPaper);
