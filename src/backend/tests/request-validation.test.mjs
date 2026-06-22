import test from 'node:test';
import assert from 'node:assert/strict';

const isValidTodoText = (value) => typeof value === 'string' && value.trim().length > 0 && value.trim().length <= 200;
const isValidChecked = (value) => typeof value === 'boolean';

test('accepts valid todo text', () => {
  assert.equal(isValidTodoText('Prepare deployment checklist'), true);
});

test('rejects empty todo text', () => {
  assert.equal(isValidTodoText('   '), false);
});

test('rejects todo text longer than 200 characters', () => {
  assert.equal(isValidTodoText('a'.repeat(201)), false);
});

test('requires checked to be boolean on update', () => {
  assert.equal(isValidChecked(true), true);
  assert.equal(isValidChecked('true'), false);
});
