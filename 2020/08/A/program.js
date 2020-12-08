const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

const instructionText = inputData.split(/\n/);
console.log("instructionText: %o", instructionText);

class Instruction {
  constructor(itext) {
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
    console.log("run...");

    while(true) {
      const instruction = this.instructions[this.nextInstruction];
      if (instruction.hasBeenRun) { break }

      // run the instruction and mark it executed
      console.log("running %o", instruction);

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
    console.log("DONE, accumulator = %s", this.accumulator);
  }
}

const instructions = instructionText.map(i => new Instruction(i));

const game = new GameConsole(instructions);
game.run();
