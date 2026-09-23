const test = require('node:test');
const assert = require('node:assert');

test('basic sanity check', () => {
  assert.strictEqual(1 + 1, 2);
});

test('express can be loaded', () => {
  const express = require('express');
  assert.ok(express);
});
