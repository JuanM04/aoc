const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);

let floor = 0;

for (let i = 0; i < input.length; i++) {
  if (input[i] === "(") floor++;
  else floor--;

  if (floor === -1) {
    console.log(i + 1);
    break;
  }
}
