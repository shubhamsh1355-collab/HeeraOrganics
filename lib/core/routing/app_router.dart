import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/addresses/saved_addresses_screen.dart';
import '../../features/authentication/phone_otp_login_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/checkout/order_confirmation_screen.dart';
import '../../features/delivery_area/location_delivery_area_screen.dart';
import '../../features/farm_assistant/farm_assistant_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/splash_welcome_screen.dart';
import '../../features/orders/order_details_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/product_details/product_details_screen.dart';
import '../../features/product_listing/product_listing_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/referral/refer_earn_screen.dart';
import '../../features/search/search_discovery_screen.dart';
import '../../features/support/faqs_screen.dart';
import '../../features/support/help_support_screen.dart';
import '../../features/wishlist/wishlist_screen.dart';
import 'main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Onboarding & Auth Flow
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashWelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const PhoneOtpLoginScreen(),
    ),
    GoRoute(
      path: '/location',
      builder: (context, state) => const LocationDeliveryAreaScreen(),
    ),

    // Stateful Navigation Shell with Bottom Nav (5 Branches)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tab 1: Categories
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoriesScreen(),
            ),
          ],
        ),
        // Tab 2: Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchDiscoveryScreen(),
            ),
          ],
        ),
        // Tab 3: Orders
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        // Tab 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Push routes
    GoRoute(
      path: '/products',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'];
        return ProductListingScreen(initialCategoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/product/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'prod_tomato';
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/products/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'prod_tomato';
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/order-confirmation',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? 'HO-ORD-DEMO';
        return OrderConfirmationScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/order/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return OrderDetailsScreen(orderId: id);
      },
    ),
    GoRoute(
      path: '/profile/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/addresses',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SavedAddressesScreen(),
    ),
    GoRoute(
      path: '/wishlist',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/referral',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReferEarnScreen(),
    ),
    GoRoute(
      path: '/support',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: '/faqs',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FaqsScreen(),
    ),
    GoRoute(
      path: '/farm-assistant',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FarmAssistantScreen(),
    ),
    GoRoute(
      path: '/support/chat',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FarmAssistantScreen(),
    ),
  ],
);
