import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/party_model.dart';
import '../../widgets/common_widgets.dart';
import 'party_controller.dart';

class PartyFormView extends GetView<PartyController> {
  const PartyFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingParty != null;
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Party' : 'Add Party'),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              const SectionLabel(text: 'Party Details'),
              _field(
                'Party Name *',
                controller.nameCtrl,
                hint: 'e.g. Sri Lakshmi Traders',
                helper: 'Contains Text, Symbols &.,. Max Char: 60',
                maxLength: 60,
              ),
              _field(
                'Phone Number',
                controller.phoneCtrl,
                hint: '10-digit mobile number',
                helper: 'Numbers Only (only 10 digits)',
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              _field(
                'Email',
                controller.emailCtrl,
                hint: 'name@example.com',
                helper: 'Max Char: 50',
                keyboardType: TextInputType.emailAddress,
                maxLength: 50,
              ),
              _field(
                'Address',
                controller.addressCtrl,
                hint: 'Street, area',
                helper:
                    'Contains Text, Numbers, Symbols (Except <>?{}!*^%\$). Max character: 150',
                maxLines: 3,
                maxLength: 150,
              ),
              const SizedBox(height: 8),
              const SectionLabel(text: 'Location'),
              Text('State *', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Obx(() => _searchableDropdownField(
                    context: context,
                    title: 'Select State',
                    value: controller.formState.value,
                    hint: 'Select',
                    options: controller.stateOptions,
                    onChanged: controller.setFormState,
                  )),
              const SizedBox(height: 16),
              Text('District', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Obx(() => _searchableDropdownField(
                    context: context,
                    title: 'Select District',
                    value: controller.formDistrict.value,
                    hint: 'Select',
                    options:
                        controller.districtOptions(controller.formState.value),
                    onChanged: controller.setFormDistrict,
                  )),
              const SizedBox(height: 16),
              Text('City', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Obx(() => _searchableDropdownField(
                    context: context,
                    title: 'Select City',
                    value: controller.formCity.value,
                    hint: 'Select',
                    options: controller.cityOptions(controller.formState.value),
                    onChanged: controller.setFormCity,
                  )),
              Obx(() {
                if (controller.formCity.value != 'Others') {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _field(
                    'Others city *',
                    controller.othersCityCtrl,
                    hint: 'e.g. Thiruthangal',
                    helper: 'Text Only (Max Char: 30)',
                    maxLength: 30,
                  ),
                );
              }),
              const SizedBox(height: 16),
              _field(
                'Pincode',
                controller.pincodeCtrl,
                hint: '6-digit pincode',
                helper: 'Numbers only (only 6 digits)',
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              const SizedBox(height: 8),
              const SectionLabel(text: 'Identification'),
              _field(
                'Identification',
                controller.identificationCtrl,
                hint: 'ID / license number',
                helper:
                    'Contains Text, Numbers, Symbols (Except <>?{}!*^%\$). Max character: 50',
                maxLength: 50,
              ),
              _field(
                'GST',
                controller.gstinCtrl,
                hint: '29GGGGG1314R9Z6',
                helper: 'Format: 29GGGGG1314R9Z6',
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 8),
              const SectionLabel(text: 'Opening Balance'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _field(
                      'Amount',
                      controller.openingBalanceCtrl,
                      hint: '0.00',
                      helper: 'Upto Rs.50 Lakhs',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 23),
                      child: Obx(() => _balanceTypeDropdown()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          child: Obx(() {
            final saving = controller.isSaving.value;
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        saving ? null : () => controller.save(asDraft: true),
                    child: const Text('Draft'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: saving ? null : () => controller.save(),
                    child: saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditing ? 'Update' : 'Submit'),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    String? helper,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            maxLength: maxLength,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              counterText: '',
            ),
          ),
          if (helper != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 2),
              child: Text(
                helper,
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  /// Looks like [_dropdownField] but opens a searchable bottom sheet
  /// instead of a native dropdown menu — used for State/District/City,
  /// where the option lists can run into the hundreds.
  Widget _searchableDropdownField({
    required BuildContext context,
    required String title,
    required String? value,
    required String hint,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: options.isEmpty
          ? null
          : () => _openSearchablePicker(
                context: context,
                title: title,
                options: options,
                selected: value,
                onSelected: onChanged,
              ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: AppTextStyles.body.copyWith(
                  color: value == null
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearchablePicker({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _SearchablePickerSheet(
          title: title,
          options: options,
          selected: selected,
          onSelected: (v) {
            onSelected(v);
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  Widget _dropdownField({
    required String? value,
    required String hint,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(hint,
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          dropdownColor: AppColors.surfaceElevated,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: options.isEmpty ? null : onChanged,
        ),
      ),
    );
  }

  Widget _balanceTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BalanceType>(
          value: controller.formBalanceType.value,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          dropdownColor: AppColors.surfaceElevated,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          items: BalanceType.values
              .map((b) => DropdownMenuItem(value: b, child: Text(b.label)))
              .toList(),
          onChanged: (v) {
            if (v != null) controller.formBalanceType.value = v;
          },
        ),
      ),
    );
  }
}

/// The search + list content shown inside the bottom sheet opened by
/// [PartyFormView._openSearchablePicker]. Stateful only for the live
/// search filter — the actual selection is reported straight back
/// through [onSelected].
class _SearchablePickerSheet extends StatefulWidget {
  const _SearchablePickerSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  State<_SearchablePickerSheet> createState() =>
      _SearchablePickerSheetState();
}

class _SearchablePickerSheetState extends State<_SearchablePickerSheet> {
  final _searchCtrl = TextEditingController();
  late List<String> _filtered = widget.options;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.options
          : widget.options
              .where((o) => o.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.title,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  onChanged: _onSearchChanged,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.midnight,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Text('No matches',
                            style: AppTextStyles.caption),
                      )
                    : ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final option = _filtered[index];
                          final isSelected = option == widget.selected;
                          return ListTile(
                            title: Text(
                              option,
                              style: AppTextStyles.body.copyWith(
                                color: isSelected
                                    ? AppColors.gold
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_circle,
                                    color: AppColors.gold)
                                : null,
                            onTap: () => widget.onSelected(option),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
