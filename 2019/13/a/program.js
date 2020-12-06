var programIntegerArray = []

function initialize(programText) {
	var programIntegerArray = programText.split(",").map(element => parseInt(element));
}

function outputProgramArray() {
  programIntegerArray.forEach(function (element) {
    console.log(element);
  });
}

const fs = require('fs');
fs.readFile("/Users/scrozier/projects/advent/13/a/input.txt",
            "utf8",
            function(err, programString) {
              initialize(programString);
            }
);

outputProgramArray();
