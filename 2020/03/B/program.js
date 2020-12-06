const fs = require('fs')

var inputData;
try {
  inputData = fs.readFileSync('input', 'utf8');
} catch (err) {
  console.error(err);
}

var map = inputData.split(/\r?\n/);

const rowLength = map[0].length;

function treeAt(col, row) {
  const normalizedCol = col % rowLength;
  return map[row].charAt(normalizedCol) === "#";
}

function countTrees(right, down) {
  var col = 0;
  var numTrees = 0;

  for (var row = 0; row < map.length; row = row + down) {
      if (treeAt(col, row)) {numTrees++}
      col += right;
  }

  return numTrees;
}

const a1 = countTrees(1, 1);
const a2 = countTrees(3, 1);
const a3 = countTrees(5, 1);
const a4 = countTrees(7, 1);
const a5 = countTrees(1, 2);

console.log("The answer is %s x %s x %s x %s x %s = %s",
a1, a2, a3, a4, a5, a1 * a2 * a3 * a4 * a5);
