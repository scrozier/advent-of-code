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
    // positions - [east, north]
    this.currentPos = [0, 0];
    this.currentFacingDeg = 0;

    this.waypointPos = [10, 1];
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
          console.log("moving waypoint north %s...", instr.value);
          this.waypointPos = [this.waypointPos[0], this.waypointPos[1] + instr.value];
          break;
        case "S":
          console.log("moving waypoint south %s...", instr.value);
          this.waypointPos = [this.waypointPos[0], this.waypointPos[1] - instr.value];
          break;
        case "E":
          console.log("moving waypoint east %s...", instr.value);
          this.waypointPos = [this.waypointPos[0] + instr.value, this.waypointPos[1]];
          break;
        case "W":
          console.log("moving waypoint west %s...", instr.value);
          this.waypointPos = [this.waypointPos[0] - instr.value, this.waypointPos[1]];
          break;
        case "L":
          console.log("rotating waypoint left...");
          switch(instr.value) {
            case 90:
              this.waypointPos = [this.waypointPos[1] * -1, this.waypointPos[0]];
              break;
            case 180:
              this.waypointPos = [this.waypointPos[0] * -1, this.waypointPos[1] * -1];
              break;
            case 270:
              this.waypointPos = [this.waypointPos[1], this.waypointPos[0] * -1];
              break;
            default:
              console.log("bad value in case L");
          }
          break;
        case "R":
          console.log("rotating waypoint right...");
          switch(instr.value) {
            case 90:
              this.waypointPos = [this.waypointPos[1], this.waypointPos[0] * -1];
              break;
            case 180:
              this.waypointPos = [this.waypointPos[0] * -1, this.waypointPos[1] * -1];
              break;
            case 270:
              this.waypointPos = [this.waypointPos[1] * -1, this.waypointPos[0]];
              break;
            default:
              console.log("bad value in case L");
          }
          break;
        case "F":
          console.log("Moving Forward...");
          this.currentPos =
            [
              this.currentPos[0] + (instr.value * this.waypointPos[0]),
              this.currentPos[1] + (instr.value * this.waypointPos[1])
            ];
          break;
        default:
          console.log("I don't know how to do that yet!");
          break;
      }
      console.log("We're now at (%s, %s), facing %s",
      this.currentPos[0], this.currentPos[1], this.currentFacing());
      console.log("Wapoint is now at (%s, %s)", this.waypointPos[0], this.waypointPos[1]);
      console.log("\n");
    });

    // return final position
    return this.currentPos;
  }
}

var ship = new Ship(instructionsText);

const endPos = ship.sail();
console.log("The answer is %s", Math.abs(endPos[0]) + Math.abs(endPos[1]));
