exports.Instruction = class Instruction {
  constructor(itext) {
    this.itext = itext;
    const [, otext, atext] = itext.match(/^([a-z]{3}) (.*)$/);
    this.operation = otext;
    this.argument = parseInt(atext);
    this.hasBeenRun = false;
  }
}
  
exports.GameConsole = class GameConsole {
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
