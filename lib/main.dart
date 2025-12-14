import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController copyController = TextEditingController();
  final TextEditingController pasteController = TextEditingController();
  final List<String> clipboardHistory = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: 450,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 EXISTING ROW (UNCHANGED)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type something',
                        ),
                        controller: copyController,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: copyController.text),
                        );
                        setState(() {
                          clipboardHistory.insert(0,copyController.text);
                        });
                      },
                      child: Text('Copy to Clipboard'),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // 🔹 NEW ROW: Paste field + button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: pasteController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pasted text will appear here',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final data =
                            await Clipboard.getData('text/plain');
                        setState(() {
                          pasteController.text = data?.text ?? '';
                        });
                      },
                      child: Text('Paste from clipboard'),
                    ),
                  ],
                ),
                SizedBox(height: 16),

Text(
  'Clipboard history',
  style: TextStyle(
    fontSize: 20,
    color: Colors.grey,
    fontWeight: FontWeight.w600,
  ),
),

SizedBox(height: 12),

SizedBox(
  height: 200,
  child: ListView.builder(
    itemCount: clipboardHistory.length,
    itemBuilder: (context, index) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          clipboardHistory[index],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
