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
  if (contents === "no other") {
    return {
      container: container,
      contents: []
    };
  }

  contentsArray = contents.split(", ");

  contentElements = contentsArray.map(el => {
    const [, qty, bag] = el.match(/(\d) (.*)/);
    return {qty: parseInt(qty), bagColor: bag};
  });

  return {
    container: container,
    contents: contentElements,
  };
}

function bagCount(bagColor) {
  console.log("bagCounting %s", bagColor);
  if (containments[bagColor].contents.length === 0) {
    console.log("terminal node, count 0");
    return 0;
  }

  // already counted this node? if so return that count
  if (containments[bagColor].count) {
    return containments[bagColor].count;
  }

  // return a count of bags that must be in the given bagColor
  // (not including this bag itself; it should be counted in
  // the summing); save that count with the node
  const count = containments[bagColor].contents.reduce((total, current) => {
    return total + current.qty + (current.qty * bagCount(current.bagColor));
  }, 0);

  console.log("count: %s", count);
  containments[bagColor].count = count;
  return count;
}

const rawRules = inputData.split(/\n/);

var containments = {};
rawRules.forEach(rr => {
  const node = parseRule(rr);
  containments[node.container] = {
    contents: node.contents,
    count: null
  };
});

console.log("containments: %o", containments);

console.log("The answer is %s", bagCount("shiny gold"));