import 'package:equatable/equatable.dart';

import 'cart_model.dart';

class OrderModel extends Equatable {
  final String idOrder;
  final String fullName;
  final String phone;
  final String country;
  final String city;
  final String address;
  final String note;
  final DateTime dateOrder;
  final String paymentMethod;
  final String statusPayment;
  final double subTotal;
  final double vat;
  final double deliveryFee;
  final double totalOrder;
  final String statusOrder;
  final String idUser;
  final List<Cart> cartList;

  const OrderModel({
    required this.cartList,
    required this.idUser,
    required this.paymentMethod,
    required this.fullName,
    required this.address,
    required this.city,
    required this.country,
    required this.dateOrder,
    required this.deliveryFee,
    required this.idOrder,
    required this.note,
    required this.phone,
    required this.statusOrder,
    required this.statusPayment,
    required this.subTotal,
    required this.totalOrder,
    required this.vat,
  });

  @override
  List<Object?> get props => [
    cartList,
    idUser,
    paymentMethod,
    fullName,
    address,
    city,
    country,
    dateOrder,
    deliveryFee,
    idOrder,
    note,
    phone,
    statusOrder,
    statusPayment,
    subTotal,
    totalOrder,
    vat
  ];

  Map<String, Object?> toMap() {
    return {
      'idUser': idUser,
      'paymentMethod': paymentMethod,
      'fullName': fullName,
      'city': city,
      'address': address,
      'country': country,
      'dateOrder': dateOrder,
      'deliveryFee': deliveryFee,
      'idOrder': idOrder,
      'note': note,
      'phone': phone,
      'statusOrder': statusOrder,
      'statusPayment': statusPayment,
      'subTotal':subTotal,
      'totalOrder':totalOrder,
      'vat':vat
    };
  }
}
