const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);

for (let i = 3; i < input.length; i++) {
  const lastFour = input.slice(i - 3, i + 1);
  if (
    lastFour[0] !== lastFour[1] &&
    lastFour[0] !== lastFour[2] &&
    lastFour[0] !== lastFour[3] &&
    lastFour[1] !== lastFour[2] &&
    lastFour[1] !== lastFour[3] &&
    lastFour[2] !== lastFour[3]
  ) {
    console.log(i + 1);
    break;
  }
}
