import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Country extends Equatable{
  late final String name;
  final String id;
  final List<String> city;

  Country({required this.name, required this.id, required this.city});

  @override
  List<Object> get props => [name, id,city];

  @override
  bool get stringify => false;

}

class CountryCityProvider extends ChangeNotifier {
  List<Country> listCountry = [];

  Future<void> getListCountry() async {
    List<Country> newList = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('country').get();

    for (var doc in querySnapshot.docs) {
      var country =
          Country(name: doc['name'], id: doc.reference.id, city: List.from(doc['city']));

      newList.add(country);
    }

    listCountry = newList;
    notifyListeners();
  }

  List<Country> get getCountryCityList {
    return listCountry;
  }
}
