import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> listCategory = [];
  List<CategoryItem> listCategoryItem = [];

  late Category category;
  List<String> nameCategory = [];
  List<String> imgCategory = [];

  Future<void> getCategory() async {
    List<Category> newList = [];
    List<CategoryItem> newItemList = [];

    QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection("category").get();

    for (var doc in categorySnapshot.docs) {

      List<CategoryItem> item = [];
      await FirebaseFirestore.instance.collection("category").doc(doc.reference.id).collection("category-item").get().then((value) {
        for(var it in value.docs) {
          var categoryItem = CategoryItem(img: it.data()['img'], name: it.data()['name'], id: it.reference.id, status: it.data()['status']);
          item.add(categoryItem);
        }
      });

      category = Category(
        img: doc["img"].toString(),
        name: doc["name"].toString(),
        itemList: item,
        id: doc.reference.id,
        status: doc["status"].toString(),
      );
      newItemList.addAll(item);
      newList.add(category);
    }

    listCategory = newList;
    listCategoryItem = newItemList;
    notifyListeners();
  }

  getCategoryL() async {
    return await FirebaseFirestore.instance.collection("category").get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        nameCategory.add(doc['name'].toString());
        notifyListeners();
      }
    });
  }

  List<String> getNameCate() {
    return nameCategory;
  }

  List<Category> get getListCategory {
    return listCategory;
  }
  List<CategoryItem> get getListCategoryItem {
    return listCategoryItem;
  }
}
