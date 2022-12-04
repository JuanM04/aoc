import {
  crypto,
  toHashString,
} from "https://deno.land/std@0.167.0/crypto/mod.ts";

const input = await Deno.readTextFile(
  new URL(import.meta.resolve("./input.txt"))
);

const encoder = new TextEncoder();
async function hashMD5(input: string) {
  const hash = await crypto.subtle.digest("MD5", encoder.encode(input));
  return toHashString(hash, "hex");
}

for (let i = 0; i < Math.pow(10, input.length); i++) {
  const answer = (i + 1).toString();
  const hash = await hashMD5(input + answer);
  if (hash.startsWith("00000")) {
    console.log(answer);
    break;
  }
}
