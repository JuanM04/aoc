const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

function getPriority(item: string): number {
  const n = item.charCodeAt(0);
  if (n >= 97) return n - 96; // a=97, b=98, ...
  else return n - 38; // a=65, b=66, ...
}

function findDuplicate(input: string): string {
  const a = input.slice(0, input.length / 2);
  const b = input.slice(input.length / 2);

  for (const c of a) {
    if (b.includes(c)) return c;
  }

  throw new Error("There wasn't a duplicate for: " + input);
}

const sum = lines.reduce(
  (total, rucksack) => total + getPriority(findDuplicate(rucksack)),
  0
);

console.log(sum);
