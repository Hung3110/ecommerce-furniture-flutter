import 'package:equatable/equatable.dart';

class Cart extends Equatable{
  final String idProduct;
  final String nameProduct;
  final String imgProduct;
  final String color;
  final int? idCart;
  final int quantity;
  final double price;

  const Cart({
    this.idCart,
    required this.imgProduct,
    required this.nameProduct,
    required this.color,
    required this.quantity,
    required this.idProduct,
    required this.price,
  });

  Cart.fromMap(Map<String, dynamic> cart)
      : idCart = cart["idCart"],
        quantity = cart["quantity"],
        idProduct = cart["idProduct"],
        color = cart["color"],
        nameProduct = cart["nameProduct"],
        imgProduct = cart["imgProduct"],
        price = cart["price"];

  Map<String, Object?> toMap() {
    return {'idCart':idCart,'quantity': quantity, 'color':color,'idProduct': idProduct, 'nameProduct':nameProduct , 'imgProduct':imgProduct, 'price': price};
  }

  @override
  List<Object?> get props => [quantity,idProduct,color,nameProduct,imgProduct,price];

}
