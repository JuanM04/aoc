const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const [initialConditions, instructions] = input
  .split("\n\n")
  .map((block) => block.split("\n"));

const stack = new Array(initialConditions.at(-2)!.split(" ").length)
  .fill(undefined)
  .map(() => [] as string[]);

for (let i = initialConditions.length - 2; i >= 0; i--) {
  const line = initialConditions[i];
  for (let j = 0; j < stack.length; j++) {
    const crate = line.slice(j * 4 + 1, j * 4 + 2);
    if (crate !== " ") stack[j].push(crate);
  }
}

const instructionRegex = /^move (?<len>\d+) from (?<from>\d+) to (?<to>\d+)$/;
for (const instruction of instructions) {
  const parsed = instruction.match(instructionRegex)!.groups!;
  const len = parseInt(parsed.len);
  const from = parseInt(parsed.from) - 1;
  const to = parseInt(parsed.to) - 1;

  for (let i = 0; i < len; i++) {
    stack[to].push(stack[from].pop()!);
  }
}

const topCrates = stack.map((crates) => crates.at(-1)!).join("");

console.log(topCrates);
