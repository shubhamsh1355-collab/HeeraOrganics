import '../models/category.dart';
import '../models/delivery_address.dart';
import '../models/delivery_slot.dart';
import '../models/faq_item.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

class MockData {
  static const String logoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBtq8IsXPsfg5KoG_OwaMM8-0lzg4p_ByEoC_B6vtQDjiMwDGG4TcWvD0PsqVI7mXB4cVkQP_5u8545jsL7Ba4pu2ZHdJwiOD8PXkCW_wkRrpus_RPh8ssufDWO5VeZzLEv4dgrZyH_KBt0RxlvbRMwMCj28kBJIx1plV5fnRXf4ETpj4IcuXrnqE8sq4yc0H3s7Bet3ezO1WXTzcwZzBL03GzTHDC2m_Wh9cMfx_5DGoKcHSYSKxXNr_sLUcw-NfZvSw';

  static const String splashProduceImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDOerQxpq2e4WJL-M5JuFiVKtVQ62Fa-fzpnA7cE16tPxAwOXhmp5WCAYGl6JsFRQ9sQZOJahAFZ8Y4EkreN6_AMt3nPf_MqtvS4REEXnqCjtZi3Qb4HvxM62o8rzRkiqrdTuZqMTT9UwB-TwxyEv8_3DVrO8bODTl7ct4GC9Kq7GU-sd85AZV_s90fXCdJXoidvvhTjeUd2Am0w9Ya9JvdnFn4MJbpx3IMk20m7UwKuM7LTkfs-XTm';

  static const List<Category> categories = [
    Category(
      id: 'cat_veg',
      name: 'Fresh Vegetables',
      iconUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBIWuTSawQcHq9P0X9EbWST2W6xghM07X1YxH31yRIhfxDCj-QNenNntp3xXQ_yU1knbS9NACGyO4WLP7iO3qUDYo9yVkWVuuF6b4PnOs_lIC8eeNTfALQ8ePTbirhA7zcv08JaS0gObquvb7vEPY6OSuHirrmt7y8g71ekVmeho37pLUga57ySEfvjyysckIe-8pxpSscQH5d39ewq4nQ0w6S49Nsp0mUz3uTVOQ2Lex_zFmo-OYk2',
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
      id: 'cat_fruits',
      name: 'Fresh Fruits',
      iconUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDQfZLUZlLxdrubA5Ugh56-pN3dBlNXCJOuzCLa8pLe9naxf2KS2hjjvkUHcLBqxmtmuhIrdlztUxApzL20CWz4YwVF-24hgPn77xbuUlhPpr_yM01P_4Ym_amwFhArI9l5SSQnn0Ut0W83VxTjQ8MGhuikhni1cWhPeULjBHzcI0OvPpaVV5EokrEA6EDykPeSvZu9Gjp4L8MZ2BghO7zGihuCh0-FT8P07thvzZN1SMbHc8a8a_BU',
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
      id: 'cat_dairy',
      name: 'Dairy & Milk',
      iconUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA0xNX9OmMJ3-2z7YxiCPuVq4E6dm3hsTeeYeSVx-ZlSx0yDidLn3TZ8mz-F6I85IZAqynPgzvzKzIqnnR9i8VxU9f9L6m1goZGQEhTLTo9JEsuJp7QmbYXxLoBe_xzVTPEK50ozIE4YFihOnSrwP6WE5Go_bJuRQ4aB5yVuLNTR8Xl6T--m2QAbnUxBJxxpisHGgkzTBOgOHyEgafyKLwHRHgn6cnRrKiCMTEH1OVh-9heL0ZYksjI',
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
      id: 'cat_staples',
      name: 'Grains & Pulses',
      iconUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBqwZoLjFYJ2ewKN-XRhXrXGvWzUJyUDamdU9OMrzz6PiHYlRhyjM5UlikxrtBN01FYeLCnWyUfxQTWRf8v5bDLBMZZ6zM9K0F8ExOkSBI3JINZsfKHv0XJSPjJP0FwxVtXkfLKRqkDo7iiQALl0EmDnAtRRudBMVyLBd9K_PhtMO-rPi5AdgXO3HbEcMqBgxW1e7ZpS_2L9BDtvG9am2PrseJbMH_5JZ2UCGmax0NZjw1oFEwMXDrh',
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
      name: 'Organic Staples',
      iconUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB84ek97pVsyZKXC81rN9FHHaTmZBlMfbW00m3x5MF917-q2mQHxyyE5n-znlagxpCPLXz8-ilZxMPD9Y8b6x6QB24PVgRcqENiTk3vDBdbVAQtztrH5hQHCxNHcRQXr4MZ-df2VzNZ9SiMI4LMshEB8esbfnxdZ6ILYPOapTA-k0yyIKJ6-Z3vfPoz-WXZGKetQNe3RFGM8oBzk1_ZHdnpY7y_nK6Qjjf0T2dBdqVBg16BGc-ih8Ul',
      bannerText: 'Cold pressed wood-churned oils and pure spices',
      subcategories: [
        Subcategory(
          id: 'sub_wood_pressed',
          name: 'Wood Pressed Oils',
          icon: 'opacity',
        ),
      ],
    ),
    Category(
      id: 'cat_essentials',
      name: 'Daily Essentials',
      iconUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA6pTEmkDFMz5RVHs8l0h8f0sGrxZQt_dhpl90NsRaTd--kCZcvbLcri_ZQuKkcC_AIa5w-GJkjc-eR3YBtOfZtCo2J9gAcImmIsAnBLuTJmmD-2lrXxmUHemYUH2ZzzVeCWgS19VgWMTsBNVEWrZM-yIAiytjKFsk9uYSYxqb6kXPpBb-Q45Q-p4U-BbqtAkzqTe4p9njb4foGaDZiTSIbkz8vFlnUOmCh0-o2aWTFwJntpebQLkDX',
      bannerText: 'Artisanal honey, farm eggs, and sourdough',
      subcategories: [
        Subcategory(
          id: 'sub_honey',
          name: 'Raw Honey & Eggs',
          icon: 'egg',
        ),
      ],
    ),
  ];

