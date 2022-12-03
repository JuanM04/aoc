const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

function getPriority(item: string): number {
  const n = item.charCodeAt(0);
  if (n >= 97) return n - 96; // a=97, b=98, ...
  else return n - 38; // a=65, b=66, ...
}

function getPriorityOfGroup(rucksacks: string[]): number {
  const itemTypes: Set<string>[] = [];

  for (const rucksack of rucksacks) {
    const items = new Set<string>();
    for (const item of rucksack) {
      items.add(item);
    }
    itemTypes.push(items);
  }

  for (const item of itemTypes[0].values()) {
    if (itemTypes.slice(1).every((items) => items.has(item))) {
      return getPriority(item);
    }
  }

  throw new Error("Couldn't find a common item for: " + rucksacks.join("\n"));
}

let sum = 0;
for (let i = 0; i < lines.length / 3; i++) {
  sum += getPriorityOfGroup(lines.slice(i * 3, (i + 1) * 3));
}

console.log(sum);
