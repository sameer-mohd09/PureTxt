import 'package:flutter/material.dart';
import '../utils/text_cleaner.dart';
import '../utils/text_splitter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class EditorScreen extends StatefulWidget {
  final String originalText;
  final String fileName;

  const EditorScreen({
    Key? key,
    required this.originalText,
    required this.fileName,
  }) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _controller;
  String splitMode = 'None';
  int splitValue = 100;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.originalText);
  }

  void applyCleaning(Function(String) cleanFunc) {
    String cleaned = cleanFunc(_controller.text);
    setState(() {
      _controller.text = cleaned;
    });
  }

  // Function to split the text and save files
  void splitText() {
    List<String> parts;
    // Split based on selected mode
    if (splitMode == 'Lines') {
      parts = TextSplitter.splitByLines(_controller.text, splitValue);
    } else if (splitMode == 'Characters') {
      parts = TextSplitter.splitByCharacters(_controller.text, splitValue);
    } else {
      parts = [_controller.text];  // If no split, keep the text as one part
    }

    _saveSplitFiles(parts);
  }

  // Function to save split files on the device
  Future<void> _saveSplitFiles(List<String> parts) async {
    // Get external storage directory
    final directory = await getExternalStorageDirectory();
    final baseName = widget.fileName.split('.').first;  // Get file name without extension

    if (directory == null) {
      // If directory is null, show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to access storage directory.')),
      );
      return;
    }

    for (int i = 0; i < parts.length; i++) {
      // Create new file with part number appended
      final file = File('${directory.path}/${baseName}_part${i + 1}.txt');
      await file.writeAsString(parts[i]);  // Write split content into file
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Files saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit / Clean / Split'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: splitText,
            tooltip: 'Split and Save',
          ),
        ],
      ),
      body: Column(
        children: [
          // === Cleaning Buttons ===
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _cleanButton('Whitespace', TextCleaner.removeExtraSpaces),
                _cleanButton('Blank Lines', TextCleaner.removeBlankLines),
                _cleanButton('Timestamps', TextCleaner.removeTimestamps),
                _cleanButton('Special Chars', TextCleaner.removeSpecialCharacters),
                _cleanButton('Lowercase', TextCleaner.convertToLowerCase),
              ],
            ),
          ),

          // === Editable Text Field ===
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontFamily: 'monospace'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Edit cleaned text here...',
                ),
              ),
            ),
          ),

          // === Splitting Options ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                const Text("Split by: "),
                DropdownButton<String>(
                  value: splitMode,
                  items: const [
                    DropdownMenuItem(value: 'None', child: Text('None')),
                    DropdownMenuItem(value: 'Lines', child: Text('Lines')),
                    DropdownMenuItem(value: 'Characters', child: Text('Characters')),
                  ],
                  onChanged: (val) => setState(() => splitMode = val!),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'Value'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() => splitValue = int.tryParse(val) ?? 100);
                    },
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Split & Save'),
                  onPressed: splitText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cleanButton(String label, Function(String) func) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => applyCleaning(func),
        child: Text(label),
      ),
    );
  }
}
