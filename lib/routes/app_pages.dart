import 'package:get/get.dart';
import 'package:ncw_fireworks/modules/price_upload/price_upload_binding.dart';
import 'package:ncw_fireworks/modules/price_upload/price_upload_list_view.dart';
import '../modules/auth/login_binding.dart';
import '../modules/auth/login_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/estimation/estimation_binding.dart';
import '../modules/estimation/estimation_form_view.dart';
import '../modules/estimation/estimation_list_view.dart';
import '../modules/party/party_binding.dart';
import '../modules/party/party_form_view.dart';
import '../modules/party/party_list_view.dart';
import '../modules/product/product_binding.dart';
import '../modules/product/product_form_view.dart';
import '../modules/product/product_list_view.dart';
import '../modules/quotation/quotation_binding.dart';
import '../modules/quotation/quotation_form_view.dart';
import '../modules/quotation/quotation_list_view.dart';
import '../modules/receipt/receipt_binding.dart';
import '../modules/receipt/receipt_form_view.dart';
import '../modules/receipt/receipt_list_view.dart';
import '../modules/stock_adjustment/stock_adjustment_binding.dart';
import '../modules/stock_adjustment/stock_adjustment_form_view.dart';
import '../modules/stock_adjustment/stock_adjustment_list_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.partyList,
      page: () => const PartyListView(),
      binding: PartyBinding(),
    ),
    GetPage(
      name: AppRoutes.partyForm,
      page: () => const PartyFormView(),
      binding: PartyBinding(),
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productForm,
      page: () => const ProductFormView(),
      binding: ProductBinding(),
    ),
     GetPage(
      name: AppRoutes.priceUpload,
      page: () => const PriceUploadListView(),
      binding: PriceUploadBinding(),
    ),
    GetPage(
      name: AppRoutes.quotationList,
      page: () => const QuotationListView(),
      binding: QuotationBinding(),
    ),
    GetPage(
      name: AppRoutes.quotationForm,
      page: () => const QuotationFormView(),
      binding: QuotationBinding(),
    ),
    GetPage(
      name: AppRoutes.estimationList,
      page: () => const EstimationListView(),
      binding: EstimationBinding(),
    ),
    GetPage(
      name: AppRoutes.estimationForm,
      page: () => const EstimationFormView(),
      binding: EstimationBinding(),
    ),
    GetPage(
      name: AppRoutes.receiptList,
      page: () => const ReceiptListView(),
      binding: ReceiptBinding(),
    ),
    GetPage(
      name: AppRoutes.receiptForm,
      page: () => const ReceiptFormView(),
      binding: ReceiptBinding(),
    ),
    GetPage(
      name: AppRoutes.stockAdjustmentList,
      page: () => const StockAdjustmentListView(),
      binding: StockAdjustmentBinding(),
    ),
    GetPage(
      name: AppRoutes.stockAdjustmentForm,
      page: () => const StockAdjustmentFormView(),
      binding: StockAdjustmentBinding(),
    ),
  ];
}
