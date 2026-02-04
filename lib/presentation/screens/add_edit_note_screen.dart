import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_model.dart';
import '../../logic/note_bloc/note_bloc.dart';
import '../../logic/note_bloc/note_event.dart';

// ignore: must_be_immutable
class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;

  bool isAnalyzing = false;
  String? currentVideoId; // Çalan video ID'si
  String? currentSongName; // Çalan şarkı adı

  AddEditNoteScreen({
    super.key,
    this.note,
    this.isAnalyzing = false,
    this.currentVideoId,
    this.currentSongName,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isReadingMode;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(text: widget.note?.content ?? "");
    _isReadingMode = widget.note != null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context); // Boşsa kaydetmeden çık
      return;
    }

    if (widget.note == null) {
      context.read<NoteBloc>().add(
        AddNote(title: title.isEmpty ? "Başlıksız" : title, content: content),
      );
    } else {
      final updatedNote = NoteModel(
        id: widget.note!.id,
        title: title.isEmpty ? "Başlıksız" : title,
        content: content,
        createdAt: widget.note!.createdAt,
        isSynced: widget.note!.isSynced,
        isFavorite: widget.note!.isFavorite,
        isPinned: widget.note!.isPinned,
      );
      context.read<NoteBloc>().add(UpdateNote(updatedNote));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isReadingMode)
            IconButton(
              onPressed: () {
                setState(() {
                  _isReadingMode = false;
                });
              },
              icon: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
              tooltip: "Düzenle",
            )
          else
            TextButton(
              onPressed: _saveNote,
              child: Text(
                "Bitti",
                style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              readOnly: _isReadingMode,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: const InputDecoration(
                hintText: "Başlık",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 28, fontWeight: FontWeight.bold),
                border: InputBorder.none, // Çizgi yok
              ),
              // textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 8),

            Expanded(
              child: TextField(
                controller: _contentController,
                readOnly: _isReadingMode,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                decoration: const InputDecoration(
                  hintText: "Yazmaya başla...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
