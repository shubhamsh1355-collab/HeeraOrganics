import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/core/widgets/app_empty_view.dart';
import 'package:heera_organics/data/repositories/order_repository.dart';
import 'package:heera_organics/features/orders/order_details_screen.dart';

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

  group('OrderDetailsScreen Navigation and Not Found Regression Tests', () {
    testWidgets(
      'Unknown order ID displays Order Not Found state and does not show another order',
      (WidgetTester tester) async {
        const unknownId = 'HO-ORD-UNKNOWN-999';

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: OrderDetailsScreen(orderId: unknownId)),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Order Not Found title and empty view
        expect(find.text('Order Not Found'), findsAtLeastNWidgets(1));
        expect(find.byType(AppEmptyView), findsOneWidget);
        expect(
          find.text(
            'The requested order "$unknownId" could not be found or does not exist.',
          ),
          findsOneWidget,
        );
        expect(find.text('View All Orders'), findsOneWidget);

        // Verify it does NOT render another order silently (such as HO-ORD-8921)
        expect(find.text('HO-ORD-8921'), findsNothing);
        expect(find.text('Delivery Address'), findsNothing);
        expect(find.text('Reorder All'), findsNothing);
      },
    );

    testWidgets('Valid order ID displays the correct order details and items', (
      WidgetTester tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final orders = container.read(orderProvider);
      expect(orders, isNotEmpty);
      final targetOrder = orders.first;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: OrderDetailsScreen(orderId: targetOrder.id)),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the order ID appears in the app bar
      expect(find.text(targetOrder.id), findsAtLeastNWidgets(1));
      expect(find.byType(AppEmptyView), findsNothing);

      // Verify items in the order are displayed
      for (final item in targetOrder.items) {
        expect(find.text(item.product.name), findsAtLeastNWidgets(1));
      }

      // Verify Reorder All button is present
      expect(find.text('Reorder All'), findsOneWidget);
    });
  });
}
