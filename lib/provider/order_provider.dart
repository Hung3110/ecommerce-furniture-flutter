import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/DatabaseHandler.dart';
import 'package:flutter/cupertino.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> listOrder = [];

   bool addCartSucc = false;

  Future<void> addOrder(order , listCart) async {
    bool flag = false;
    DatabaseHandler handler = DatabaseHandler();
    await FirebaseFirestore.instance.collection('order').doc(order.idOrder).set(order.toMap()).then((value) async {
      for( Cart cart in listCart) {
        await FirebaseFirestore.instance.collection('order').doc(order.idOrder).collection('order-item').doc(cart.idCart.toString()).set(cart.toMap()).then((value) => handler.deleteCart(cart.idCart!));
      }
    }).then((value) => flag = true);

    addCartSucc = flag;
    notifyListeners();
  }

  Future<void> updateOrder(OrderModel order , String idUser) async {
    await FirebaseFirestore.instance.collection('order').doc(order.idOrder).update(
        {'statusOrder': 'CANCEL'}).then((value) {
          getOrderByIDUser(idUser);
    })
    ;
  }

  Future<void> getOrderByIDUser(String idUser) async {
    List<OrderModel> newlistOrder = [];
    await FirebaseFirestore.instance.collection('order').where('idUser' , isEqualTo:idUser).get().then((value) async {
      for(var doc in value.docs) {

        List<Cart> newCart = [];
        await FirebaseFirestore.instance.collection('order').doc(doc.reference.id).collection('order-item').get().then((value) {
          for(var ca in value.docs) {
            var cart = Cart(
                imgProduct: ca.data()['imgProduct'],
                nameProduct: ca.data()['nameProduct'],
                color: ca.data()['color'],
                quantity: ca.data()['quantity'],
                idProduct: ca.data()['idProduct'],
                price: ca.data()['price']);

            newCart.add(cart);
          }
        });

        DateTime dt = (doc['dateOrder'] as Timestamp).toDate();
        var order = OrderModel(
            idUser: doc.data()['idUser'],
            paymentMethod: doc.data()['paymentMethod'],
            fullName: doc.data()['fullName'],
            address: doc.data()['address'],
            city: doc.data()['city'],
            country: doc.data()['country'],
            dateOrder: dt,
            deliveryFee: doc.data()['deliveryFee'],
            idOrder: doc.data()['idOrder'],
            note: doc.data()['note'],
            phone: doc.data()['phone'],
            statusOrder: doc.data()['statusOrder'],
            statusPayment: doc.data()['statusPayment'],
            subTotal: doc.data()['subTotal'],
            totalOrder: doc.data()['totalOrder'],
            vat: doc.data()['vat'],
          cartList: newCart,
        );
        newlistOrder.add(order);
      }

    });

    listOrder = newlistOrder;
    notifyListeners();
  }


  bool get getStatus {
    return addCartSucc;
  }

  List<OrderModel> get getLIstOrder {
    return listOrder;
  }
}