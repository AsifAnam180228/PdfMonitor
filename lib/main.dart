import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/database_helper.dart';
import 'package:pdf_reader/history.dart';
import 'package:pdf_reader/pdfView.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'PDF Reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File file;
  final dbHelper = DatabaseHelper.instance;

  // File Picker

  Future<File> selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      return files.first;
    } else {}
    return null;
  }

  void _insert(pdfName, readTime) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnPdfName: pdfName,
      DatabaseHelper.columnReadTime: readTime,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<List> _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    return allRows;
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnPdfName: 'Mary',
      DatabaseHelper.columnReadTime: 32
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                child: Text('Select PDF'),
                onPressed: () async {
                  file = await selectFile();
                  setState(() {});
                  print(file.path);
                  if (file != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullPdfViewerScreen(file.path, basename(file.path)),
                      ),
                    );
                  } else {}
                }),
            // ElevatedButton(
            //   onPressed: () async {
            //     // int i =
            //     //     await DatabaseHelper.instance.insert({
            //     //       'columnName': 'Ishmam'
            //     //     });
            //     // print(i);
            //   },
            //   child: Text('Add Data'),
            // ),
            ElevatedButton(
              onPressed: () async {
                var historyList = await _query();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(
                      historyList: historyList,
                    ),
                  ),
                );
              },
              child: Text('Show history'),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
