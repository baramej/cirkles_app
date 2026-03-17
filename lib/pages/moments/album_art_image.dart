import 'dart:convert';

import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlbumArtWidget extends StatefulWidget {
  final int stationId;
  final double width;
  final double height;
  final double borderRadius;

  const AlbumArtWidget({
    super.key,
    required this.stationId,
    this.width = 60,
    this.height = 60,
    this.borderRadius = 12,
  });

  @override
  State<AlbumArtWidget> createState() => _AlbumArtWidgetState();
}

class _AlbumArtWidgetState extends State<AlbumArtWidget> {
  String? _albumArtUrl;
  bool _isLoadingAlbumArt = true;
  bool _hasErrorLoadingAlbumArt = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAlbumArt();
    });
  }

  Future<void> _fetchAlbumArt() async {
    setState(() {
      _isLoadingAlbumArt = true;
      _hasErrorLoadingAlbumArt = false;
    });
    final url = Uri.parse('${AppConfig.azuraCastServerUrl}/api/station/${widget.stationId}/custom_assets/album_art');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'X-API-Key': AppConfig.azuraCastApiKey,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['hasRecord'] == true && data['url'] != null) {
        final String relativePath = data['url'];
        final fullImageUrl = '${AppConfig.azuraCastServerUrl}$relativePath';

        setState(() {
          _albumArtUrl = fullImageUrl;
          _isLoadingAlbumArt = false;
        });
      } else {
        setState(() {
          _hasErrorLoadingAlbumArt = true;
          _isLoadingAlbumArt = false;
        });
      }
    } else {
      setState(() {
        _hasErrorLoadingAlbumArt = true;
        _isLoadingAlbumArt = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget albumArtContent;

    if (_isLoadingAlbumArt) {
      albumArtContent = const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        strokeWidth: 2,
      );
    } else if (_hasErrorLoadingAlbumArt || _albumArtUrl == null) {
      albumArtContent = const Icon(Icons.broken_image, size: 30, color: Colors.white70);
    } else {
      albumArtContent = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.network(
          _albumArtUrl!,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error,
              size: 30,
              color: Colors.white70,
            );
          },
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Center(
        child: albumArtContent,
      ),
    );
  }
}
