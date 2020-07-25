import 'package:first_app/ui/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/ui/theme/style.dart';

// Helper function to encapsulate code needed to instantiate the widget
dynamic initWidget(WidgetTester tester) {
  return tester.pumpWidget(
    new MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: appTheme,
      home: new CustomDialog(
          title: 'Title', description: 'Description', buttonText: 'buttonText'),
    ),
  );
}

// Note that we are skipping testing of image here, just lazy...
void main() async {
  testWidgets('CustomDialog', (WidgetTester tester) async {
    await initWidget(tester);
    await tester.pump();
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(SelectableText), findsOneWidget);
  });
}
