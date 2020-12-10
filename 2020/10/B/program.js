const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

class Adapter {
  constructor(jolts, indexPos) {
    this.jolts = jolts;
    this.indexPos = indexPos;
    this.storedP = indexPos === 0 ? 1 : null;
  }

  // c: list of adapters this adapter can connect *from* directly,
  // which is any smaller adapters (lower indexes) within 3 jolts
  c() {
    var directs = [];
    for (var i = this.indexPos - 1; i >= 0; i--) {
      if (this.jolts - adapters[i].jolts > 3) { break }
      directs.push(adapters[i]);
    }
    return directs;
  }

  p() {
    if (this.storedP) { return this.storedP }
    if (this.indexPos === 0) { return 1 }
    const directs = this.c();
    const thisP = directs.reduce((total, current) => (
      total + current.p()
    ), 0);
    this.storedP = thisP;
    return thisP;
  }
}

const joltsText = inputData.split(/\n/);
const jolts = joltsText.map(a => (parseInt(a)));
const orderedJolts = jolts.sort((a, b) => (a < b ? -1 : 1));

// add charging outlet, starts at 0
orderedJolts.unshift(0);

// add one to the end to represent our builtin
orderedJolts.push(orderedJolts[orderedJolts.length - 1] + 3);

// create Adapter array to match
var adapters = orderedJolts.map((j, index) => (new Adapter(j, index)));
// console.log("adapters: %o", adapters);

// adapters.forEach(a => {console.log("adapter %s, c = %o, p = %s", a.indexPos, a.c(), a.p())});

console.log("The answer is %s", adapters[adapters.length - 1].p());
console.log("The adapters are now %o", adapters);

// console.log("adapter %o, p is %o", adapters[2], adapters[2].p());