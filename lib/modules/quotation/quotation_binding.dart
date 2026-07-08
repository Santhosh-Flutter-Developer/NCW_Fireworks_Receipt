import 'package:get/get.dart';
import 'quotation_controller.dart';

class QuotationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuotationController>(() => QuotationController(),
        fenix: true);
  }
}
