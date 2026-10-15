import '../models/category.dart';
import '../models/delivery_address.dart';
import '../models/delivery_slot.dart';
import '../models/faq_item.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

class MockData {
  static const List<Category> categories = [
    Category(
      id: 'cat_veg',
      name: 'Fresh Vegetables',
      iconUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=150',
      bannerText: 'Harvested daily at 5:00 AM from local organic farms',
      subcategories: [
        Subcategory(
          id: 'sub_all_veg',
          name: 'All Vegetables',
          icon: 'all_inclusive',
        ),
        Subcategory(id: 'sub_leafy', name: 'Leafy Greens', icon: 'eco'),
        Subcategory(id: 'sub_root', name: 'Root Veggies', icon: 'grass'),
        Subcategory(id: 'sub_gourd', name: 'Gourds & Squash', icon: 'spa'),
        Subcategory(id: 'sub_exotic', name: 'Organic Exotics', icon: 'star'),
      ],
    ),
    Category(
      id: 'cat_dairy',
      name: 'Farm Fresh Dairy',
      iconUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=150',
      bannerText: 'Unadulterated A2 milk & dairy in reusable glass bottles',
      subcategories: [
        Subcategory(id: 'sub_milk', name: 'A2 Milk', icon: 'water_drop'),
        Subcategory(id: 'sub_curd', name: 'Curd & Chaas', icon: 'local_cafe'),
        Subcategory(
          id: 'sub_paneer',
          name: 'Fresh Paneer',
          icon: 'lunch_dining',
        ),
        Subcategory(id: 'sub_ghee', name: 'Bilona Ghee', icon: 'local_dining'),
      ],
    ),
    Category(
      id: 'cat_fruits',
      name: 'Seasonal Fruits',
      iconUrl:
          'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=150',
      bannerText: 'Tree-ripened, naturally sweet & chemical-free',
      subcategories: [
        Subcategory(
          id: 'sub_seasonal',
          name: 'In Season Now',
          icon: 'wb_sunny',
        ),
        Subcategory(
          id: 'sub_citrus',
          name: 'Citrus & Melons',
          icon: 'brightness_5',
        ),
        Subcategory(
          id: 'sub_berries',
          name: 'Berries & Tropical',
          icon: 'favorite',
        ),
      ],
    ),
    Category(
      id: 'cat_staples',
      name: 'Grains & Dals',
      iconUrl:
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=150',
      bannerText: 'Heirloom seeds, unpolished pulses & unbleached grains',
      subcategories: [
        Subcategory(id: 'sub_dal', name: 'Organic Dals', icon: 'grain'),
        Subcategory(id: 'sub_rice', name: 'Heirloom Rice', icon: 'rice_bowl'),
        Subcategory(
          id: 'sub_flour',
          name: 'Stone Ground Atta',
          icon: 'breakfast_dining',
        ),
      ],
    ),
    Category(
      id: 'cat_oils',
      name: 'Cold-Pressed Oils',
      iconUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=150',
      bannerText: 'Wood-churned traditional kachi ghani oils',
      subcategories: [
        Subcategory(
          id: 'sub_wood_pressed',
          name: 'Wood Pressed Oils',
          icon: 'opacity',
        ),
      ],
    ),
  ];

