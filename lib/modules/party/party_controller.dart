import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/party_model.dart';

class PartyController extends GetxController {
  final parties = <PartyModel>[].obs;
  final searchQuery = ''.obs;
  final filterAgent = RxnString();
  final isTableView = false.obs;

  // Pagination (mirrors the web app's Page Limit / Page No controls)
  final pageLimit = 10.obs;
  final pageNo = 1.obs;
  static const List<int> pageLimitOptions = [10, 25, 50, 100];

  // Dropdown data sources
  List<String> get agentOptions => DummyData.agents;
  List<String> get stateOptions => DummyData.states;
  List<String> districtOptions(String state) =>
      DummyData.districtsByState[state] ?? [];
  List<String> cityOptions(String district) =>
      DummyData.citiesByDistrict[district] ?? [];

  // Form fields (used by PartyFormView)
  PartyModel? editingParty;
  final formAgent = RxnString();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final formState = 'Tamil Nadu'.obs;
  final formDistrict = RxnString();
  final formCity = RxnString();
  final pincodeCtrl = TextEditingController();
  final identificationCtrl = TextEditingController();
  final gstinCtrl = TextEditingController();
  final openingBalanceCtrl = TextEditingController();
  final formBalanceType = Rx<BalanceType>(BalanceType.credit);

  @override
  void onInit() {
    super.onInit();
    parties.assignAll(DummyData.parties());
  }

  List<PartyModel> get filtered {
    final list = parties.where((p) {
      final q = searchQuery.value.toLowerCase();
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.phone.contains(q) ||
          p.city.toLowerCase().contains(q);
      final matchesAgent =
          filterAgent.value == null || p.agent == filterAgent.value;
      return matchesQuery && matchesAgent;
    }).toList();
    return list;
  }

  int get totalPages {
    final count = filtered.length;
    if (count == 0) return 1;
    return (count / pageLimit.value).ceil();
  }

  List<PartyModel> get paginated {
    final list = filtered;
    if (pageNo.value > totalPages) pageNo.value = totalPages;
    final start = (pageNo.value - 1) * pageLimit.value;
    if (start >= list.length) return [];
    final end = (start + pageLimit.value).clamp(0, list.length);
    return list.sublist(start, end);
  }

  void setSearch(String value) {
    searchQuery.value = value;
    pageNo.value = 1;
  }

  void setAgentFilter(String? agent) {
    filterAgent.value = filterAgent.value == agent ? null : agent;
    pageNo.value = 1;
  }

  void setPageLimit(int limit) {
    pageLimit.value = limit;
    pageNo.value = 1;
  }

  void setPageNo(int page) => pageNo.value = page;
  void toggleViewMode(bool table) => isTableView.value = table;

  void startCreate() {
    editingParty = null;
    formAgent.value = null;
    nameCtrl.clear();
    phoneCtrl.clear();
    emailCtrl.clear();
    addressCtrl.clear();
    formState.value = 'Tamil Nadu';
    formDistrict.value = null;
    formCity.value = null;
    pincodeCtrl.clear();
    identificationCtrl.clear();
    gstinCtrl.clear();
    openingBalanceCtrl.clear();
    formBalanceType.value = BalanceType.credit;
  }

  void startEdit(PartyModel party) {
    editingParty = party;
    formAgent.value = party.agent.isEmpty ? null : party.agent;
    nameCtrl.text = party.name;
    phoneCtrl.text = party.phone;
    emailCtrl.text = party.email;
    addressCtrl.text = party.address;
    formState.value = party.state.isEmpty ? 'Tamil Nadu' : party.state;
    formDistrict.value = party.district.isEmpty ? null : party.district;
    formCity.value = party.city.isEmpty ? null : party.city;
    pincodeCtrl.text = party.pincode;
    identificationCtrl.text = party.identification;
    gstinCtrl.text = party.gstin;
    openingBalanceCtrl.text =
        party.openingBalance == 0 ? '' : party.openingBalance.toString();
    formBalanceType.value = party.balanceType;
  }

  /// Returns a validation error message, or null if the form is valid.
  /// Only Party Name and State are mandatory (matching the web form's `*`
  /// fields); everything else is optional so a Draft can be saved freely.
  String? _validate({required bool isDraft}) {
    if (isDraft) return null;
    if (nameCtrl.text.trim().isEmpty) return 'Party name is required';
    if (nameCtrl.text.trim().length > 60) {
      return 'Party name must be 60 characters or fewer';
    }
    if (phoneCtrl.text.isNotEmpty &&
        !RegExp(r'^\d{10}$').hasMatch(phoneCtrl.text.trim())) {
      return 'Phone number must be exactly 10 digits';
    }
    if (emailCtrl.text.length > 50) {
      return 'Email must be 50 characters or fewer';
    }
    if (pincodeCtrl.text.isNotEmpty &&
        !RegExp(r'^\d{6}$').hasMatch(pincodeCtrl.text.trim())) {
      return 'Pincode must be exactly 6 digits';
    }
    if (gstinCtrl.text.isNotEmpty &&
        !RegExp(r'^[0-9]{2}[A-Z0-9]{10}[0-9][A-Z][0-9A-Z]$')
            .hasMatch(gstinCtrl.text.trim().toUpperCase())) {
      return 'GST format looks invalid (e.g. 29GGGGG1314R9Z6)';
    }
    return null;
  }

  bool save({bool asDraft = false}) {
    final error = _validate(isDraft: asDraft);
    if (error != null) {
      Get.snackbar('Check the form', error,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (!asDraft && nameCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing info', 'Party name is required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final balance = double.tryParse(openingBalanceCtrl.text) ?? 0;

    if (editingParty != null) {
      editingParty!
        ..agent = formAgent.value ?? ''
        ..name = nameCtrl.text.trim()
        ..phone = phoneCtrl.text.trim()
        ..email = emailCtrl.text.trim()
        ..address = addressCtrl.text.trim()
        ..state = formState.value
        ..district = formDistrict.value ?? ''
        ..city = formCity.value ?? ''
        ..pincode = pincodeCtrl.text.trim()
        ..identification = identificationCtrl.text.trim()
        ..gstin = gstinCtrl.text.trim().toUpperCase()
        ..openingBalance = balance
        ..balanceType = formBalanceType.value
        ..isDraft = asDraft;
      parties.refresh();
    } else {
      parties.insert(
        0,
        PartyModel(
          id: 'P${(parties.length + 1).toString().padLeft(3, '0')}',
          agent: formAgent.value ?? '',
          name: nameCtrl.text.trim().isEmpty
              ? 'Untitled Party'
              : nameCtrl.text.trim(),
          phone: phoneCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          address: addressCtrl.text.trim(),
          state: formState.value,
          district: formDistrict.value ?? '',
          city: formCity.value ?? '',
          pincode: pincodeCtrl.text.trim(),
          identification: identificationCtrl.text.trim(),
          gstin: gstinCtrl.text.trim().toUpperCase(),
          openingBalance: balance,
          balanceType: formBalanceType.value,
          isDraft: asDraft,
        ),
      );
    }
    Get.back();
    Get.snackbar(
      asDraft ? 'Saved as draft' : 'Saved',
      asDraft
          ? 'Party saved as a draft'
          : 'Party details saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
    return true;
  }

  void deleteParty(PartyModel party) {
    parties.remove(party);
    Get.snackbar('Deleted', '${party.name} was removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    pincodeCtrl.dispose();
    identificationCtrl.dispose();
    gstinCtrl.dispose();
    openingBalanceCtrl.dispose();
    super.onClose();
  }
}
