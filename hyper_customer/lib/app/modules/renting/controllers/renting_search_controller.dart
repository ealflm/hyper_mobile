import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_controller.dart';
import 'package:hyper_customer/app/modules/renting/widgets/search_item.dart';
import 'package:tiengviet/tiengviet.dart';

class RentingSearchController extends BaseController {
  final RentingController _rentingController = Get.find<RentingController>();

  List<Widget> searchItems = [];

  RentStations? get rentStations {
    return _rentingController.rentStations;
  }

  var text = ''.obs;

  void onSearchChanged(String query) {
    text.value = query;
    if (query.isEmpty) {
      searchItems.clear();
      update();
      return;
    }
    if (rentStations != null) {
      searchItems.clear();
      var items = rentStations?.body?.items ?? [];
      for (Items item in items) {
        if (_contains(item.title, query) || _contains(item.address, query)) {
          var searchItem = SearchItem(
            title: item.title ?? '',
            description: item.address ?? '',
            onPressed: () {
              Get.back();
              _rentingController.selectStation(item.id ?? '');
            },
          );
          searchItems.add(searchItem);
        }
      }
    }

    update();
  }

  void clearSearchItems() {
    searchItems.clear();
  }

  bool _contains(String? text, String? keyword) {
    if (text == null || keyword == null) {
      return false;
    }
    var unSignText = TiengViet.parse(text.toLowerCase().trim());
    var unSignKeyword = TiengViet.parse(keyword.toLowerCase().trim());
    return unSignText.contains(unSignKeyword);
  }
}