  static const List<Product> products = [
    Product(
      id: 'prod_tomato',
      name: 'Desi Country Tomatoes',
      categoryId: 'cat_veg',
      defaultPackSize: '500 g',
      price: 36,
      originalPrice: 45,
      imageUrl:
          'https://images.unsplash.com/photo-1546470427-e26264be0b11?w=400',
      description: 'Naturally ripened heirloom desi country tomatoes with a pleasant tangy zest. Sourced directly from our natural farming cluster near Sedam.',
      farmOrigin: 'Heera Organics Cluster, Sedam Road, Kalaburagi',
      harvestingMethod: 'Handpicked daily at dawn, zero artificial ripeners',
      storageTip: 'Keep at room temperature away from direct sunlight for the best aroma.',
      badgeText: 'Harvest Special',
      packOptions: [
        PackOption(
          id: 'pack_tom_500g',
          label: '500 g',
          price: 36,
          originalPrice: 45,
          isDefault: true,
        ),
        PackOption(
          id: 'pack_tom_1kg',
          label: '1 kg',
          price: 68,
          originalPrice: 85,
        ),
      ],
    ),
    Product(
      id: 'prod_okra',
      name: 'Tender Country Okra (Bhendi)',
      categoryId: 'cat_veg',
      defaultPackSize: '500 g',
      price: 42,
      originalPrice: 52,
      imageUrl:
          'https://images.unsplash.com/photo-1627435601361-ec25f5b1d0e5?w=400',
      description: 'Crisp, tender young pods harvested early morning. Rich in dietary fiber and essential minerals without any chemical sprays.',
      farmOrigin: 'Afzalpur Organic Farm, Kalaburagi',
      badgeText: 'Top Freshness',
      packOptions: [
        PackOption(
          id: 'pack_okra_250g',
          label: '250 g',
          price: 22,
          originalPrice: 28,
        ),
        PackOption(
          id: 'pack_okra_500g',
          label: '500 g',
          price: 42,
          originalPrice: 52,
          isDefault: true,
        ),
      ],
    ),
    Product(
      id: 'prod_spinach',
      name: 'Fresh Farm Spinach (Palak)',
      categoryId: 'cat_veg',
      defaultPackSize: '1 bunch (~250g)',
      price: 28,
      originalPrice: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      description: 'Broad, succulent dark green palak leaves irrigated with pure borewell sweet water. High in bio-available iron.',
      farmOrigin: 'Heera Organics Main Farm',
      badgeText: 'Farm Fresh',
    ),
    Product(
      id: 'prod_capsicum',
      name: 'Crisp Green Bell Pepper (Capsicum)',
      categoryId: 'cat_veg',
      defaultPackSize: '500 g',
      price: 48,
      originalPrice: 60,
      imageUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      description: 'Thick, crunchy walls with fresh botanical sweetness. Perfect for salads and traditional stir-fries.',
      farmOrigin: 'Chittapur Agro Collective',
    ),
    Product(
      id: 'prod_milk',
      name: 'Pure Desi Cow Milk (A2 Gir)',
      categoryId: 'cat_dairy',
      defaultPackSize: '1 Litre Glass Bottle',
      price: 78,
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
      description: 'Raw, unpasteurized, single-origin A2 milk from grass-fed indigenous Gir cows. Bottled in sterile reusable glass containers.',
      farmOrigin: 'Heera Dairy Farm Unit, Kalaburagi',
      harvestingMethod: 'Morning milking at 4:30 AM, chilled instantly to 4°C',
      storageTip: 'Boil within 4 hours of delivery and store chilled.',
      badgeText: 'A2 Certified',
      packOptions: [
        PackOption(id: 'pack_milk_500ml', label: '500 ml', price: 42),
        PackOption(
          id: 'pack_milk_1l',
          label: '1 Litre',
          price: 78,
          isDefault: true,
        ),
      ],
    ),
    Product(
      id: 'prod_paneer',
      name: 'Handcrafted Malai Paneer',
      categoryId: 'cat_dairy',
      defaultPackSize: '200 g',
      price: 95,
      originalPrice: 110,
      imageUrl:
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400',
      description: 'Soft, melt-in-the-mouth paneer curdled naturally using organic lemon and whey. Never treated with chemical coagulants.',
      farmOrigin: 'Heera Dairy Farm Unit',
      badgeText: 'Fresh Today',
    ),
    Product(
      id: 'prod_ghee',
      name: 'Desi Cow Bilona Cultured Ghee',
      categoryId: 'cat_dairy',
      defaultPackSize: '500 ml Glass Jar',
      price: 650,
      originalPrice: 720,
      imageUrl:
          'https://images.unsplash.com/photo-1620706857370-e1b9770e8bb1?w=400',
      description: 'Traditional Vedic bilona method: cultured whole curd churned with wooden churner, then slow-simmered on low flame.',
      farmOrigin: 'Heera Dairy Farm Unit',
      badgeText: 'Vedic Bilona',
    ),
    Product(
      id: 'prod_pomegranate',
      name: 'Sweet Bhagwa Pomegranate (Anar)',
      categoryId: 'cat_fruits',
      defaultPackSize: '1 kg (3-4 pcs)',
      price: 180,
      originalPrice: 220,
      imageUrl:
          'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400',
      description: 'Ruby red, juicy arils bursting with antioxidants. Naturally grown without chemical hormone sprays.',
      farmOrigin: 'Sedam Belt Horticulture Cluster',
      badgeText: 'Sweet Bhagwa',
    ),
    Product(
      id: 'prod_mango',
      name: 'Naturally Ripened Kesar Mangoes',
      categoryId: 'cat_fruits',
      defaultPackSize: '1 kg Box',
      price: 240,
      imageUrl:
          'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400',
      description: 'Traditional hay-ripened organic mangoes with intense honey aroma and no carbide treatment.',
      farmOrigin: 'Aland Organic Orchard',
      badgeText: 'Seasonal Rare',
    ),
    Product(
      id: 'prod_toordal',
      name: 'Heirloom Unpolished Toor Dal',
      categoryId: 'cat_staples',
      defaultPackSize: '1 kg',
      price: 195,
      originalPrice: 225,
      imageUrl:
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
      description: 'Kalaburagi GI-tagged heritage red gram. Rich in protein, unpolished with water or oil for 100% natural aroma.',
      farmOrigin: 'Kalaburagi GI Region Farmers Guild',
      badgeText: 'GI Tagged',
    ),
    Product(
      id: 'prod_groundnut_oil',
      name: 'Wood Pressed Groundnut Oil',
      categoryId: 'cat_oils',
      defaultPackSize: '1 Litre Bottle',
      price: 290,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
      description: 'Cold-pressed at under 45°C in wooden Kolhu (Mara Chekku). Retains natural vitamin E, pleasant nutty aroma and nutrients.',
      farmOrigin: 'Heera Oils Extraction Unit, Sedam',
      badgeText: 'Kolhu Pressed',
    ),
  ];

