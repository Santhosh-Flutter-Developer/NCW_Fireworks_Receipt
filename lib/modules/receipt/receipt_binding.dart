import 'package:get/get.dart';
import 'receipt_controller.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptController>(() => ReceiptController(), fenix: true);
  }
}
