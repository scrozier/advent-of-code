const fs = require('fs')

var inputData;
try {
  inputData = fs.readFileSync('input', 'utf8');
} catch (err) {
  console.error(err);
}

// console.log(inputData);

var lines = inputData.split(/\r?\n/);

// lines.forEach(line => {
//   console.log(line);
// });

var numValid = 0;

// do for each line
lines.forEach(line => {
  // split into rule and password
  const [rule, password] = line.split(": ");

  const ruleLetter = rule[rule.length - 1]
  const ruleRange = rule.substring(0, rule.length - 2);
  const rulePieces = ruleRange.split("-");
  const ruleMin = parseInt(ruleRangePieces[0]);
  const ruleMax = parseInt(ruleRangePieces[1]);
  console.log("ruleLetter: %s, ruleMin: %s, ruleMax: %s", ruleLetter, ruleMin, ruleMax);

  // count target letters in password
  const passwordAsArray = password.split("");
  const targetCount = passwordAsArray.filter(char => (char === ruleLetter)).length;
  if (targetCount >= ruleMin && targetCount <= ruleMax) {numValid++}

});

console.log("The answer is %s correct.", numValid);
