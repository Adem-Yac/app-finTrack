import 'package:fintrack/core/utils/money_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats Algerian dinar amounts', () {
    expect(MoneyFormat.da(125500), contains('DA'));
    expect(MoneyFormat.da(4500, withSign: true), contains('+'));
  });
}
