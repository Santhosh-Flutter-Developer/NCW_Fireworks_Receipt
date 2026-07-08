import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final usernameCtrl = TextEditingController(text: '');
  final passwordCtrl = TextEditingController(text: '');

  final obscurePassword = true.obs;
  final isLoading = false.obs;
  final errorText = RxnString();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    errorText.value = null;
    if (usernameCtrl.text.trim().isEmpty || passwordCtrl.text.isEmpty) {
      errorText.value = 'Please enter both username and password';
      return;
    }

    isLoading.value = true;
    // UI-only demo flow — replace with Supabase auth call later.
    await Future.delayed(const Duration(milliseconds: 900));
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.dashboard);
  }

  @override
  void onClose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