  static const List<DeliveryAddress> addresses = [
    DeliveryAddress(
      id: 'addr_1',
      title: 'Home',
      streetAddress: 'Flat 302, Green Meadows, Sedam Road',
      locality: 'Sedam Road',
      city: 'Kalaburagi',
      pincode: '585105',
      type: AddressType.home,
      isDefault: true,
      deliveryInstructions: 'Leave with security guard if not answering bell',
    ),
    DeliveryAddress(
      id: 'addr_2',
      title: 'Office',
      streetAddress: 'Shop 14, Commercial Complex, Court Road',
      locality: 'Court Road',
      city: 'Kalaburagi',
      pincode: '585102',
      type: AddressType.work,
      isDefault: false,
      deliveryInstructions: 'Deliver between 10 AM and 6 PM',
    ),
  ];

  static const List<DeliverySlot> deliverySlots = [
    DeliverySlot(
      id: 'slot_morn_today',
      dateLabel: 'Today Morning',
      timeWindow: '6:30 AM - 8:30 AM',
      isMorningHarvest: true,
      isAvailable: false, // Expired for today
    ),
    DeliverySlot(
      id: 'slot_eve_today',
      dateLabel: 'Today Evening',
      timeWindow: '5:00 PM - 7:30 PM',
      isMorningHarvest: false,
      isAvailable: true,
    ),
    DeliverySlot(
      id: 'slot_morn_tomorrow',
      dateLabel: 'Tomorrow Morning',
      timeWindow: '6:00 AM - 8:30 AM',
      isMorningHarvest: true,
      isAvailable: true,
    ),
    DeliverySlot(
      id: 'slot_eve_tomorrow',
      dateLabel: 'Tomorrow Evening',
      timeWindow: '5:00 PM - 7:30 PM',
      isMorningHarvest: false,
      isAvailable: true,
    ),
  ];

  static const List<FaqItem> faqs = [
    FaqItem(
      id: 'faq_1',
      category: 'Freshness & Sourcing',
      question: 'How do you guarantee your vegetables are 100% organic?',
      answer: 'Our produce comes directly from our own farm cluster in Kalaburagi and Sedam. We strictly prohibit chemical pesticides, synthetic urea, or artificial ripeners. We welcome customers to visit our farms any Sunday.',
    ),
    FaqItem(
      id: 'faq_2',
      category: 'Delivery',
      question: 'What time are daily morning deliveries dispatched?',
      answer: 'Morning harvest slots are dispatched by 5:30 AM and reach your doorstep between 6:00 AM and 8:30 AM. Fresh greens and milk are packed within 3 hours of harvest.',
    ),
    FaqItem(
      id: 'faq_3',
      category: 'Dairy & Bottles',
      question: 'How does the glass bottle exchange work for A2 milk?',
      answer: 'Our milk is delivered in sterilized glass bottles. During your next delivery, simply leave the rinsed empty bottle at your doorstep for our delivery partner to pick up.',
    ),
    FaqItem(
      id: 'faq_4',
      category: 'Payments & Returns',
      question: 'What is your freshness guarantee and refund policy?',
      answer: 'If any produce does not meet your expectations for crispness or quality upon delivery, notify us through Help & Support for an instant refund or free replacement in your next basket.',
    ),
  ];

  static const UserProfile sampleProfile = UserProfile(
    id: 'user_001',
    name: 'Shubham S',
    phoneNumber: '+91 98765 43210',
    email: 'shubham@heeraorganics.com',
    householdSize: 4,
    language: 'English',
    referralCode: 'HEERA-KALABURAGI',
    referralEarnings: 250,
  );
}
