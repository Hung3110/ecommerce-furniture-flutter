import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/banner_model.dart';

class BannerProvider with ChangeNotifier {
  List<Banner1> listBanner = [];
  late Banner1 banner;
  List<String> listBannerIMG = [];

  Future<void> getBanner() async {
    List<Banner1> newList = [];
    QuerySnapshot bannerSnapshot = await FirebaseFirestore.instance.collection("banner").get();

    for (var element in bannerSnapshot.docs) {
      banner = Banner1(
        id: element.reference.id,
        imgURL: element["img"].toString(),
        dateStart: element["dateStart"].toString(),
        dateEnd: element["dateEnd"].toString(),
        status: element["status"].toString(), 
        product: List.from(element['product']),
      );

      newList.add(banner);
    }

    listBanner = newList;
    notifyListeners();
  }

  List<Banner1> get getListBanner {
    return listBanner;
  }

  List<String> get getListBannerIMG {
    return listBannerIMG;
  }
}
