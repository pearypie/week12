import 'package:hive/hive.dart';

part 'historyitem.g.dart';

@HiveType(typeId: 0)
class HistoryItem extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String subtitle;
  // HistoryItem(this.title, this.subtitle);
}
