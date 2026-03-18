import 'dart:io';

import 'package:matrix/matrix_api_lite/utils/logs.dart';
import 'package:path_provider/path_provider.dart';

/// Minimal file + console logger used for background diagnostics.
/// Writes an append-only file debug_logs.txt in applicationDocumentsDirectory
/// and also logs to the existing Logs() facility so entries appear in the
/// device console (Xcode / Console.app).
Future<File> _debugLogFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/debug_logs.txt');
}

Future<void> appendDebugLog(String entry) async {
  final now = DateTime.now().toIso8601String();
  final line = '[$now] $entry\n';
  try {
    // write file (best-effort)
    final f = await _debugLogFile();
    await f.writeAsString(line, mode: FileMode.append, flush: true);
  } catch (_) {
    // ignore file write errors (don't crash in background)
  }
  try {
    // also print to device console using the app logging facility
    // If your project exposes Logs() as in repo files, call it.
    // Fallback: print()
    try {
      Logs().i(entry);
    } catch (_) {
      // fallback
      // ignore: avoid_print
      print(entry);
    }
  } catch (_) {}
}

/// Dumps DB header (first 16 bytes + size) for quick inspection.
/// Non-fatal: best-effort only.
Future<void> dumpDatabaseHeader(String path) async {
  try {
    final file = File(path);
    final exists = await file.exists();
    final size = exists ? await file.length() : 0;
    var headerBytes = <int>[];
    if (exists) {
      final raf = await file.open();
      headerBytes = await raf.read(16);
      await raf.close();
    }
    final headerAscii =
        headerBytes.isNotEmpty ? String.fromCharCodes(headerBytes.map((b) => b >= 32 && b < 127 ? b : 46)) : '';
    final headerHex = headerBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    await appendDebugLog(
        'DB diagnostic: path=$path exists=$exists size=$size headerAscii="$headerAscii" headerHex="$headerHex"');
  } catch (e, s) {
    await appendDebugLog('dumpDatabaseHeader failed: $e\n$s');
  }
}
