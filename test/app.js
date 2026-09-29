const test = require('node:test');
const assert = require('node:assert');

test('sanity check: 2 + 2 = 4', () => {
  assert.strictEqual(2 + 2, 4);
});