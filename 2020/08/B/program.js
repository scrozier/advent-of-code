const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

const instructionText = inputData.split(/\n/);

class Instruction {
  constructor(itext) {
    this.itext = itext;
    const [, otext, atext] = itext.match(/^([a-z]{3}) (.*)$/);
    this.operation = otext;
    this.argument = parseInt(atext);
    this.hasBeenRun = false;
  }
}

class GameConsole {
  constructor(instructions) {
    this.instructions = instructions;
    this.accumulator = 0;
    this.nextInstruction = 0;
  }

  run() {
    while(true) {
      const instruction = this.instructions[this.nextInstruction];

      if (this.nextInstruction >= this.instructions.length) {
        return {normalTermination: true, accumulatorValue: this.accumulator};
      }

      if (instruction.hasBeenRun) {
        return {normalTermination: false};
      }

      // run the instruction and mark it executed
      if (instruction.operation === "nop") {
        this.nextInstruction++;
      }

      if (instruction.operation === "acc") {
        this.accumulator += instruction.argument;
        this.nextInstruction++;
      }

      if (instruction.operation === "jmp") {
        this.nextInstruction += instruction.argument;
      }

      instruction.hasBeenRun = true;
    }
  }
}

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
