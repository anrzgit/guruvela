import '../models/merch_product.dart';

/// Hard-coded merchandise catalog, ported from `MerchandisePage.jsx`.
/// Prices are placeholders (`₹ --`) exactly as in the web app.
abstract final class MerchData {
  MerchData._();

  static const List<MerchProduct> iitMandiProducts = [
    MerchProduct(
      id: 'iit-tshirt',
      name: 'IIT Mandi T-Shirt',
      description:
          'Premium cotton T-Shirt featuring the official IIT Mandi logo.',
      price: '₹ --',
    ),
    MerchProduct(
      id: 'iit-hoodie',
      name: 'IIT Mandi Hoodie',
      description:
          'Cozy hoodie with the official IIT Mandi emblem, perfect for '
          'campus winters.',
      price: '₹ --',
    ),
  ];

  static const List<MerchProduct> fanProducts = [
    MerchProduct(
      id: 'non-iit-tshirt',
      name: 'Fan Edition T-Shirt',
      description:
          'Stylish T-Shirt with a custom design for IIT Mandi aspirants '
          'and fans.',
      price: '₹ --',
    ),
    MerchProduct(
      id: 'non-iit-hoodie',
      name: 'Fan Edition Hoodie',
      description:
          'Comfortable hoodie with a unique design to show your support.',
      price: '₹ --',
    ),
  ];
}
