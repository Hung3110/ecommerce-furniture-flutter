  import 'package:equatable/equatable.dart';

  class Banner1 extends Equatable{
    final String id;
    final String dateStart;
    final String dateEnd;
    final String imgURL;
    final String status;
    final List<String> product;

    const Banner1({
      required this.id,
      required this.dateEnd,
      required this.dateStart,
      required this.imgURL,
      required this.status,
      required this.product
    });

    @override
    List<Object?> get props => [id,dateStart,dateEnd,imgURL,status,product];
  }
