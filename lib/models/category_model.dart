import 'package:equatable/equatable.dart';

class Category extends Equatable{
  final String img;
  final String name;
  final String id;
  final String status;
  final List<CategoryItem> itemList;

  const Category(
      {required this.img,
      required this.name,
      required this.id,
        required this.itemList,
      required this.status});

  @override
  List<Object?> get props => [img,name,id,status,itemList];

}

class CategoryItem extends Equatable{
  final String img;
  final String name;
  final String id;
  final String status;

  const CategoryItem(
      {required this.img,
        required this.name,
        required this.id,
        required this.status});

  @override
  List<Object?> get props => [img,name,id,status];
}
