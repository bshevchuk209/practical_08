import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical_08/main.dart';

void main() {
  testWidgets('All authentication screens and back navigation', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byKey(const ValueKey('email')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('signup')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('name')), findsOneWidget);
    await tester.tap(find.text('Назад до входу'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('reset')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('password')), findsNothing);
    await tester.tap(find.text('Назад до входу'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('password')), findsOneWidget);
  });
  testWidgets('Required fields, invalid email, short and valid password', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byKey(const ValueKey('submit')));
    await tester.pumpAndSettle();
    expect(find.text('Обов’язкове поле'), findsNWidgets(2));
    await tester.enterText(find.byKey(const ValueKey('email')), 'invalid');
    await tester.enterText(find.byKey(const ValueKey('password')), '123456');
    await tester.tap(find.byKey(const ValueKey('submit')));
    await tester.pumpAndSettle();
    expect(find.text('Введіть коректний email'), findsOneWidget);
    expect(find.text('Щонайменше 7 символів'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('email')),
      'bohdan@example.com',
    );
    await tester.enterText(find.byKey(const ValueKey('password')), '1234567');
    await tester.tap(find.byKey(const ValueKey('submit')));
    await tester.pumpAndSettle();
    expect(find.text('Навчальна демонстрація'), findsOneWidget);
  });
  testWidgets('Signup and reset validate all fields', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byKey(const ValueKey('signup')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('submit')));
    await tester.pumpAndSettle();
    expect(find.text('Обов’язкове поле'), findsNWidgets(3));
    await tester.tap(find.text('Назад до входу'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('reset')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('email')), 'wrong@');
    await tester.tap(find.byKey(const ValueKey('submit')));
    await tester.pumpAndSettle();
    expect(find.text('Введіть коректний email'), findsOneWidget);
  });
}
