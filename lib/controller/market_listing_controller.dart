import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yebelo_assignment/model/market_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class MarketListingController {
  MarketListingController({required this.tickerProvider});

  final TickerProvider tickerProvider;
  late ValueNotifier<List<MarketModel>?> marketListNotifier;
  late ValueNotifier<List<MarketModel>?> reviewListNotifier;
  late ValueNotifier<List<String>?> categoriesListNotifier;
  late ValueNotifier<double> totalPriceNotifier;
  TabController? tabController;

  Future<void> init() async {
    marketListNotifier = ValueNotifier<List<MarketModel>?>(null);
    reviewListNotifier = ValueNotifier<List<MarketModel>?>(null);
    categoriesListNotifier = ValueNotifier<List<String>?>(null);
    totalPriceNotifier = ValueNotifier<double>(0);

    await getMarketListing();
    await getCategoryListing();
  }

  void dispose() {
    marketListNotifier.dispose();
    reviewListNotifier.dispose();
    categoriesListNotifier.dispose();
    totalPriceNotifier.dispose();
  }

  Future<List<MarketModel>> getMarketListing() async {
    List<MarketModel> marketList = [];

    try {
      String jsonString =
          await rootBundle.loadString('assets/market_listing.json');
      final jsonResponse = json.decode(jsonString);

      marketList = List<MarketModel>.from(
          jsonResponse.map((final model) => MarketModel.fromJson(model)));
    } catch (e) {
      log('Parsing Error $e');
    }

    marketListNotifier.value =  marketList;

    return marketList;
  }

  Future<List<String>> getCategories() async {
    Set<String> categorySet = {'All'};

    List<MarketModel> marketList = await getMarketListing();

    if (marketList.isNotEmpty) {
      for (var marketItem in marketList) {
        if (marketItem.category != null && marketItem.category!.isNotEmpty) {
          categorySet.add(marketItem.category!);
        }
      }
    }

    categoriesListNotifier.value = categorySet.toList();

    return categorySet.toList();
  }

  Future<List<MarketModel>> getFilteredMarketListFor(
      final String category) async {
    List<MarketModel> marketList = await getMarketListing();

    if (category == 'All') {
      return marketList;
    } else if (category.isNotEmpty) {
      List<MarketModel> filteredMarketList = [];

      if (marketList.isNotEmpty) {
        for (var i in marketList) {
          if (i.category != null &&
              i.category!.isNotEmpty &&
              i.category == category) {
            filteredMarketList.add(i);
          }
        }
        return filteredMarketList;
      }
    }

    return marketList;
  }

  void updateTotal() {
    reviewListNotifier.value =
        List<MarketModel>.from(marketListNotifier.value!);

    reviewListNotifier.value!
        .removeWhere((element) => (element.quantitySelected ?? 0) <= 0);

    totalPriceNotifier.value = 0;
    for (var i in reviewListNotifier.value!) {
      totalPriceNotifier.value =
          totalPriceNotifier.value + (i.cost ?? 0) * (i.quantitySelected ?? 1);
    }
  }

  void increaseQuantityFor(final int index) {
    List<MarketModel>? marketList = marketListNotifier.value;

    if (marketList != null && (marketList[index].availability??0)>(marketList[index].quantitySelected ?? 0)) {
      marketList[index] = marketList[index].copyWith(quantityIncreased: true);
      marketListNotifier.value = null;
      marketListNotifier.value = marketList;
    }else {
      Fluttertoast.showToast(
          msg: "Cannot add more items",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }

  void decreaseQuantityFor(final int index) {
    List<MarketModel>? marketList = marketListNotifier.value;

    if (marketList != null && ((marketList[index].quantitySelected ?? 0) > 0)) {
      marketList[index] = marketList[index].copyWith(quantityDecreased: true);
      marketListNotifier.value = null;
      marketListNotifier.value = marketList;
    }
  }

  List<Tab> getTabList() {
    final List<Tab> tabList = [];

    if (categoriesListNotifier.value != null &&
        categoriesListNotifier.value!.isNotEmpty) {
      for (final String category in categoriesListNotifier.value!) {
        tabList.add(
          Tab(
            child: Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
    }

    return tabList;
  }

  Future<void> getCategoryListing() async {
    categoriesListNotifier.value = await getCategories();
    if (categoriesListNotifier.value != null &&
        categoriesListNotifier.value!.isNotEmpty) {
      tabController = TabController(
        length: categoriesListNotifier.value!.length,
        vsync: tickerProvider,
      );
    }
  }

  Future<void> filterListingForCategoryIndex(final int index) async {
    marketListNotifier.value =
        await getFilteredMarketListFor(categoriesListNotifier.value![index]);
  }
}
