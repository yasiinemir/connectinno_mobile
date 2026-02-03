import 'package:connectionno_mobile/presentation/screens/add_edit_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../logic/auth_bloc/auth_bloc.dart';
import '../../logic/auth_bloc/auth_event.dart';
import '../../logic/note_bloc/note_bloc.dart';
import '../../logic/note_bloc/note_event.dart';
import '../../logic/note_bloc/note_state.dart';
import '../../data/models/note_model.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Ana Ekran",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  CustomSearchBar(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchText = val),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        if (state is NoteLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is NoteLoaded) {
                          var notes = state.notes;

                          if (_showFavoritesOnly) {
                            notes = notes.where((n) => n.isFavorite).toList();
                          }
                          if (_searchText.isNotEmpty) {
                            notes = notes
                                .where(
                                  (n) => n.title.toLowerCase().contains(_searchText.toLowerCase()),
                                )
                                .toList();
                          }

                          notes.sort((a, b) {
                            if (b.isPinned && !a.isPinned) return 1;
                            if (!b.isPinned && a.isPinned) return -1;
                            return b.createdAt.compareTo(a.createdAt);
                          });

                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return NoteCard(
                                note: note,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditNoteScreen(note: note),
                                    ),
                                  );
                                },
                                onDelete: () => context.read<NoteBloc>().add(DeleteNote(note.id)),
                                onFavorite: () {
                                  final updated = NoteModel(
                                    id: note.id,
                                    title: note.title,
                                    content: note.content,
                                    createdAt: note.createdAt,
                                    isSynced: note.isSynced,
                                    isPinned: note.isPinned,
                                    isFavorite: !note.isFavorite,
                                  );
                                  context.read<NoteBloc>().add(UpdateNote(updated));
                                },
                                onPin: () {
                                  final updated = NoteModel(
                                    id: note.id,
                                    title: note.title,
                                    content: note.content,
                                    createdAt: note.createdAt,
                                    isSynced: note.isSynced,
                                    isPinned: !note.isPinned,
                                    isFavorite: note.isFavorite,
                                  );
                                  context.read<NoteBloc>().add(UpdateNote(updated));
                                },
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 30,
              bottom: 40,
              child: _buildCircleButton(
                icon: _showFavoritesOnly ? Icons.star : Icons.star_border,
                color: _showFavoritesOnly ? AppColors.star : Colors.grey,
                onTap: () {
                  setState(() => _showFavoritesOnly = !_showFavoritesOnly);
                },
              ),
            ),

            Positioned(
              right: 30,
              bottom: 40,
              child: _buildCircleButton(
                icon: Icons.add,
                color: Colors.grey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
                  );
                },
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.grey),
                onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
