import 'package:hive/hive.dart';

part 'sync_task_model.g.dart';

@HiveType(typeId: 1)
enum SyncAction {
  @HiveField(0)
  create,
  @HiveField(1)
  update,
  @HiveField(2)
  delete,
}

@HiveType(typeId: 2)
class SyncTaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final SyncAction action;

  @HiveField(2)
  final Map<String, dynamic> payload;

  @HiveField(3)
  final DateTime createdAt;

  SyncTaskModel({
    required this.id,
    required this.action,
    required this.payload,
    required this.createdAt,
  });
}