  static const List<Product> products = [
    Product(
      id: 'prod_tomato',
      name: 'Desi Country Tomatoes (Nati Tomato)',
      categoryId: 'cat_veg',
      defaultPackSize: '500 g',
      price: 28,
      originalPrice: 35,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBMMyPQjAySqSBEU7s9P6dqj79ssWxg6GI1cjEDOb0aAxToz7Vo_qF0ZkRFfpDcBwDxFXQNQj6rU1WkjnQi4f77qOpw_SJU9OESYMHnFyBdNl1FJ_6t7bw-M8MPGA-v0qLodGPqNGsjS5dgw_jrbvTMtFSbYQEFFmQV0vADvSKkdhLEtbC4JM_bfhWUumPR8j9ryVMMhUGvwMRkiitaFdMxklpu-6jPCbaoIFtUmxyjg9wGC157rKR8',
      description:
          'Naturally tangy, field-ripened, and harvested pesticide-free at sunrise.',
      farmOrigin: 'Patil Farm, Sedam Belt (14 km)',
      harvestingMethod: 'Morning Harvest • 6:30 AM Today',
      storageTip: 'Store at cool ambient room temperature; zero wax coating.',
      badgeText: 'Harvest Special',
      packOptions: [
        PackOption(
          id: 'pack_tom_500g',
          label: '500 g',
          price: 28,
          originalPrice: 35,
          isDefault: true,
        ),
        PackOption(
          id: 'pack_tom_1kg',
          label: '1 kg',
          price: 52,
          originalPrice: 65,
        ),
        PackOption(
          id: 'pack_tom_2kg',
          label: '2 kg',
          price: 98,
          originalPrice: 125,
        ),
      ],
    ),
    Product(
      id: 'prod_milk',
      name: 'Farm Fresh Milk',
      categoryId: 'cat_dairy',
      defaultPackSize: '1 L Glass Bottle',
      price: 68,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDhKYAxPZe6j03IEdWza5VaAnIzNuSXwG5W0EUWNncMPHyHVyLM7qvPcgAydfrYu0Rhh7NssTrACR062APR22M5vPzE9i6sEmoU4I_j4GTIRAuMIl9pVe3ZKsKwcgFtXR0LNUNFbECb10P420QEzbzz6j56Md2ET-n26iVfHbIk4nNWfdT0h6Kbzd6pUm3jlJpzCTSfyU_SPgaT_D-5-AZoaDmXVapaLieueNWP5pmCHB5Jiq3bobeR',
      description:
          'Chilled raw organic cow milk in vintage embossed clear glass bottle with sealed foil cap. Pure unadulterated Gir cow A2 milk.',
      farmOrigin: 'Sedam Dairy Cluster, Kalaburagi',
      harvestingMethod: 'Morning milking at 4:30 AM, chilled instantly to 4°C',
      storageTip: 'Boil within 4 hours of delivery and store chilled.',
      badgeText: 'In Stock',
      packOptions: [
        PackOption(
          id: 'pack_milk_1l',
          label: '1 L Glass Bottle',
          price: 68,
          isDefault: true,
        ),
      ],
    ),
    Product(
      id: 'prod_paneer',
      name: 'Desi Gir Paneer',
      categoryId: 'cat_dairy',
      defaultPackSize: '200 g block',
      price: 140,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCXvImYOs00VLCJBvLCZMi775NAA9RhirbYsfCpvkBcB76HXOu2P4DWBWv8PARZCgYFJzM71kL_7d8TCod9XCa3m1brfKJ2x5MDG3n_v5QJkvldRTjqnrkT7RJBalkgedIw_VYxojQoFO9w2A3w-2DK-qEnQ2GfTUKUR4Lo4ftQO-U_ch2XiTPqMR4Jl4AD4o5yVIjl3N3Fp5cYzgPkVt6pciyp67NPUBbzRg2d8dn0b8GnVJ8KKoup',
      description:
          'Fresh block of artisanal soft Indian cottage cheese desi paneer freshly cut with muslin cloth textures and gentle herbal aroma.',
      farmOrigin: 'Heera Dairy Farm Unit, Kalaburagi',
      badgeText: 'Pure A2',
    ),
    Product(
      id: 'prod_spinach',
      name: 'Country Spinach',
      categoryId: 'cat_veg',
      defaultPackSize: '250 g bunch',
      price: 24,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBLmr8CY1sR1GIYYlEwp3qK7FOl5imcyWatzeNbJYr8CcxRdcGWgV9afbwjgL3IxO38G2_PLTWmj2tJl73dDNsWeM7M3XelN8w0GvQYdGL9XH-iguTVU06hjFid-VKnAdn6aErNV5p3zaeoLm305k7H6jmM8AogR1yFyPW-D9626fB5yRCZrtVtGFrG_9Ua3bSAQ7XeY4GAD9DaJc6zV4MCjzLJri9K6ytKJ1D7HGVhnWKeovEDgqxa',
      description:
          'Tender leafy green country spinach palak leaves tied with eco-friendly jute twine with crisp droplets of morning harvest water.',
      farmOrigin: 'Patil Farm, Sedam Belt',
      badgeText: 'Dawn Harvest',
    ),
    Product(
      id: 'prod_mango',
      name: 'Kesar Mangoes',
      categoryId: 'cat_fruits',
      defaultPackSize: '1 kg box',
      price: 220,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAokVDzSM1nJ5GUdbsoQACrF2SZ47nyCQKeSZbuG-rrHCI8wmlRwTTGaBjfBD5_MNYWBw-0IuNfWYrubBl_Do2rYa1mG0QSZZVbPhv9gKtIZJ-rtFBLwNrO7TOreIkHYs8IjBF2_E8HGB_Sqj1xKv4htMIvhs6MtYZnFmUUSVfjbc2MogVQviPhu3yz1SNTxjVOWKqKeLp97fPRDE5jZz4__TlbfGBYNsxE0UNolrrNmsSRZjATWoj9',
      description:
          'Golden naturally ripened organic Kesar mangoes arranged carefully in straw packing with fragrant green stems still attached.',
      farmOrigin: 'Aland Organic Orchard',
      badgeText: 'Bestseller',
    ),
    Product(
      id: 'prod_toordal',
      name: 'Unpolished Dal',
      categoryId: 'cat_staples',
      defaultPackSize: '1 kg pack',
      price: 185,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCSLUPcS8_AUPNmlSG6LEdHTfs6bQyz-IHWG6QA4FQCJSwDESfu_UDCqQ_lLi6yUSmz847dxK7qOe6fBBITUlEiFpfKLVLjE41CpRC8lsqTYEDDHjIXCksHEDHLxnNrNeGTl1qgygIoi5nAZ4F3jsdVIGM28O9kWMkeWKLexWbldJKDJ_LwffzyMoYUAkRlgKxELxntN_xVC6jkJY7uqA2bpRE3EA6dlx0AwsJw46LBCrsXCGE4vD4B',
      description:
          'Unpolished organic GI-tagged Kalaburagi Toor Dal pigeon pea in handcrafted brown paper bag showing natural golden texture and zero chemical polish.',
      farmOrigin: 'Kalaburagi GI Region Farmers Guild',
      badgeText: 'GI Tagged',
    ),
    Product(
      id: 'prod_buffalo_milk',
      name: 'Buffalo Milk',
      categoryId: 'cat_dairy',
      defaultPackSize: '1 L bottle',
      price: 74,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCxDWQtiLNMqknlyXFdKS7qUkxHhY7qz0dx-ZfCf5QQMHUf8YI5Npxm51SvGcn_RT9NcgptdUlH-PCV66LytL1DPZqUpmRXzDaqLT0nj7pOzeL1G5jX8tvshU5fUXW7d5SM2i0ZKsJtRQCHxK-KV1PVuNqO_g1d8XcQDPOe9Rq3hRKbWo5DMwP-orI05YNrB87JUR9GquAc0gqVl_5gveQ7-QAAtgP5Of8dyoLw3UqIbvts9JlvoFF9',
      description:
          'Glass bottle filled with rich creamy whole buffalo milk standing next to an earthen pot on clean kitchen counter.',
      farmOrigin: 'Heera Dairy Farm Unit, Kalaburagi',
      badgeText: 'Zero Preservatives',
    ),
    Product(
      id: 'prod_curd',
      name: 'Cultured Dahi',
      categoryId: 'cat_dairy',
      defaultPackSize: '500 g pot',
      price: 45,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDN8iE-EYrdpoA7_sFAIvLdpcCyEHViMz9QEfPemQFO6tvKPla1zHGRplg5HEy0zlSgcIyG95zYLprmRFwdQcgA14mPc7_3_sNncrTTn2yTbAQw4U4i1PJuc6AaKu6KBypP1kWK8tbYJxQm_bWPJR6pWfOmbPMoKsLKVnLWujmSWfsGLtPEQQQcOaA7k_alRq0N_RvFi4s4eRS6Dri24LgI89JW9BV5UDhSphu_jjj5EZXMfuzFIDoJ',
      description:
          'Traditional set dahi curd in terracotta clay matka bowl with thick natural cream top and wooden spoon.',
      farmOrigin: 'Heera Dairy Farm Unit',
      badgeText: 'Clay Matka',
    ),
    Product(
      id: 'prod_ghee',
      name: 'Bilona Cow Ghee',
      categoryId: 'cat_dairy',
      defaultPackSize: '500 ml jar',
      price: 520,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCAt2tUb5Y28zfup86c0gBXC605-qbNN3oAg0dJPCj-cGdGpkP8cOxhnR8ZmfIMapzoMlNSTy1KPh28JGH89JYKjsgHvZSIIkGocROHE2v64ZQJeoq7l0q8PbB8Lpbqjw5FG7goKKPNqYcABejlr9Zb5iDRAx4z5wc8ICqUH4RqkOdib2otJBmUqZ_YpXDlcksajhkPvtmXTp4BfQp8WE05WYGZL6imJ9zyaMYHbmSWYcQDrQyz9Stp',
      description:
          'Golden aromatic clarified butter pure desi bilona cow ghee in glass jar with brass spoon showing grainy granular texture.',
      farmOrigin: 'Heera Dairy Farm Unit',
      badgeText: 'Vedic Bilona',
    ),
    Product(
      id: 'prod_makhan',
      name: 'White Makhan',
      categoryId: 'cat_dairy',
      defaultPackSize: '200 g pack',
      price: 95,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBrE8uD2sZIc5w1GGTUj2uA-jRosc2X9nPVAsZD9zUvY2Xs7PSOTlslkgued2SkQqLu4Lf1nv46P0UWqo5cINzkCTQEzJhsJpYzh1FpGe3YLZVzmVO42ERE1vb1f440ZjK0EyDsYb9Tq8U5KEjQRn96RHsB3n4X4Ef_CiH19VQqo4RaCfpigGiYo_rdVhDKi5u7LmdMb9ZgWesXeb9p23HZzlfVMPpgsawYS-8FkK8yiUXzDajwzgH-',
      description:
          'Fresh homemade white makhan butter wrapped in natural parchment paper with fresh mint leaf on rustic wooden block.',
      farmOrigin: 'Heera Dairy Farm Unit',
      badgeText: 'Handmade',
    ),
    // Cart add-on cross sells
    Product(
      id: 'prod_coriander',
      name: 'Tender Coriander',
      categoryId: 'cat_veg',
      defaultPackSize: 'Bunch • 100 g',
      price: 18,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD660gpbLZQ2-LZXsjoPAIRKqn7AabpJmZs4erDgWmhe29CVN1RqWs7OIXlgWkqyid-g5zTnZnETYyA62N-Nc_JfMuJVpQbxAA5fMfp7Ui5VQMWdeqnSpyhX5iPKt4pwMWXWWkEozF6W8-NnV5KYiNbifIN3lCvhfOvjFpBYux6uk8l214y2CjS-ek9mVKG9AShYRp4SJfH5nhCNlseyyXGmAaLkav6ljjDSq7lYxbJ0rQInYVBqRpF',
      description:
          'Fresh aromatic green coriander cilantro leaves tied in bunch with morning water droplets.',
      farmOrigin: 'Patil Farm, Sedam Belt',
      badgeText: 'Fresh Herb',
    ),
    Product(
      id: 'prod_chilli',
      name: 'Green Chillies',
      categoryId: 'cat_veg',
      defaultPackSize: 'Organic • 100 g',
      price: 15,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDjCX-ub-zp8vapz2unHfoNTxIj3aLQF45CbXF4r564Qd6zmDUMG8rLwQIBn75yhtXW30ctIQvecTWd5fLb_zm90f0syXVQsXzKo4yNhVGkw9tK5pasIlJpYfJIGGa1wUxOrYpHeh4tpmmc3qAUEMeWHglsdMm6H_umI1B1tBRLbY6EKR8Zopf0HsWkwWPwOPXM2ob2YCjiSd3hfip1vc7ctPv25izWxAjYzvTnyxpypMRYRE5Z1AwY',
      description:
          'Vibrant slender organic green chillies arranged fresh in a small earthen bowl with crisp heat.',
      farmOrigin: 'Sedam Road Cluster',
      badgeText: 'Spicy Fresh',
    ),
    Product(
      id: 'prod_ginger',
      name: 'Country Ginger',
      categoryId: 'cat_veg',
      defaultPackSize: 'Aromatic • 100 g',
      price: 20,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAiXOiX-zaiC6wtDKaOTw6F6Tkuknl_pDYoExsgM773X8bmzvU5ac4lLYAoaZbLbGgPVBw_POxNToYQc3_V8o8DGe52CFJNO8UOGyLaz0UxKBCUvUrTPjvqKajaBZz_8B6UpfmZ0Lth_by51ThLNrt2VDdbc5CAylsVEfc_jMn4ifFfGmdaHehUWM2Jy7dUrbvXaR41pq6rgM6TTANvQ6_1SZvBTnBqs0D2VuxjNo378d-m1Ajtytys',
      description:
          'Fresh knobby raw ginger root unpeeled with earthy skin on organic linen cloth.',
      farmOrigin: 'Sedam Road Cluster',
      badgeText: 'Aromatic Root',
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
      id: 'slot_today_afternoon',
      dateLabel: 'Today, 3:00 PM – 5:00 PM',
      timeWindow: 'Sunrise Batch • Reaching in ~2 hrs',
      isMorningHarvest: false,
      isAvailable: true,
    ),
    DeliverySlot(
      id: 'slot_tomorrow_morning',
      dateLabel: 'Tomorrow, 6:30 AM – 8:30 AM',
      timeWindow: 'Dawn Harvest • Straight from farm gate',
      isMorningHarvest: true,
      isAvailable: true,
    ),
  ];

