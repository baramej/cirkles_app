import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Tiny helper widget to share the debug_logs.txt created by the
/// simple_file_logger helper. Drop this widget into a settings/about
/// screen in TestFlight builds to allow testers to send the file.
class DebugLogShareButton extends StatefulWidget {
  const DebugLogShareButton({super.key});

  @override
  State<DebugLogShareButton> createState() => _DebugLogShareButtonState();
}

class _DebugLogShareButtonState extends State<DebugLogShareButton> {
  bool _sharing = false;

  Future<File> _debugLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/debug_logs.txt');
  }

  Future<void> _shareLogs() async {
    setState(() => _sharing = true);
    try {
      final file = await _debugLogFile();
      final exists = await file.exists();
      if (!exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No debug log found.')),
        );
        return;
      }

      // Use share_plus to open the platform share sheet with the file.
      // shareXFiles will attach the file (XFile) to the share sheet.
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'App debug logs',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share debug log: $e')),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _sharing ? null : _shareLogs,
      icon: const Icon(Icons.share),
      label: _sharing ? const Text('Preparing...') : const Text('Share debug log'),
    );
  }
}
