const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

let overlaps = 0;

for (const pair of lines) {
  const [ai, af, bi, bf] = pair.split(/\D/g).map((str) => parseInt(str));

  if ((ai <= bi && af >= bi) || (bi <= ai && bf >= ai)) {
    overlaps++;
  }
}

console.log(overlaps);
