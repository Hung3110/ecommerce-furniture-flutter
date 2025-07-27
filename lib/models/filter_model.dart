import 'package:equatable/equatable.dart';

class FilterModel extends Equatable {
  final String idFilter;
  final List<String> price;
  final Map<String,String> color;
  final List<String> feature;
  final List<String> material;
  final List<String> popularSearch;
  final Map<String,dynamic> priceRange;
  final List<String> series;
  final List<String> sortBy;
  final String category;

  const FilterModel({
    required this.price,
    required this.color,
    required this.material,
    required this.feature,
    required this.idFilter,
    required this.popularSearch,
    required this.priceRange,
    required this.series,
    required this.sortBy,
    required this.category,
});

  @override
  List<Object?> get props => [category,idFilter,price,color,feature,material,popularSearch,priceRange,series,sortBy];

}