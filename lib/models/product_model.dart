import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String img;
  final String id;
  final Map<String, String> size;
  final double rootPrice;
  final double currentPrice;
  final String status;
  final String categoryItemId;
  final String description;
  final Map<String, String> material;
  final double review;
  final double sellest;
  final String title;
  final List<ProductItem> productItemList;
  final List<Review> reviewList;
  final DateTime timestamp;

  const Product({
    required this.title,
    required this.name,
    required this.img,
    required this.id,
    required this.description,
    required this.size,
    required this.rootPrice,
    required this.currentPrice,
    required this.categoryItemId,
    required this.status,
    required this.material,
    required this.review,
    required this.sellest,
    required this.productItemList,
    required this.reviewList,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    timestamp,
        title,
        name,
        img,
        id,
        description,
        size,
        rootPrice,
        currentPrice,
        categoryItemId,
        status,
        material,
        review,
        sellest,
        productItemList
      ];
}

class ProductItem extends Equatable {
  final String id;
  final Map<String, String> color;
  final List<String> img;

  const ProductItem({
    required this.img,
    required this.color,
    required this.id,
  });

  @override
  List<Object?> get props => [img, color, id];
}

class Review extends Equatable {
  final String idOrder;
  final String idUser;
  final String id;
  final String message;
  final List<String> img;
  final DateTime date;
  final Map<String,dynamic> service;
  final double star;

  Review({
    required this.id,
    required this.idUser,
    required this.idOrder,
    required this.message,
    required this.img,
    required this.date,
    required this.service,
    required this.star,
  });

  Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());

  Map<String, Object?> toMap() {
    return {'idUser':idUser,'idOrder': idOrder, 'message':message,'img': img,
      'timestamp':myTimeStamp , 'service': {}, 'star': star};
  }

  @override
  List<Object?> get props => [idOrder, idUser, id, message, img, date,service,star];
}
