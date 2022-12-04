const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

const vowels = "aeiou";
const naughtyPairs = ["ab", "cd", "pq", "xy"];

function isNice(str: string): boolean {
  let vowelsFound = 0;
  let pairedLetters = false;

  for (let i = 0; i < str.length; i++) {
    const current = str[i];
    const next = str[i + 1] || "";

    if (naughtyPairs.includes(current + next)) return false;
    if (vowels.includes(current)) vowelsFound++;
    if (current === next) pairedLetters = true;
  }

  return vowelsFound >= 3 && pairedLetters;
}

const total = lines.filter(isNice).length;

console.log(total);
