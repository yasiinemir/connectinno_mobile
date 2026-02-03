import 'package:equatable/equatable.dart';
import '../../data/models/note_model.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final String title;
  final String content;

  const AddNote({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}

class UpdateNote extends NoteEvent {
  final NoteModel note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String id;

  const DeleteNote(this.id);

  @override
  List<Object> get props => [id];
}
