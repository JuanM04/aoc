const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

let currentElf = 0;
let maxElf = 0;

for (const line of lines) {
  if (line === "") {
    if (currentElf > maxElf) maxElf = currentElf;
    currentElf = 0;
  } else {
    currentElf += parseInt(line);
  }
}

console.log(maxElf);
