const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

function isNice(str: string): boolean {
  let doublePair = false;
  let sandwich = false;
  const pairs: string[] = [];

  for (let i = 0; i < str.length; i++) {
    if (!doublePair) {
      const pair = str.slice(i, i + 2);
      const double = pairs.indexOf(pair);
      if (double !== -1 && i - double !== 1) doublePair = true;
      else pairs.push(pair);
    }
    if (!sandwich && str[i] === str[i + 2]) sandwich = true;
  }

  return doublePair && sandwich;
}

const total = lines.filter(isNice).length;

console.log(total);
