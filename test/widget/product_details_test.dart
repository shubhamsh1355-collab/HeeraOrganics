import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/core/widgets/app_empty_view.dart';
import 'package:heera_organics/data/mock/mock_data.dart';
import 'package:heera_organics/features/product_details/product_details_screen.dart';

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
    return _createMockHttpClient();
  }
}

HttpClient _createMockHttpClient() {
  return _MockHttpClient();
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

  group('ProductDetailsScreen Regression Tests', () {
    testWidgets(
      'Displays clear Product Not Found state for invalid product ID',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: ProductDetailsScreen(productId: 'non_existent_id'),
            ),
          ),
        );

        // Verify that Product Not Found is displayed
        expect(find.text('Product Not Found'), findsAtLeastNWidgets(1));
        expect(find.byType(AppEmptyView), findsOneWidget);
        expect(
          find.text(
            'The requested harvest item is currently unavailable or does not exist.',
          ),
          findsOneWidget,
        );
        expect(find.text('Back to Fresh Produce'), findsOneWidget);

        // Verify it does NOT silently render tomato or any other product details
        expect(find.text('Country Tomatoes (Local Nati)'), findsNothing);
        expect(find.text('Add to Basket'), findsNothing);
      },
    );

    testWidgets('Displays correct pack options and details for valid product', (
      WidgetTester tester,
    ) async {
      final milk = MockData.products.firstWhere((p) => p.id == 'prod_milk');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: ProductDetailsScreen(productId: milk.id)),
        ),
      );
      await tester.pumpAndSettle();

      // Verify product name and farm origin
      expect(find.text(milk.name), findsAtLeastNWidgets(1));
      expect(find.text(milk.farmOrigin), findsAtLeastNWidgets(1));

      // Verify pack options are rendered as chips
      for (final pack in milk.packOptions) {
        expect(find.text(pack.label), findsAtLeastNWidgets(1));
      }

      // Verify Add to Basket button is present
      expect(find.text('Add to Basket'), findsOneWidget);
    });
  });
}
