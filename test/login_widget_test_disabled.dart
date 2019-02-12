import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_app/ui/pages/login/index.dart';

void main() {
  testWidgets('Login page', (WidgetTester tester) async {
    Key loginButtonKey = new UniqueKey();
    String value;

    await tester.pumpWidget(
        new MaterialApp(
          home: new Material(
            child: new LoginPage(
                loginButtonKey = loginButtonKey,
            ),
          ),
        ));
    expect(value, isNull);

    await tester.enterText(find.byKey(loginButtonKey), "test-todo\n");
    TextField f = tester.widget(find.byKey(loginButtonKey));
    f.onSubmitted(f.controller.value.text);
    expect(value, equals("test-todo"));

    // No toggle all button
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('Shows the toggle button', (WidgetTester tester) async {
    bool called = false;

    await tester.pumpWidget(
        new MaterialApp(
          home: new Material(
            child: new TodoHeaderWidget(
              showToggleAll: true,
              onChangeToggleAll: () {
                called = true;
              },
              onAddTodo: (title) {},
            ),
          ),
        ));
    expect(called, isFalse);

    await tester.tap(find.byType(IconButton));

    expect(called, isTrue);
  });
}