const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);

function noRepeats(str: string): boolean {
  const set = new Set(str.split(""));
  return set.size === str.length;
}

for (let i = 13; i < input.length; i++) {
  const lastFourteen = input.slice(i - 13, i + 1);
  if (noRepeats(lastFourteen)) {
    console.log(i + 1);
    break;
  }
}
