const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

// 'from' number between 1 and 3
// 1 --> 2 --> 3
//   <--------
function move(from: number, steps: number) {
  const final = (from + steps) % 3;
  return final > 0 ? final : 3 - final;
}

function parseRound(input: string) {
  const opponent = input.charCodeAt(0) - 64; // numbers from 1 to 3
  const movement = input.charCodeAt(2) - 88; // number from 0 to 2
  const me = move(opponent, movement - 1);

  return me + movement * 3;
}

const total = lines.reduce((total, round) => total + parseRound(round), 0);

console.log(total);
