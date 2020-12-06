const fs = require('fs');
const { parse } = require('path');

var inputData;
try {
  inputData = fs.readFileSync('input', 'utf8');
} catch (err) {
  console.error(err);
}

var passports = inputData.split("\n\n");

function isValid(passport) {
  // break into key:value pairs in array
  const fieldArray = passport.match(/[a-z]{3}:(#|[0-9]|[a-z])*/g);
  // console.log("fieldArray: %o", fieldArray);

  // break into key/value pairs
  const keysAndValues = fieldArray.map(field => {
    const kvArray = field.split(":");
    return {key: kvArray[0], value: kvArray[1]};
  });
  // console.log("keysAndValues: %o", keysAndValues);

  return byrValid(keysAndValues) &&
         iyrValid(keysAndValues) &&
         eyrValid(keysAndValues) &&
         hgtValid(keysAndValues) &&
         hclValid(keysAndValues) &&
         eclValid(keysAndValues) &&
         pidValid(keysAndValues);
}

function byrValid(keysAndValues) {
  // key exists? if not return false
  const keyValue = keysAndValues.find(kv => (kv.key === "byr"));
  if (!keyValue) { return false };

  // number value between 1920 and 2002
  const value = parseInt(keyValue.value);
  if (value >= 1920 && value <= 2002) { return true } else { return false }
}

function iyrValid(keysAndValues) {
  // key exists? if not return false
  const keyValue = keysAndValues.find(kv => (kv.key === "iyr"));
  if (!keyValue) { return false };

  // number value between 2010 and 2020
  const value = parseInt(keyValue.value);
  if (value >= 2010 && value <= 2020) { return true } else { return false }
}

function eyrValid(keysAndValues) {
  // key exists? if not return false
  const keyValue = keysAndValues.find(kv => (kv.key === "eyr"));
  if (!keyValue) { return false };

  // number value between 2020 and 2030
  const value = parseInt(keyValue.value);
  if (value >= 2020 && value <= 2030) { return true } else { return false }
}

function hgtValid(keysAndValues) {
  // key exists? if not return false
  const keyValue = keysAndValues.find(kv => (kv.key === "hgt"));
  if (!keyValue) { return false };

  value = keyValue.value;
  const unit = value.substring(value.length - 2);
  const measurementString = value.substring(0, value.length - 2);
  const measurement = parseInt(measurementString);

  if (unit === "cm") {
    if (measurement >= 150 && measurement <= 193) { return true } else { return false }
  } 
  else {
    if (measurement >= 59 && measurement <= 76) { return true } else { return false }
  } 
}

function hclValid(keysAndValues) {
  // key exists? if not return false
  const keyValue = keysAndValues.find(kv => (kv.key === "hcl"));
  if (!keyValue) { return false };

  if (keyValue.value.match(/#[a-f|0-9]{6}/g)) { return true } else { return false }
}

function eclValid(keysAndValues) {
  // key exists? if not return false
  const keyValue = keysAndValues.find(kv => (kv.key === "ecl"));
  if (!keyValue) { return false };
  
  if (keyValue.value.match(/^amb$|^blu$|^brn$|^gry$|^grn$|^hzl$|^oth$/g)) { return true } else { return false }
}

function pidValid(keysAndValues) {
  // key exists? if not return false
  const keyValue = keysAndValues.find(kv => (kv.key === "pid"));
  if (!keyValue) { return false };
  
  if (keyValue.value.match(/^[0-9]{9}$/g)) { return true } else { return false }
}

const validPassports = passports.filter(passport => (isValid(passport)));

console.log("The number of valid passports is %s", validPassports.length);
