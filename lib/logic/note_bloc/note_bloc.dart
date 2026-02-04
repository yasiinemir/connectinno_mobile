import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;

  NoteBloc({required this.noteRepository}) : super(NoteInitial()) {
    // 1. Notları Getir
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      try {
        final notes = await noteRepository.getNotes();
        emit(NoteLoaded(notes));
      } catch (e) {
        emit(NoteError("Notlar yüklenirken hata oluştu: $e"));
      }
    });

    on<AddNote>((event, emit) async {
      try {
        await noteRepository.createNote(event.title, event.content);
        add(LoadNotes()); // Listeyi güncelle
      } catch (e) {
        emit(NoteError("Not eklenemedi: $e"));
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        await noteRepository.updateNote(event.note);
        add(LoadNotes());
      } catch (e) {
        emit(NoteError("Not güncellenemedi: $e"));
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        await noteRepository.deleteNote(event.id);
        add(LoadNotes());
      } catch (e) {
        emit(NoteError("Not silinemedi: $e"));
      }
    });

    on<ClearNotes>((event, emit) {
      emit(NoteInitial());
    });
  }
}
