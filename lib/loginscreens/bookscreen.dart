import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:myapp/list.dart' as vb;

class Bookscreen extends StatefulWidget {
  final int index;
  const Bookscreen({super.key, required this.index});

  @override
  State<Bookscreen> createState() => _BookscreenState();
}

class _BookscreenState extends State<Bookscreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final book = vb.book[widget.index];
    if (book == null || !book.containsKey("url")) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Book data is missing')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Color.fromARGB(255, 232, 173, 192),
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SfPdfViewer.network(
              book["url"],
              key: _pdfViewerKey,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  _isLoading = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                setState(() {
                  _isLoading = false;
                });
                // You can also show an error message if needed
              },
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
