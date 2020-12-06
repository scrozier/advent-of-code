// BFFFBBFRRR: row 70, column 7, seat ID 567.
// FFFBBBFRRR: row 14, column 7, seat ID 119.
// BBFFBBFRLL: row 102, column 4, seat ID 820.

const fs = require('fs');
const { parse } = require('path');

var inputData;
try {
  inputData = fs.readFileSync('input', 'utf8');
} catch (err) {
  console.error(err);
}

var boardingPassesCoded = inputData.split(/\r?\n/);

const boardingPasses = boardingPassesCoded.map(bp => {
  const doneF = bp.replace(/F/g, "0");
  const doneFB = doneF.replace(/B/g, "1");
  const doneFBR = doneFB.replace(/R/g, "1");
  const binaryCode = doneFBR.replace(/L/g, "0");
  const rowCode = binaryCode.substring(0, 7);
  const colCode = binaryCode.substring(7);
  console.log("rowCode: %s, columnCode: %s", rowCode, colCode);
  const row = parseInt(rowCode, 2);
  const col = parseInt(colCode, 2);
  console.log("row: %s, col: %s", row, col);
  return {
    code: bp,
    row: row,
    col: col,
    seatId: (row * 8) + col
  };
});

boardingPasses.forEach(bp => {
  console.log("%s: row %s, seat %s, seat ID: %s",
  bp.code, bp.row, bp.col, bp.seatId);
});

const seatIds = boardingPasses.map(bp => (bp.seatId));

for (var i = 0; i <= 974; i++) {
  const found = seatIds.find(sid => (sid === i));
  if (!found) { console.log("There is no %s", i) }
}