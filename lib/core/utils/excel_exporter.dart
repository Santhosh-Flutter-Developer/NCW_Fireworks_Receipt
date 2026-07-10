import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Small cross-platform helper for building a single-sheet .xlsx file
/// from simple row data and handing it off to the OS/browser to save.
///
/// Works on Web, Android, iOS, Windows, macOS and Linux via `file_saver`
/// (on Web it triggers a browser download; on desktop/mobile it saves
/// to the platform's normal downloads/documents location).
class ExcelExporter {
  const ExcelExporter._();

  /// Builds an .xlsx with a single sheet and saves/downloads it.
  ///
  /// [headers] are the column titles for row 1.
  /// [rows] is a list of rows, each row being a list of cell values
  /// (String, int, double or null) in the same order as [headers].
  static Future<void> export({
    required String fileName,
    required List<String> headers,
    required List<List<Object?>> rows,
    String sheetName = 'Sheet1',
  }) async {
    final excel = Excel.createExcel();

    // The template ships with a default "Sheet1" — reuse it if the name
    // matches, otherwise create the requested sheet and drop the
    // now-unused default one so we don't leave a stray empty tab behind.
    final defaultSheetName = excel.getDefaultSheet();
    final sheet = excel[sheetName];
    if (defaultSheetName != null && defaultSheetName != sheetName) {
      excel.delete(defaultSheetName);
    }

    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (final row in rows) {
      sheet.appendRow(row.map(_toCellValue).toList());
    }

    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    // IMPORTANT: use encode(), not save(). On Flutter Web, `save()` has a
    // side effect of triggering its own browser download (defaulting to
    // "FlutterExcel.xlsx") in addition to returning the bytes — that's
    // what caused a second file to download alongside the one from
    // file_saver below. encode() just returns the bytes, no side effects,
    // so file_saver is the single source of the actual save/download.
    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Could not generate the Excel file.');
    }

    // On Android, `saveFile()` writes to the app's private external
    // storage (Android/data/<package>/files/...) — invisible in the
    // Downloads app / most file managers. `saveAs()` instead opens
    // Android's native "Save As" picker (Storage Access Framework),
    // which lets the file be written to the real public Downloads
    // folder (or wherever the user picks) without extra permissions.
    // Every other platform (Web, iOS, Windows, macOS, Linux) already
    // saves/downloads to the right place via plain saveFile().
    if (!kIsWeb && Platform.isAndroid) {
      await FileSaver.instance.saveAs(
        name: fileName,
        bytes: Uint8List.fromList(bytes),
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    } else {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(bytes),
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    }
  }

  static CellValue? _toCellValue(Object? value) {
    if (value == null) return null;
    if (value is int) return IntCellValue(value);
    if (value is double) return DoubleCellValue(value);
    return TextCellValue(value.toString());
  }
}