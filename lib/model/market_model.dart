import 'package:equatable/equatable.dart';

class MarketModel extends Equatable {
  final String? name;
  final int? id;
  final double? cost;
  final int? availability;
  final String? details;
  final String? category;
  final String? url;
  final int? quantitySelected;

  const MarketModel({
    this.name,
    this.id,
    this.cost,
    this.availability,
    this.details,
    this.category,
    this.url,
    this.quantitySelected,
  });

  factory MarketModel.fromJson(Map<String, dynamic> json) => MarketModel(
        name: json["p_name"],
        id: json["p_id"],
        cost: json["p_cost"].toDouble(),
        availability: json["p_availability"],
        details: json["p_details"],
        category: json["p_category"],
        url: json["p_url"],
      );

  Map<String, dynamic> toJson() => {
        "p_name": name,
        "p_id": id,
        "p_cost": cost,
        "p_availability": availability,
        "p_details": details,
        "p_category": category,
        "p_quantity": quantitySelected,
      };

  MarketModel copyWith({
    bool quantityIncreased = false,
    bool quantityDecreased = false,
  }) {
    int quantity = quantitySelected ?? 0;

    if (quantityIncreased) {
      quantity++;
    } else if (quantityDecreased) {
      quantity--;
    }

    return MarketModel(
      name: name,
      id: id,
      cost: cost,
      availability: availability,
      details: details,
      category: category,
      url: url,
      quantitySelected: quantity,
    );
  }

  @override
  List<Object?> get props => [
        name,
        id,
        cost,
        availability,
        details,
        category,
        url,
        quantitySelected,
      ];
}
