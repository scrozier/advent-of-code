const fs = require('fs')

var inputData;
try {
  inputData = fs.readFileSync('input', 'utf8');
} catch (err) {
  console.error(err);
}

console.log(inputData);

var lines = inputData.split(/\r?\n/);
lines.pop();
var numbers = lines.map(line => (parseInt(line)));
numbers.forEach((number, index) => {
  console.log("value %s is a %s", number, typeof number);
});

for (var iIndex = 0; iIndex < numbers.length; iIndex++) {
  for (var jIndex = iIndex + 1; jIndex < numbers.length; jIndex++) {
    var i = numbers[iIndex];
    var j = numbers[jIndex];
    if (i + j === 2020) {
      console.log("The answer is %s", i * j);
    }
  }
}

