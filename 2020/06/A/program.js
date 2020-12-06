const fs = require('fs');

function combineAnswers(answersByPerson) {
  var combined = [];
  answersByPerson.forEach(pa => {
    const answersAsArray = pa.split("");
    combined = combined.concat(answersAsArray);
  });
  return new Set(combined);
}

class Group {
  constructor(inputData) {
    this.personAnswers = inputData.split("\n");
    this.uniqueAnswers = combineAnswers(this.personAnswers);
    this.numUniqueAnswers = this.uniqueAnswers.size;
  }

}

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

const groupData = inputData.split(/\n\n/);
const groups = groupData.map(g => (new Group(g)));
const sumOfAnswers = groups.reduce((total, current) => {
  return total + current.numUniqueAnswers;
}, 0);
console.log("the answer is %s", sumOfAnswers);
