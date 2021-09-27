import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/models/cart_item.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/models/user.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  // total amount
  RxDouble totalCartPrice = 0.0.obs;

  // function yang dijalankan pertama kali
  @override
  void onReady() {
    super.onReady();
    // listen tiap perubahan yg terjadi pada user model, maka akan memanggil
    // function tersebut
    ever(userController.userModel, changeCartTotalPrice);
  }

  // function untuk menambahkan produk ke keranjang belanja
  void addProductToCart(ProductModel product) {
    try {
      // jika item sudah pernah ditambahkan
      if (_isItemAlreadyAdded(product)) {
        Get.snackbar("Check your cart", "${product.name} is already added");
      } else {
        // membuat id baru
        String itemId = Uuid().toString();
        // update user data dengan menambahkan data baru
        userController.updateUserData({
          // menambahkan field cart ke user collection dengan struktur
          // isinya sebagai berikut
          "cart": FieldValue.arrayUnion([
            {
              "id": itemId,
              "productId": product.id,
              "name": product.name,
              "quantity": 1,
              "price": product.price,
              "image": product.image,
              "cost": product.price
            }
          ])
        });
        Get.snackbar("Item added", "${product.name} was added to your cart", backgroundColor: Colors.white, colorText: Colors.orange);
      }
    } catch (e) {
      Get.snackbar("Error", "Cannot add this item");
      debugPrint(e.toString());
    }
  }

  // function untuk menghapus produk dari keranjang belanja
  void removeCartItem(CartItemModel cartItem) {
    try {
      // update user dengan menghapus field cart
      userController.updateUserData({
        "cart": FieldValue.arrayRemove([cartItem.toJson()])
      });
    } catch (e) {
      Get.snackbar("Error", "Cannot remove this item");
      debugPrint(e.message);
    }
  }

  // function untuk ubah total harga
  changeCartTotalPrice(UserModel userModel) {
    // initial
    totalCartPrice.value = 0.0;
    // jika keranjang user tidak kosong
    if (userModel.cart.isNotEmpty) {
      // maka dilakukan perulangan untuk setiap item di keranjang
      userModel.cart.forEach((cartItem) {
        // jumlah total harga sama dengan tiap harga dari masing" item
        // keranjang
        totalCartPrice += cartItem.cost;
      });
    }
  }

  // function untuk mengecek apakah item tersebut sudah ada di keranjang
  _isItemAlreadyAdded(ProductModel product) =>
      // isi dari item keranjang user
      userController.userModel.value.cart
          // dimana id item tersebut sama dengan id dari produk yg ingin
          // ditambahkan
          .where((item) => item.productId == product.id)
          // adalah tidak kosong
          .isNotEmpty;

  // function untuk mengurangi quantity dari item pada keranjang
  void decreaseQuantity(CartItemModel item) {
    // jika item masih berjumlah 1
    if (item.quantity == 1) {
      // hapus item tersebut
      removeCartItem(item);
    } else {
      // jika selain jumlah tersebut, maka hapus item
      removeCartItem(item);
      // dengan mengurangi nilainya dengan satu
      item.quantity--;
      // setelah itu lakukan notify dengan update jumlah terbaru dari item
      // keranjang tersebut
      userController.updateUserData({
        "cart": FieldValue.arrayUnion([item.toJson()])
      });
    }
  }

  // function untuk menambahkan quantity dari item pada keranjang
  void increaseQuantity(CartItemModel item) {
    // harus menghapus item yg ada terlebih dahulu
    removeCartItem(item);
    // baru menambahkan jumlahnya dengan nilai satu
    item.quantity++;
    logger.i({"quantity": item.quantity});
    // lakukan notify dengan update jumlah terbaru dari item pada keranjang
    // tersebut
    userController.updateUserData({
      "cart": FieldValue.arrayUnion([item.toJson()])
    });
  }
}
