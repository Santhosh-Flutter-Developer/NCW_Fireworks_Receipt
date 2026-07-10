import 'package:get/get.dart';
import 'price_upload_controller.dart';

class PriceUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PriceUploadController>(
      () => PriceUploadController(),
      fenix: true,
    );
  }
}
