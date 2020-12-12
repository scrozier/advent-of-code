const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

const instructionsText = inputData.split(/\n/);

class Instruction {
  constructor(instructionText) {
    const [, action, value] = instructionText.match(/([NSEWLRF])(.*)/);
    this.action = action;
    this.value = parseInt(value);
  }
}

class Ship {
  constructor(instructionsText) {
    this.instructions = instructionsText.map(instr => (
      new Instruction(instr)
    ));
    // currentPos - [north/south, east/west]
    this.currentPos = [0, 0];
    this.currentFacingDeg = 0;
  }

  currentFacing() {
    if (this.currentFacingDeg === 0) { return "E" }
    if (this.currentFacingDeg === 90) { return "S" }
    if (this.currentFacingDeg === 180) { return "W" }
    if (this.currentFacingDeg === 270) { return "N" }
    console.log("bad in currentFacing()");
  }

  sail() {
    this.instructions.forEach(instr => {
      switch(instr.action) {
        case "N":
          console.log("Moving North...");
          this.currentPos = [this.currentPos[0] - instr.value, this.currentPos[1]];
          break;
        case "S":
          console.log("Moving South...");
          this.currentPos = [this.currentPos[0] + instr.value, this.currentPos[1]];
          break;
        case "E":
          console.log("Moving East...");
          this.currentPos = [this.currentPos[0], this.currentPos[1] + instr.value];
          break;
        case "W":
          console.log("Moving West...");
          this.currentPos = [this.currentPos[0], this.currentPos[1] - instr.value];
          break;
        case "L":
          console.log("Turning Left...");
          this.currentFacingDeg = (this.currentFacingDeg + 360 - instr.value) % 360;
          break;
        case "R":
          console.log("Turning Right...");
          this.currentFacingDeg = (this.currentFacingDeg + instr.value) % 360;
          break;
        case "F":
          console.log("Moving Forward...");
          switch(this.currentFacing()) {
            case "E":
              this.currentPos = [this.currentPos[0], this.currentPos[1] + instr.value];
              break;
            case "S":
              this.currentPos = [this.currentPos[0] + instr.value, this.currentPos[1]];
              break;
            case "W":
              this.currentPos = [this.currentPos[0], this.currentPos[1] - instr.value];
              break;
            case "N":
              this.currentPos = [this.currentPos[0] - instr.value, this.currentPos[1]];
              break;
            default:
              console.log("Weird direction in Moving Forward");
          }
          break;
        default:
          console.log("I don't know how to do that yet!");
          break;
      }
      console.log("We're now at (%s, %s), facing %s",
        this.currentPos[0], this.currentPos[1], this.currentFacing());
    });

    // return final position
    return this.currentPos;
  }
}

var ship = new Ship(instructionsText);

const endPos = ship.sail();
console.log("The answer is %s", endPos[0] + endPos[1]);
