const input = await Bun.file("./input.txt").text();

const left: number[] = [];
const right: Map<number, number> = new Map();

input.split("\n").forEach((row) => {
  if (row.length === 0) return;
  const [l, r] = row.split("   ");
  left.push(Number.parseInt(l, 10));

  const rint = Number.parseInt(r, 10);
  const rcount = right.get(rint) ?? 0;
  right.set(rint, rcount + 1);
});

let s = 0;
for (let i = 0; i < left.length; i++) {
  s += left[i] * (right.get(left[i]) ?? 0);
}

console.log("s", s);
