import { readFile } from "node:fs/promises";

const input = await readFile("./input.txt", { encoding: "utf-8" });

const left = [];
const right = new Map(); // Map<number, number>

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
