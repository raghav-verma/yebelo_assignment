import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yebelo_assignment/model/market_model.dart';

class ReviewDialogWidget extends StatelessWidget {
  final List<MarketModel> reviewList;
  final double totalPrice;

  const ReviewDialogWidget({
    super.key,
    required this.reviewList,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    String displayJson = '';

    for (int i = 0; i < reviewList.length; i++) {
      if (displayJson.isEmpty) {
        displayJson =
            '[\n${const JsonEncoder.withIndent('  ').convert(reviewList[i].toJson())}';
      } else if (reviewList.length - 1 == i) {
        displayJson =
            '$displayJson,\n${const JsonEncoder.withIndent('  ').convert(reviewList[i].toJson())}\n]';
      } else {
        displayJson =
            '$displayJson\n${const JsonEncoder.withIndent('  ').convert(reviewList[i].toJson())}';
      }
    }

    return Dialog(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviewList.length,
                separatorBuilder: (
                  final context,
                  final index,
                ) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (
                  final context,
                  final index,
                ) {
                  return ListTile(
                    title: Text(
                      reviewList[index].name ?? "Unknown Product",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      "Quantity: ${reviewList[index].quantitySelected ?? 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(reviewList[index].cost ?? 0)} * ${reviewList[index].quantitySelected ?? 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "\$${(reviewList[index].cost ?? 0) * (reviewList[index].quantitySelected ?? 1)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                trailing: Text(
                  '\$ $totalPrice',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              if (displayJson.isNotEmpty)
                const Text(
                  'OR',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              if (displayJson.isNotEmpty) Text(displayJson),
            ],
          ),
        ),
      ),
    );
  }
}
