const fs = require('fs');
var SortedArray = require("collections/sorted-array");
const { exit } = require('process');
// addEach, deleteEach, add, delete, has

// const MODE = "sample";
const MODE = "full";

const INPUT_FILE = MODE === "full" ? "../input" : "../input-sample2";

var inputData;
try {
  inputData = fs.readFileSync(INPUT_FILE, 'utf8');
} catch (err) {
  console.error(err);
}

// numbers is the input array, to walked through from [0] to
// [length - 1]
const numberText = inputData.split(/\n/);
const numbers = numberText.map(el => parseInt(el));

const TARGET = MODE === "full" ? 41682220 : 127;

// i is the starting number of current series being examined
for (var i = 0; i < numbers.length; i++) {
  for (var j = i + 1; j < numbers.length; j++) {
    const addends = numbers.slice(i, j + 1);
    // console.log("addends: %o", addends);
    const sum = addends.reduce((sum, current) => sum + current, 0);
    // console.log("sum: %s", sum);
    if (sum === TARGET) {
      console.log("The answer is %s", Math.min(...addends) + Math.max(...addends));
      ;
    }
    if (sum > TARGET) { continue }
  }
}
