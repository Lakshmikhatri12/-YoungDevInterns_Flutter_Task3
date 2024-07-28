import 'package:flutter/material.dart';
import 'package:myapp/list.dart' as vb;
import 'package:myapp/loginscreens/bookscreen.dart';

class Aboutbook extends StatefulWidget {
  final int index;
  const Aboutbook({super.key, required this.index});

  @override
  State<Aboutbook> createState() => _AboutbookState();
}

class _AboutbookState extends State<Aboutbook> {
  @override
  Widget build(BuildContext context) {
    final book = vb.book[widget.index];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("About"),
          backgroundColor: Color.fromARGB(255, 236, 212, 220),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/img/bg3.jpg"))),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.43,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(book["cover"]))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      book["title"],
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      book["author"],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 129, 127, 127)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Container(
                        child: Text(
                          book["about"],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromARGB(255, 31, 31, 31)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 132, 159),
                            borderRadius: BorderRadius.circular(50)),
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.book,
                                color: Colors.white,
                              ),
                              Text(
                                "Read Book",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Bookscreen(index: widget.index)));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
