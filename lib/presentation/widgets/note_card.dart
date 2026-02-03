import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;
  final VoidCallback onPin;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onFavorite,
    required this.onPin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      child: Slidable(
        key: Key(note.id),

        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            // Pin
            SlidableAction(
              onPressed: (_) => onPin(),
              backgroundColor: AppColors.pin,
              foregroundColor: Colors.white,
              icon: note.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
              label: 'Pin',
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            // Fav
            SlidableAction(
              onPressed: (_) => onFavorite(),
              backgroundColor: AppColors.star,
              foregroundColor: Colors.white,
              icon: note.isFavorite ? Icons.star_border : Icons.star,
              label: 'Fav',
            ),
            // 3. Delete
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppColors.delete,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Sil',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ],
        ),

        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor, width: 1),
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withAlpha(30),
                  blurRadius: 10,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: AppTextStyles.header(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note.content,
                        style: AppTextStyles.body(context).copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    if (note.isPinned)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.push_pin, color: AppColors.pin, size: 20),
                      ),
                    if (note.isFavorite) const Icon(Icons.star, color: AppColors.star, size: 20),

                    if (!note.isSynced)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(Icons.cloud_upload, color: Colors.orange.shade300, size: 16),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
