import 'package:first_app/ui/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first_app/ui/theme/style.dart';

// Helper function to encapsulate code needed to instantiate the widget
dynamic initWidget(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme,
      home: const CustomDialog(
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
