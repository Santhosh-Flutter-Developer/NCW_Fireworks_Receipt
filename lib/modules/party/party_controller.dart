import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_exception.dart';
import '../../core/services/session_service.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/party_model.dart';
import '../../data/respositories/party_repository.dart';

class PartyController extends GetxController {
  PartyController({
    PartyRepository? partyRepository,
    SessionService? sessionService,
  })  : _partyRepository = partyRepository ?? PartyRepository(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final PartyRepository _partyRepository;
  final SessionService _sessionService;

  final parties = <PartyModel>[].obs;
  final searchQuery = ''.obs;
  final filterAgent = RxnString();
  final isTableView = false.obs;
  final isSaving = false.obs;

  // Pagination (mirrors the web app's Page Limit / Page No controls)
  final pageLimit = 10.obs;
  final pageNo = 1.obs;
  static const List<int> pageLimitOptions = [10, 25, 50, 100];

  // Dropdown data sources
  List<String> get agentOptions => DummyData.agents;
  List<String> get stateOptions => DummyData.states;
  List<String> districtOptions(String state) =>
      DummyData.districtsByState[state] ?? [];
  List<String> cityOptions(String state) => [
        ...DummyData.citiesByState[state] ?? [],
        'Others',
      ];

  void setFormState(String? value) {
    if (value == null) return;
    formState.value = value;
    formDistrict.value = null;
    setFormCity(null);
  }

  void setFormDistrict(String? value) {
    formDistrict.value = value;
    setFormCity(null);
  }

  void setFormCity(String? value) {
    formCity.value = value;
    if (value != 'Others') othersCityCtrl.clear();
  }

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
  final othersCityCtrl = TextEditingController();
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
    othersCityCtrl.clear();
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
    othersCityCtrl.text = party.othersCity;
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
    if (formCity.value == 'Others') {
      final othersCity = othersCityCtrl.text.trim();
      if (othersCity.isEmpty) {
        return 'Others city is required';
      }
      if (othersCity.length > 30 || !RegExp(r'^[A-Za-z\s]+$').hasMatch(othersCity)) {
        return 'Others city must be text only, up to 30 characters';
      }
    }
    if (gstinCtrl.text.isNotEmpty &&
        !RegExp(r'^[0-9]{2}[A-Z0-9]{10}[0-9][A-Z][0-9A-Z]$')
            .hasMatch(gstinCtrl.text.trim().toUpperCase())) {
      return 'GST format looks invalid (e.g. 29GGGGG1314R9Z6)';
    }
    return null;
  }

  /// Credit/Debit → the numeric code the API expects for
  /// `opening_balance_type`. Confirmed against the live API's behavior.
  static const Map<BalanceType, String> _balanceTypeCode = {
    BalanceType.credit: '1',
    BalanceType.debit: '2',
  };

  Future<bool> save({bool asDraft = false}) async {
    if (isSaving.value) return false;

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

    final session = _sessionService.currentSession.value;
    if (session == null) {
      Get.snackbar('Session expired', 'Please log in again',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final balance = double.tryParse(openingBalanceCtrl.text) ?? 0;
    final name = nameCtrl.text.trim().isEmpty
        ? 'Untitled Party'
        : nameCtrl.text.trim();

    // party.php always requires party_name (and validates it against
    // existing records) and has no real "draft" flag in the payload it
    // accepts — a Draft save (which may have an empty/incomplete name)
    // can't be safely sent there, so drafts stay local-only for now.
    if (asDraft) {
      _applyLocally(asDraft: true, balance: balance, name: name);
      Get.back();
      Get.snackbar('Saved as draft', 'Party saved as a draft on this device',
          snackPosition: SnackPosition.BOTTOM);
      return true;
    }

    // Editing a row we never got a real party_id for (e.g. the bundled
    // demo rows, or a row created before the API returned one) can't be
    // sent to party.php — there is nothing for the server to match
    // against — so that case falls back to a local-only update.
    final canSyncToServer =
        editingParty == null || editingParty!.serverPartyId != null;

    if (!canSyncToServer) {
      _applyLocally(asDraft: asDraft, balance: balance, name: name);
      Get.back();
      Get.snackbar(
        'Saved locally',
        'This party isn\'t linked to the server yet, so the change was only saved on this device.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    }

    isSaving.value = true;
    try {
      final result = await _partyRepository.createOrUpdateParty(
        creator: session.userId,
        partyName: name,
        editId: editingParty?.serverPartyId ?? '',
        agentId: '', // No agent id source is wired up yet — see agentOptions.
        mobileNumber: phoneCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        identification: identificationCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        state: formState.value,
        district: formDistrict.value ?? '',
        city: formCity.value ?? '',
        othersCity:
            formCity.value == 'Others' ? othersCityCtrl.text.trim() : null,
        pincode: pincodeCtrl.text.trim(),
        gstNumber: gstinCtrl.text.trim().toUpperCase(),
        openingBalance: balance == 0 ? '' : balance.toString(),
        openingBalanceType:
            balance == 0 ? '' : _balanceTypeCode[formBalanceType.value]!,
      );

      _applyLocally(asDraft: asDraft, balance: balance, name: name);
      Get.back();
      Get.snackbar('Saved', result.message,
          snackPosition: SnackPosition.BOTTOM);
      return true;
    } on ApiRequestException catch (e) {
      // Business-rule rejection (duplicate name/mobile, invalid agent,
      // etc.) — the server's own message is already presentable.
      Get.snackbar('Could not save', e.message,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } on ApiException catch (e) {
      Get.snackbar('Could not save', e.message,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Mirrors the confirmed save into the in-memory list that backs the
  /// Party list screen. Runs after either a successful API call or a
  /// local-only save.
  void _applyLocally({
    required bool asDraft,
    required double balance,
    required String name,
  }) {
    if (editingParty != null) {
      editingParty!
        ..agent = formAgent.value ?? ''
        ..name = name
        ..phone = phoneCtrl.text.trim()
        ..email = emailCtrl.text.trim()
        ..address = addressCtrl.text.trim()
        ..state = formState.value
        ..district = formDistrict.value ?? ''
        ..city = formCity.value ?? ''
        ..othersCity = formCity.value == 'Others' ? othersCityCtrl.text.trim() : ''
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
          name: name,
          phone: phoneCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          address: addressCtrl.text.trim(),
          state: formState.value,
          district: formDistrict.value ?? '',
          city: formCity.value ?? '',
          othersCity:
              formCity.value == 'Others' ? othersCityCtrl.text.trim() : '',
          pincode: pincodeCtrl.text.trim(),
          identification: identificationCtrl.text.trim(),
          gstin: gstinCtrl.text.trim().toUpperCase(),
          openingBalance: balance,
          balanceType: formBalanceType.value,
          isDraft: asDraft,
        ),
      );
    }
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
    othersCityCtrl.dispose();
    identificationCtrl.dispose();
    gstinCtrl.dispose();
    openingBalanceCtrl.dispose();
    super.onClose();
  }
}
