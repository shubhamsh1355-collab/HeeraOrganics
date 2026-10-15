import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/core/widgets/product_card.dart';
import 'package:heera_organics/data/mock/mock_data.dart';
import 'package:heera_organics/data/repositories/cart_repository.dart';
import 'package:heera_organics/features/product_listing/product_listing_screen.dart';

// 1x1 transparent PNG for mock HTTP image loading in widget tests
final Uint8List _transparentPng = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  group('ProductListingScreen Multi-Pack Regression Tests', () {
    testWidgets(
      'Product card displays correct pack quantity and controls affect only the intended pack size',
      (WidgetTester tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final tomato = MockData.products.firstWhere(
          (p) => p.id == 'prod_tomato',
        );
        final defaultPack = tomato.defaultPackOption; // 500 g
        final secondPack = tomato.effectivePackOptions.firstWhere(
          (p) => p.id != defaultPack.id,
        ); // 1 kg

        // Pre-populate cart: 2 of 500g and 1 of 1kg
        container
            .read(cartProvider.notifier)
            .addItem(tomato, pack: defaultPack);
        container
            .read(cartProvider.notifier)
            .addItem(tomato, pack: defaultPack);
        container.read(cartProvider.notifier).addItem(tomato, pack: secondPack);

        // Verify initial setup in provider
        final initialCart = container.read(cartProvider);
        expect(initialCart.getItemQuantity(tomato.id, pack: defaultPack), 2);
        expect(initialCart.getItemQuantity(tomato.id, pack: secondPack), 1);
        expect(initialCart.getQuantity(tomato.id), 3);

        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: ProductListingScreen(initialCategoryId: 'cat_veg'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find the ProductCard for tomatoes
        final tomatoCardFinder = find.widgetWithText(ProductCard, tomato.name);
        expect(tomatoCardFinder, findsOneWidget);

        // The card must display packSize '500 g' and quantity '2' (NOT '3' which sums both packs)
        expect(
          find.descendant(
            of: tomatoCardFinder,
            matching: find.text(defaultPack.label),
          ),
          findsAtLeastNWidgets(1),
        );
        expect(
          find.descendant(of: tomatoCardFinder, matching: find.text('2')),
          findsOneWidget,
        );

        // Find the decrement button on the tomato card
        final decrementBtnFinder = find.descendant(
          of: tomatoCardFinder,
          matching: find.byIcon(Icons.remove),
        );
        expect(decrementBtnFinder, findsOneWidget);

        // Ensure visible and tap decrement on the tomato card
        await tester.ensureVisible(decrementBtnFinder);
        await tester.tap(decrementBtnFinder);
        await tester.pumpAndSettle();

        // Card should now show quantity '1'
        expect(
          find.descendant(of: tomatoCardFinder, matching: find.text('1')),
          findsOneWidget,
        );

        // Verify in the cart state:
        // defaultPack (500g) decremented to 1
        // secondPack (1kg) remains completely intact at 1
        final cartAfterDecrement = container.read(cartProvider);
        expect(
          cartAfterDecrement.getItemQuantity(tomato.id, pack: defaultPack),
          1,
        );
        expect(
          cartAfterDecrement.getItemQuantity(tomato.id, pack: secondPack),
          1,
        );
        expect(cartAfterDecrement.items.length, 2);

        // Find the increment button on the tomato card
        final incrementBtnFinder = find.descendant(
          of: tomatoCardFinder,
          matching: find.byIcon(Icons.add),
        );
        expect(incrementBtnFinder, findsOneWidget);

        // Ensure visible and tap increment on the tomato card
        await tester.ensureVisible(incrementBtnFinder);
        await tester.tap(incrementBtnFinder);
        await tester.pumpAndSettle();

        // Card should show quantity '2' again
        expect(
          find.descendant(of: tomatoCardFinder, matching: find.text('2')),
          findsOneWidget,
        );

        // Verify in cart state:
        // defaultPack increased back to 2, secondPack still strictly 1
        final cartAfterIncrement = container.read(cartProvider);
        expect(
          cartAfterIncrement.getItemQuantity(tomato.id, pack: defaultPack),
          2,
        );
        expect(
          cartAfterIncrement.getItemQuantity(tomato.id, pack: secondPack),
          1,
        );
      },
    );
  });
}
