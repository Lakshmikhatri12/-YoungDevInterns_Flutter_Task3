import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:myapp/loginscreens/aboutbook.dart';
import 'package:myapp/pdfviewer.dart'; // Ensure you have this file
import 'package:myapp/list.dart' as vb;

class UploadPdfScreen extends StatefulWidget {
  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadFile(File file) async {
    if (file == null) {
      print("No file was picked");
      return;
    }

    try {
      // Create a Reference to the file
      Reference ref =
          storage.ref().child('books').child(file.uri.pathSegments.last);

      final metadata = SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {'picked-file-path': file.path},
      );

      print("Uploading...");

      // Upload file
      UploadTask uploadTask = ref.putFile(file, metadata);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save file metadata to Firestore
      await firestore.collection('pdfs').add({
        'name': file.uri.pathSegments.last,
        'url': downloadUrl,
      });

      print("Upload done!");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('File uploaded successfully')));
      Navigator.pop(context);
    } catch (e) {
      print('Error uploading file: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('File upload failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? path = await FlutterDocumentPicker.openDocument();
          if (path != null) {
            File file = File(path);
            await uploadFile(file);
          } else {
            print('No file selected');
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Upload PDF'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "featured Books",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('pdfs').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "Your upload section is empty",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      );
                    }

                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    if (docs.isEmpty) {
                      return Container(
                        height: 200,
                        child: Center(
                          child: Text(
                            "upload books here",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/f1.jpeg"))),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  mainAxisExtent: 250),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data =
                                docs[index].data() as Map<String, dynamic>;
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewerScreen(pdfUrl: data['url']),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image:
                                                AssetImage("assets/pdf.png")),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(data['name']),
                                ],
                              ),
                            );
                          }),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Popular Books",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 280,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                        itemCount: vb.book.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Aboutbook(
                                                index: index,
                                              )));
                                },
                                child: Container(
                                  width: 250,
                                  height: 320,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              vb.book[index]["cover"]))),
                                ),
                              ),
                            ),
                          );
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
