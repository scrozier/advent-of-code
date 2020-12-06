const fs = require('fs')

var inputData;
try {
  inputData = fs.readFileSync('input-sample1', 'utf8');
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
var currentCol = 0;
var numTrees = 0;

map.forEach((row, rowNum) => {
  if (treeAt(currentCol, rowNum) && (rowNum % down === 0)) {numTrees++}
  currentCol += right;
});
return numTrees;
}

console.log("For 1, 1 the answer is %s trees", countTrees(1, 1));
console.log("For 3, 1 the answer is %s trees", countTrees(3, 1));
console.log("For 5, 1 the answer is %s trees", countTrees(5, 1));
console.log("For 7, 1 the answer is %s trees", countTrees(7, 1));
console.log("For 1, 2 the answer is %s trees", countTrees(1, 2));

// Right 1, down 1.
// Right 3, down 1.
// Right 5, down 1.
// Right 7, down 1.
// Right 1, down 2.
