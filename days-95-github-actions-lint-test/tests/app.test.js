const { add } = require('../app');
function assertEqual(actual, expected, msg) {
  if (actual !== expected) { throw new Error(msg || `Expected ${expected}, got ${actual}`); }
}
assertEqual(add(2, 3), 5, 'add(2,3) should be 5');
console.log('All tests passed');
