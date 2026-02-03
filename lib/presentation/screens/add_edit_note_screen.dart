import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/note_model.dart';
import '../../logic/note_bloc/note_bloc.dart';
import '../../logic/note_bloc/note_event.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(text: widget.note?.content ?? "");
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
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // KAYDET BUTONU
          TextButton(
            onPressed: _saveNote,
            child: const Text(
              "Bitti",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
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
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: "Başlık",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 28, fontWeight: FontWeight.bold),
                border: InputBorder.none, // Çizgi yok
              ),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 8),

            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 18, height: 1.5, color: Colors.black87),
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
