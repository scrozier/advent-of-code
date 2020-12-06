const fs = require('fs');

// groups: [
//   Group { personAnswers: [ 'abc', [length]: 1 ] },
//   Group { personAnswers: [ 'a', 'b', 'c', [length]: 3 ] },
//   Group { personAnswers: [ 'ab', 'ac', [length]: 2 ] },
//   Group { personAnswers: [ 'a', 'a', 'a', 'a', [length]: 4 ] },
//   Group { personAnswers: [ 'b', [length]: 1 ] },
//   [length]: 5
// ]

function numCommonAnswers(group) {
  // in the beginning, all are possible
  var commonAnswers = new Array(26);
  for (var i = 0; i < commonAnswers.length; i++) {
    commonAnswers[i] = true;
  }

  var thisPersonAnswers;
  // for each person, eliminate those questions from
  // commonAnswers that this person did not answer yes;
  group.personsAnswers.forEach(personAnswers => {
    // initialize this person's answer array
    var thisPersonAnswers = new Array(26);
    for (var i = 0; i < personAnswers.length; i++) {
      personAnswers[i] = false;
    }
    
    // set to true just the ones they answered yes
    const personYesAnswers = personAnswers.split("");
    personYesAnswers.forEach(yesAnswer => {
      // calculate index from character code (-97)
      var questionIndex = yesAnswer.charCodeAt(0) - 97;
      thisPersonAnswers[questionIndex] = true;
    });

    for (var i = 0; i < commonAnswers.length; i++) {
      commonAnswers[i] = (!!commonAnswers[i] && !!thisPersonAnswers[i]);
    };

  });

  // count the trues left in commonAnswers and return that number
  return commonAnswers.filter(a => (a === true)).length;
}

class Group {
  constructor(inputData) {
    this.personsAnswers = inputData.split("\n");
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

var summedCommonAnswers = 0;
groups.forEach((group, groupNum) => {
  summedCommonAnswers += numCommonAnswers(group);
});

console.log("The answer is %s", summedCommonAnswers);