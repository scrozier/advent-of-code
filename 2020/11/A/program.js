const fs = require('fs');

var inputData;
try {
  inputData = fs.readFileSync('../input', 'utf8');
} catch (err) {
  console.error(err);
}

const rowsData = inputData.split(/\n/);

class Layout {
  constructor(rowData) {
    this.rowData = rowData;
    this.rows = rowData.map(row => (row.split("")));
  }

  numRows() {
    return this.rows.length;
  }

  numCols() {
    return this.rows[0].length;
  }

  statusAt(row, col) {
    return this.rows[row][col];
  }

  clone() {
    const clonedLayout = this.rows.map(row => row.join(""));
    return new Layout(clonedLayout);
  }

  occupiedSeatCount() {
    var count = 0;
    for (var i = 0; i < this.numRows(); i++) {
      for (var j = 0; j < this.numCols(); j++) {
        if (this.rows[i][j] === "#") { count++ }
      }
    }
    return count;
  }

  numAdjacentOccupied(row, col) {
    var count = 0;
    // start to the N, -1, 0
    if (row !== 0 &&
      this.rows[row - 1][col] === "#") { count++ }
    // NE: -1, +1
    if (row !== 0 && col !== this.numCols - 1 &&
      this.rows[row - 1][col + 1] === "#") { count++ }
    // E:   0, +1
    if (col !== this.numCols() - 1 &&
      this.rows[row][col + 1] === "#") { count++ }
    // SE: +1, +1
    if (row !== this.numRows() - 1 && col !== this.numCols - 1 &&
      this.rows[row + 1][col + 1] === "#") { count++ }
    // S:  +1,  0
    if (row !== this.numRows() - 1 &&
      this.rows[row + 1][col] === "#") { count++ }
    // SW: +1, -1
    if (row !== this.numRows() - 1 && col !== 0 &&
      this.rows[row + 1][col - 1] === "#") { count++ }
    // W:   0, -1
    if (col !== 0 &&
      this.rows[row][col - 1] === "#") { count++ }
    // NW: -1, -1
    if (row !== 0 && col !== 0 &&
      this.rows[row - 1][col - 1] === "#") { count++ }

    return count;
  }

  // return a new Layout, transformed by the rules
  transform() {
    var transformedLayout = this.clone();
    for (var i = 0; i < this.numRows(); i++) {
      for (var j = 0; j < this.numCols(); j++) {
        const seat = this.rows[i][j];
        if (seat === "L") {
          if (this.numAdjacentOccupied(i, j) === 0) {
            Layout.set(transformedLayout, i, j, "#");
          }
        }
        if (seat === "#") {
          if (this.numAdjacentOccupied(i, j) >= 4) {
            Layout.set(transformedLayout, i, j, "L");
          }
        }
      }
    }
    return transformedLayout;
  }

  static set(layout, row, col, symbol) {
    layout.rows[row][col] = symbol;
  }

  static equal(a, b) {
    for (var i = 0; i < a.numRows(); i++) {
      for (var j = 0; j < a.numCols(); j++) {
        if (a.rows[i][j] !== b.rows[i][j]) {
          return false;
        }
      }
    }
    return true;
  }
}

var layout = new Layout(rowsData);

var sameAsLast = false;
while (!sameAsLast) {
  // transform layout -> transformedLayout
  const transformedLayout = layout.transform();
  // console.log("transformedLayout: %o", transformedLayout);

  // if they're equal, answer is the occupied seat count
  if (Layout.equal(transformedLayout, layout)) {
    console.log("Done, there are %s occupied seats.",
      transformedLayout.occupiedSeatCount());
    sameAsLast = true;
  }

  layout = transformedLayout;
}