  static const List<FaqItem> faqs = [
    FaqItem(
      id: 'faq_1',
      category: 'Freshness & Sourcing',
      question: 'How do you guarantee your vegetables are 100% organic?',
      answer:
          'Our produce comes directly from our own farm cluster in Kalaburagi and Sedam. We strictly prohibit chemical pesticides, synthetic urea, or artificial ripeners. We welcome customers to visit our farms any Sunday.',
    ),
    FaqItem(
      id: 'faq_2',
      category: 'Delivery',
      question: 'What time are daily morning deliveries dispatched?',
      answer:
          'Morning harvest slots are dispatched by 5:30 AM and reach your doorstep between 6:00 AM and 8:30 AM. Fresh greens and milk are packed within 3 hours of harvest.',
    ),
    FaqItem(
      id: 'faq_3',
      category: 'Dairy & Bottles',
      question: 'How does the glass bottle exchange work for A2 milk?',
      answer:
          'Our milk is delivered in sterilized glass bottles. During your next delivery, simply leave the rinsed empty bottle at your doorstep for our delivery partner to pick up. Earn ₹20/bottle credit.',
    ),
    FaqItem(
      id: 'faq_4',
      category: 'Payments & Returns',
      question: 'What is your freshness guarantee and refund policy?',
      answer:
          'If any produce does not meet your expectations for crispness or quality upon delivery, notify us through Help & Support for an instant refund or free replacement in your next basket.',
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
