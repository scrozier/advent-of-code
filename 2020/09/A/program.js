const fs = require('fs');
var SortedArray = require("collections/sorted-array");
// addEach, deleteEach, add, delete, has

// const MODE = "sample";
const MODE = "full";

const WINDOW_LENGTH = MODE === "full" ? 25 : 5;
const INPUT_FILE = MODE === "full" ? "../input" : "../input-sample1";

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

// i is the index into numbers of the number currently being examined
for (var i = 0; i < numbers.length; i++) {
  const undCon = numbers[i]; // the number under consideration

  // if we're in the preamble, we can skip the validity test; otherwise,
  // test for validity; print undCon and stop if not valid
  if (i >= WINDOW_LENGTH) {
    // calculate all the combinations of the previous WINDOW numbers
    var availableSums = new SortedArray();
    for (var j = i - 1; j >= i - WINDOW_LENGTH; j--) {
      for (var k = j - 1; k >= i - WINDOW_LENGTH; k--) {
        availableSums.add(numbers[j] + numbers[k]);
      }
    }

    // console.log("i = %s", i);
    // availableSums.forEach(el => {
    //   console.log(el);
    // });
    if (!availableSums.has(undCon)) {
      console.log("The first invalid number is %s", undCon);
      break;
    }
  }
}
