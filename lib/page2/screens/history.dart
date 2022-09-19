import 'package:finalboss/page2/imports.dart';
import 'package:finalboss/page2/model/historyitem.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class History extends StatelessWidget {
  History({Key key}) : super(key: key);
  final List<HistoryItem> result = Hive.box<HistoryItem>('history')
      .values
      .toList()
      .reversed
      .toList()
      .cast<HistoryItem>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(
        context,
        'ประวัติการคำนวณ',
        Icons.auto_delete_outlined,
        () {
          Navigator.pop(context);
          Hive.box<HistoryItem>('history').clear();
          showToast(context, 'ล้างประวัติการคำนวณเรียบร้อย');
        },
      ),
      body: result.isEmpty
          ? Center(
              child: Text(
                'ไม่มีปะวัติการคำนวณ',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontSize: 24.0),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(10.0),
              itemCount: result.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  tileColor: buttonsBackgroundColor,
                  title: Text(result[i].title),
                  subtitle: Text(result[i].subtitle),
                );
              },
            ),
    );
  }
}
