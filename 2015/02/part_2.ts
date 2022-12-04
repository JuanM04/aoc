const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

type Dimensions = [length: number, width: number, height: number];

function parseDimensions(input: string) {
  return input.split("x").map((str) => parseInt(str)) as Dimensions;
}

function ribbonNeeded([l, w, h]: Dimensions): number {
  const sizes = [l + w, w + h, h + l]; // All three faces
  const minSize = sizes.sort((a, b) => a - b)[0]; // The smallest face
  return 2 * minSize + l * w * h;
}

const totalRibbon = lines
  .map(parseDimensions)
  .map(ribbonNeeded)
  .reduce((total, ribbon) => total + ribbon, 0);

console.log(totalRibbon);
