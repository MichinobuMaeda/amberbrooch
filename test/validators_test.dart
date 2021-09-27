import 'package:flutter_test/flutter_test.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('validateRequired return false for null or empty.', () {
    expect(validateRequired('a'), true);
    expect(validateRequired(''), false);
    expect(validateRequired(null), false);
  });
  test('validateEmail return false for invalid email format.', () {
    expect(validateEmail(''), true);
    expect(validateEmail(null), true);
    expect(validateEmail('abc@def.ghi'), true);
    expect(validateEmail('a@b.c'), true);
    expect(validateEmail('@def.ghi'), false);
    expect(validateEmail('abc@.ghi'), false);
    expect(validateEmail('abc@def.'), false);
    expect(validateEmail('abc@def'), false);
    expect(validateEmail('abc'), false);
  });
  test('validatePasswordChar return false unsatisfying password chars.', () {
    expect(validatePasswordChar(''), true);
    expect(validatePasswordChar(null), true);
    expect(validatePasswordChar('Aa1'), true);
    expect(validatePasswordChar('a1@'), true);
    expect(validatePasswordChar('1@A'), true);
    expect(validatePasswordChar('@Aa'), true);
    expect(validatePasswordChar('Aa1@'), true);
    expect(validatePasswordChar('Aa'), false);
    expect(validatePasswordChar('a1'), false);
    expect(validatePasswordChar('1@'), false);
    expect(validatePasswordChar('@A'), false);
    expect(validatePasswordChar('A'), false);
    expect(validatePasswordChar('a'), false);
    expect(validatePasswordChar('1'), false);
    expect(validatePasswordChar('@'), false);
    expect(validatePasswordChar(' Aa1@'), false);
    expect(validatePasswordChar('A a1@'), false);
    expect(validatePasswordChar('Aa1@ '), false);
    expect(validatePasswordChar(' '), false);
    expect(validatePasswordChar('\n'), false);
    expect(validatePasswordChar('\r'), false);
    expect(validatePasswordChar('\t'), false);
  });
}
