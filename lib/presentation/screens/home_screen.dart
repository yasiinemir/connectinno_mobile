import 'package:connectionno_mobile/logic/theme_cubit/theme_cubit.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

                  Text(
                    "Ana Ekran",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
                color: _showFavoritesOnly
                    ? AppColors.star
                    : (Theme.of(context).iconTheme.color ?? Colors.grey),
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
                color: Theme.of(context).iconTheme.color ?? Colors.grey,
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
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      // Şu anki tema karanlık mı kontrol et
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      final isDark = Theme.of(context).brightness == Brightness.dark;
                      context.read<ThemeCubit>().toggleTheme(!isDark);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
                    onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
                  ),
                ],
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
          color: Theme.of(context).cardColor,
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
