const fs = require('fs')

var inputData;
try {
  inputData = fs.readFileSync('input', 'utf8');
} catch (err) {
  console.error(err);
}

var passports = inputData.split("\n\n");

passports.forEach((passport, passportNumber) => {
  console.log("Passport %s: %s", passportNumber, passport);
});

// const requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"];

var numValid = 0;

const validPassports = passports.filter(passport => (
  passport.includes("byr:") &&
  passport.includes("iyr:") &&
  passport.includes("eyr:") &&
  passport.includes("hgt:") &&
  passport.includes("hcl:") &&
  passport.includes("ecl:") &&
  passport.includes("pid:")
));

console.log("The number of valid passports is %s", validPassports.length);
