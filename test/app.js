const test = require('node:test');
const assert = require('node:assert');

test('sanity check: 1 + 1 = 2', () => {
  assert.strictEqual(1 + 1, 2);
});