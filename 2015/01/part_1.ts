const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);

let floor = 0;

for (const i of input) {
  if (i === "(") floor++;
  else floor--;
}

console.log(floor);
