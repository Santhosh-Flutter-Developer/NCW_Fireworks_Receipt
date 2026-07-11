import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'common_widgets.dart';

/// Opens the shared "Select X" bottom sheet: a title, an optional
/// subtitle, a search box, and a filterable list built from [itemsGetter].
///
/// [itemsGetter] (and [isLoadingGetter]) are called inside an [Obx], so
/// passing a getter that reads a `Rx`/`RxList` (e.g. `() =>
/// controller.parties`) keeps the sheet live as that data loads or
/// changes — no need to re-open the sheet once a slow list finishes
/// fetching.
///
/// [topAction], when given, is pinned above the results and is not
/// affected by the search text — used for a fixed "All Parties"-style
/// clear-filter row.
void showSearchablePickerSheet<T>({
  required String title,
  String? subtitle,
  required List<T> Function() itemsGetter,
  required String Function(T item) labelOf,
  required Widget Function(BuildContext context, T item) itemBuilder,
  required ValueChanged<T> onSelected,
  bool Function()? isLoadingGetter,
  String emptyText = 'Nothing available',
  String searchHint = 'Search',
  Widget? topAction,
}) {
  Get.bottomSheet(
    _SearchablePickerSheet<T>(
      title: title,
      subtitle: subtitle,
      itemsGetter: itemsGetter,
      labelOf: labelOf,
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      isLoadingGetter: isLoadingGetter,
      emptyText: emptyText,
      searchHint: searchHint,
      topAction: topAction,
    ),
    isScrollControlled: true,
  );
}

class _SearchablePickerSheet<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<T> Function() itemsGetter;
  final String Function(T) labelOf;
  final Widget Function(BuildContext, T) itemBuilder;
  final ValueChanged<T> onSelected;
  final bool Function()? isLoadingGetter;
  final String emptyText;
  final String searchHint;
  final Widget? topAction;

  const _SearchablePickerSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.itemsGetter,
    required this.labelOf,
    required this.itemBuilder,
    required this.onSelected,
    this.isLoadingGetter,
    required this.emptyText,
    required this.searchHint,
    this.topAction,
  });

  @override
  State<_SearchablePickerSheet<T>> createState() =>
      _SearchablePickerSheetState<T>();
}

class _SearchablePickerSheetState<T> extends State<_SearchablePickerSheet<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          18, 18, 18, MediaQuery.of(context).viewInsets.bottom + 18),
      constraints: BoxConstraints(maxHeight: Get.height * 0.75),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: AppTextStyles.h3),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(widget.subtitle!,
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
          ],
          const SizedBox(height: 12),
          SearchField(
            hint: widget.searchHint,
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
          if (widget.topAction != null) ...[
            const SizedBox(height: 4),
            widget.topAction!,
          ],
          const SizedBox(height: 6),
          Flexible(
            child: Obx(() {
              final isLoading = widget.isLoadingGetter?.call() ?? false;
              if (isLoading) {
                return  Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                      child: CircularProgressIndicator(color: AppColors.gold)),
                );
              }

              final all = widget.itemsGetter();
              final filtered = _query.isEmpty
                  ? all
                  : all
                      .where((item) => widget
                          .labelOf(item)
                          .toLowerCase()
                          .contains(_query.toLowerCase()))
                      .toList();

              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    _query.isEmpty
                        ? widget.emptyText
                        : 'No matches for "$_query"',
                    style: AppTextStyles.caption,
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final item = filtered[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.back();
                      widget.onSelected(item);
                    },
                    child: widget.itemBuilder(context, item),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
