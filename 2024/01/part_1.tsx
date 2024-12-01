const input = await Bun.file("./input.txt").text();

const left: number[] = [];
const right: number[] = [];

input.split("\n").forEach((row) => {
  if (row.length === 0) return;
  const [l, r] = row.split("   ");
  left.push(Number.parseInt(l, 10));
  right.push(Number.parseInt(r, 10));
});

left.sort((a, b) => a - b);
right.sort((a, b) => a - b);

let d = 0;
for (let i = 0; i < left.length; i++) {
  d += Math.abs(left[i] - right[i]);
}

console.log("d", d);
