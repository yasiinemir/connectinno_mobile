import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MusicPlayerWidget extends StatefulWidget {
  final String videoId;
  final String songName;
  final VoidCallback onClose;

  const MusicPlayerWidget({
    super.key,
    required this.videoId,
    required this.songName,
    required this.onClose,
  });

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true, // Otomatik başlasın
        mute: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        hideControls: true, // Kontrolleri gizle, sadece müzik aksın
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 10)],
      ),
      child: Row(
        children: [
          // Müzik İkonu Animasyonu (Görsel süs)
          const Icon(Icons.music_note, color: Colors.white),
          const SizedBox(width: 10),

          // Şarkı İsmi
          Expanded(
            child: Text(
              "Çalıyor: ${widget.songName}",
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Player (Görünmez yapıyoruz ama ses çalıyor)
          SizedBox(
            width: 1,
            height: 1,
            child: YoutubePlayer(controller: _controller, showVideoProgressIndicator: false),
          ),

          // Kapatma Butonu
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }
}
