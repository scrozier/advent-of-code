const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

const adaptersText = inputData.split(/\n/);
const adapters = adaptersText.map(a => (parseInt(a)));
console.log("adapters: %o", adapters);
const orderedAdapters = adapters.sort((a, b) => (a < b ? -1 : 1));
console.log("orderedAdapters: %o", orderedAdapters);

var jolt1Count = jolt3Count = 0;

// account for the first one
if (orderedAdapters[0] === 1) {jolt1Count++}
if (orderedAdapters[0] === 3) {jolt3Count++}

// loop through all adapters, starting with the *2nd* one,
for (var i = 1; i < orderedAdapters.length; i++) {
  if (orderedAdapters[i] - orderedAdapters[i - 1] === 1) {jolt1Count++}
  if (orderedAdapters[i] - orderedAdapters[i - 1] === 3) {jolt3Count++}
}

// account for the last one
jolt3Count++;

console.log("The answer is %s", jolt1Count * jolt3Count);
