import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final List historyList;

  HistoryScreen({this.historyList});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('History List:');
    print(widget.historyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.history),
          title: Text("History"),
        ),
        body: ListView(
          children: [
            SizedBox(height: 15,),
            ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.historyList.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.redAccent,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PDF  NAME: ${widget.historyList[index]['pdfName']}',style: TextStyle(fontSize: 16),),
                        Text('READ TIME: ${widget.historyList[index]['readTime']}',style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  );
                })
          ],
        ));
  }
}
