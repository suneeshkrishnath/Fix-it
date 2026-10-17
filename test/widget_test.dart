import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fix_it/app/app.dart';

void main() {
  testWidgets('renders the Fix-it prototype home screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FixItApp()),
    );

    expect(find.text('Fix-it'), findsWidgets);
    expect(find.text('Apartment service prototype'), findsOneWidget);
  });
}
