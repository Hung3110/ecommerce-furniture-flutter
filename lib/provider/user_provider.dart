import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:flutter/cupertino.dart';
import '../models/product_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserSQ> listUser = [];
  UserSQ currentUser = const UserSQ(
    status: '',
    email: '',
    phone: '',
    fullName: '',
    address: '',
    img: '',
    birthDate: '',
    idUser: '',
    dateEnter: '',
    gender: '',
  );

  Future<void> getListUser(List<Review> listReview) async {
    List<UserSQ> newList = [];
    for (var re in listReview) {
      try {
        DocumentSnapshot value = await FirebaseFirestore.instance
            .collection('users') // Sửa từ 'user' thành 'users' (khớp collection name)
            .doc(re.idUser)
            .get();
        if (value.exists) {
          var us = UserSQ(
            status: value['status'] ?? '',
            email: value['email'] ?? '',
            phone: value['phone'] ?? '',
            fullName: value['fullName'] ?? '',
            address: value['address'] ?? '',
            img: value['img'] ?? '',
            birthDate: value['birthDate'] ?? '',
            idUser: value['idUser'] ?? re.idUser, // Dùng idUser từ review nếu không có
            dateEnter: value['dateEnter'] ?? '',
            gender: value['gender'] ?? '',
          );
          newList.add(us);
        }
      } catch (e) {
        print('Error fetching user ${re.idUser}: $e');
      }
    }
    listUser = newList;
    notifyListeners();
  }

  Future<void> getDocCurrentUser(String? id) async {
    if (id == null) {
      print('No user ID provided');
      return;
    }

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users') // Sửa từ 'user' thành 'users'
          .doc(id)
          .get();
      if (documentSnapshot.exists) {
        var us = UserSQ(
          status: documentSnapshot['status'] ?? '',
          email: documentSnapshot['email'] ?? '',
          phone: documentSnapshot['phone'] ?? '',
          fullName: documentSnapshot['fullName'] ?? '',
          address: documentSnapshot['address'] ?? '',
          img: documentSnapshot['img'] ?? '',
          birthDate: documentSnapshot['birthDate'] ?? '',
          idUser: documentSnapshot['idUser'] ?? id, // Dùng id nếu không có
          dateEnter: documentSnapshot['dateEnter'] ?? '',
          gender: documentSnapshot['gender'] ?? '',
        );
        currentUser = us;
      } else {
        print('No user document found for ID: $id');
        // Tạo user mặc định nếu không tồn tại (tùy chọn)
        currentUser = UserSQ(
          idUser: id,
          status: 'INVALID',
          email: '',
          phone: '',
          fullName: '',
          address: '',
          img: '',
          birthDate: '',
          dateEnter: DateTime.now().toIso8601String(),
          gender: '',
        );
        await updateUser(currentUser); // Tạo document mới
      }
    } catch (e) {
      print('Error fetching current user: $e');
    }
    notifyListeners();
  }

  Future<void> updateUser(UserSQ user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.idUser).set(user.toMap());
      await getDocCurrentUser(user.idUser); // Cập nhật lại sau khi lưu
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  UserSQ get getCurrentUser {
    return currentUser;
  }

  List<UserSQ> get getListUserSQ {
    return listUser;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}