const classes = require("../../modules/gameConsole.js");
const { Instruction, GameConsole } = classes;

const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

const instructionText = inputData.split(/\n/);

const instructions = instructionText.map(i => new Instruction(i));

for (var index = 0; index < instructions.length; index++) {
  if (instructions[index].operation === "acc") { continue }
  
  var iterationInstructions = [];
  instructions.forEach(instruction => {
    iterationInstructions.push(new Instruction(instruction.itext));
  })

  iterationInstructions[index].operation =
    instructions[index].operation === "nop"
    ? "jmp"
    : "nop";
  const game = new GameConsole(iterationInstructions);
  const termination = game.run();
  if (termination.normalTermination) {
    console.log("Switching instruction %s, terminated normally with accumulator = %s",
      index, termination.accumulatorValue);
  }
};
