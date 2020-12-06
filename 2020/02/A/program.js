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
  const rulePositions = rule.substring(0, rule.length - 2);
  const rulePositionPieces = rulePositions.split("-");
  const ruleOffset1 = parseInt(rulePositionPieces[0]) - 1;
  const ruleOffset2 = parseInt(rulePositionPieces[1]) - 1;

  if ((password[ruleOffset1] === ruleLetter && password[ruleOffset2] !== ruleLetter) ||
      (password[ruleOffset2] === ruleLetter && password[ruleOffset1] !== ruleLetter)) {numValid++}
});

console.log("The answer is %s correct.", numValid);
