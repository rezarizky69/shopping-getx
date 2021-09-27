import 'package:get/get.dart';

// instance controller untuk app yg menangani proses login
class AppController extends GetxController{
  static AppController instance = Get.find();

  // variable untuk menentukan apakah widget login ditampilkan atau tidak
  RxBool isLoginWidgetDisplayed = true.obs;

  // function untuk mengubah keadaan widget saat authentication
  changeDIsplayedAuthWidget(){
    isLoginWidgetDisplayed.value = !isLoginWidgetDisplayed.value;
  }

}