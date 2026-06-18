import 'package:equatable/equatable.dart';

/// A merchandise product. The web app hard-codes these in `MerchandisePage`,
/// so we keep them as a static list (see `merch_data.dart`).
class MerchProduct extends Equatable {
  const MerchProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final String price;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, description, price];
}
