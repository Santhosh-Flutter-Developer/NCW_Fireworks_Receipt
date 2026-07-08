import 'package:get/get.dart';
import 'estimation_controller.dart';

class EstimationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EstimationController>(() => EstimationController(),
        fenix: true);
  }
}
