const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

let currentElf = 0;
const elfs: number[] = [];

for (const line of lines) {
  if (line === "") {
    elfs.push(currentElf);
    currentElf = 0;
  } else {
    currentElf += parseInt(line);
  }
}

const top3 = elfs
  .sort((a, b) => b - a)
  .slice(0, 3)
  .reduce((total, n) => total + n, 0);

console.log(top3);
