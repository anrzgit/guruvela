import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/college_prediction.dart';
import '../../data/models/csab_prediction.dart';

/// Builds a CSV from prediction rows and opens the share sheet, mirroring the
/// web app's "Download / Export" buttons.
///
/// Header columns match the web export exactly:
/// `Institute Name,Branch Name,Quota,Expected Closing Rank`.
abstract final class CsvExporter {
  CsvExporter._();

  static const _headers = [
    'Institute Name',
    'Branch Name',
    'Quota',
    'Expected Closing Rank',
  ];

  static Future<void> exportJosaa(List<CollegePrediction> rows) async {
    final data = <List<dynamic>>[
      _headers,
      for (final r in rows)
        [r.instituteName, r.branchName, r.quota, r.closingRank],
    ];
    await _writeAndShare(data, 'guruvela_predictions.csv');
  }

  static Future<void> exportCsab(List<CsabPrediction> rows) async {
    final data = <List<dynamic>>[
      _headers,
      for (final r in rows)
        [r.instituteName, r.branchName, r.quota, r.closingRank],
    ];
    await _writeAndShare(data, 'guruvela_csab_predictions.csv');
  }

  static Future<void> _writeAndShare(
    List<List<dynamic>> data,
    String filename,
  ) async {
    final csv = const ListToCsvConverter().convert(data);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(csv);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Guruvela predictions',
    );
  }
}
