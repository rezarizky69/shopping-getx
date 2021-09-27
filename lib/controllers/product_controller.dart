import 'package:get/get.dart';
import 'package:untitled/constants/firebase.dart';
import 'package:untitled/models/product.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();
  RxList<ProductModel> products = RxList<ProductModel>([]);
  String collection = 'products';

  // function yg dijalankan pertama kali
  @override
  void onReady() {
    super.onReady();
    // produk mengikat function tersebut
    products.bindStream(getAllProducts());
  }

  // stream yg dijalankan untuk mendapatkan semua produk dari firestore
  // dan listen terhadap tiap ada perubahan yg terjadi
  Stream<List<ProductModel>> getAllProducts() => firebaseFirestore
      .collection(collection)
      .snapshots()
      .map((result) => result.docs
          .map((item) => ProductModel.fromMap(item.data()))
          .toList());
}
