const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);
const lines = input.split("\n");

// numbers between 1 and 3
// 1 --> 2 --> 3
//   <--------
function distance(from: number, to: number) {
  if (from > to) return to - from + 3;
  else return to - from;
}

function parseRound(input: string) {
  // Both numbers from 1 to 3
  const opponent = input.charCodeAt(0) - 64;
  const me = input.charCodeAt(2) - 87;

  // Given the cyclic nature of rock-paper-scissors,
  // when the linear distance from the move chosen by the opponent
  // to the move chosen by me is 1, I won. It it's 2, they won; otherwise,
  // it's a draw.
  return me + [3, 6, 0][distance(opponent, me)];
}

const total = lines.reduce((total, round) => total + parseRound(round), 0);

console.log(total);
