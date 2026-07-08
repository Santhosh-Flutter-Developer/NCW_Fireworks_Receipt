import 'package:get/get.dart';
import 'party_controller.dart';

class PartyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartyController>(() => PartyController(), fenix: true);
  }
}
