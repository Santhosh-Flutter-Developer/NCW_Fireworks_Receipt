import 'package:get/get.dart';
import 'stock_adjustment_controller.dart';

class StockAdjustmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockAdjustmentController>(
      () => StockAdjustmentController(),
      fenix: true,
    );
  }
}
