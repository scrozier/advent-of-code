const { groupCollapsed } = require('console');
const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

// light red bags contain 1 bright white bag, 2 muted yellow bags.
// dark orange bags contain 3 bright white bags, 4 muted yellow bags.
// bright white bags contain 1 shiny gold bag.
// muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
// shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
// dark olive bags contain 3 faded blue bags, 4 dotted black bags.
// vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
// faded blue bags contain no other bags.
// dotted black bags contain no other bags.

// {
//   "muted yellow": ["light red", "dark orange"],
//   "light red": ["strong white", "ocean blue", "deep purple"],
// }

function parseRule(rawRule) {
  const noPeriod = rawRule.slice(0, -1);
  const noBags = noPeriod.replace(/ bags?/g, "");
  var [container, contents] = noBags.split(" contain ");
  if (contents === "no other") { return null }
  const noQty = contents.replace(/\d /g, "");
  contentsArray = noQty.split(", ");

  var containments = contentsArray.map(ca => (
    {contained: ca, container: container}
  ));
  return containments;
}

function startingBags(nodeName) {
  // if it's a terminal node, its nodes are just itself
  // (no paths to it, but starting at it directly)
  if (!dag[nodeName]) { return new Set([nodeName]) }

  // if already calculated, return that value
  if (dag[nodeName].startingBags) { return dag[nodeName].startingBags }
  
  // otherwise, calculate it, store it, and return it
  var candidateBags = [];
  dag[nodeName].nodes.forEach(node => {
    candidateBags = candidateBags.concat(Array.from(startingBags(node)));
  });

  // add one for all nodes but the terminal one,
  // because you can always start at that node directly
  if (nodeName !== "shiny gold") { candidateBags.push(nodeName) }

  // make into Set, which will make it a unique collection
  nodeSet = new Set(candidateBags);

  // update the dag node
  dag[nodeName].startingBags = nodeSet;

  return nodeSet;
}

const rawRules = inputData.split(/\n/);

var containments = [];
rawRules.forEach(rr => {
  containments = containments.concat(parseRule(rr))
  .filter(el => (el !== null));
});

// create DAG
dag = {};
containments.forEach(cont => {
  if (!dag[cont.contained]) {
    dag[cont.contained] = {
      nodes: new Set([]),
      pathCount: null,
    };
  }
  dag[cont.contained].nodes = dag[cont.contained].nodes.add(cont.container);
});
console.log("dag: %o", dag);

// now the answer is the number of paths to "shiny gold"
console.log("The answer is %s ways to contain shiny gold.",
  startingBags("shiny gold").size);
