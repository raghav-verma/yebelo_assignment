import 'package:flutter/material.dart';
import 'package:yebelo_assignment/controller/market_listing_controller.dart';
import 'package:yebelo_assignment/model/market_model.dart';
import 'package:yebelo_assignment/view/widgets/market_card_widget.dart';
import 'package:yebelo_assignment/view/widgets/review_dialog_widget.dart';

class MarketListingScreen extends StatefulWidget {
  const MarketListingScreen({super.key});

  @override
  State<MarketListingScreen> createState() => _MarketListingScreenState();
}

class _MarketListingScreenState extends State<MarketListingScreen>
    with SingleTickerProviderStateMixin {
  late MarketListingController _controller;

  @override
  void initState() {
    _initController();

    super.initState();
  }

  Future<void> _initController() async {
    _controller = MarketListingController(tickerProvider: this);
    await _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Market',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white12,
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 18,
        // ),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _controller.categoriesListNotifier,
              builder: (
                final context,
                final categoryList,
                final _,
              ) {
                return _controller.tabController != null
                    ? Container(
                  color:Colors.teal,
                      child: TabBar(
                        unselectedLabelColor: Colors.black54,
                        labelColor: Colors.white,
                          indicatorColor: Colors.white,
                          controller: _controller.tabController,
                          tabs: _controller.getTabList(),
                          onTap: _controller.filterListingForCategoryIndex,
                        ),
                    )
                    : const SizedBox();
              },
            ),
            ValueListenableBuilder(
              valueListenable: _controller.marketListNotifier,
              builder: (
                final context,
                final List<MarketModel>? marketList,
                final _,
              ) {
                if (marketList == null) {
                  return const Center(
                    child: Text('No Items Found!'),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 20, left:12, right:12),
                    itemCount: marketList.length,
                    separatorBuilder: (

                      final context,
                      final index,
                    ) {
                      return const SizedBox(height: 25);
                    },
                    itemBuilder: (
                      final context,
                      final index,
                    ) {
                      return MarketCardWidget(
                        model: marketList[index],
                        addCallback: () {
                          _controller.increaseQuantityFor(index);
                          _controller.updateTotal();
                        },
                        subtractCallback: () {
                          _controller.decreaseQuantityFor(index);
                          _controller.updateTotal();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _controller.totalPriceNotifier,
        builder: (
          final context,
          final double price,
          final _,
        ) {
          if (price <= 0) {
            return const SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: _showSuccessDialog,
              child: const SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    'Proceed to checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    if (_controller.marketListNotifier.value != null &&
        _controller.marketListNotifier.value!.isNotEmpty) {
      _controller.updateTotal();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReviewDialogWidget(
            reviewList: _controller.reviewListNotifier.value!,
            totalPrice: _controller.totalPriceNotifier.value,
          );
        },
      );
    }
  }
}
