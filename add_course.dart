import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Add_course extends StatefulWidget {
  const Add_course({super.key});

  @override
  State<Add_course> createState() => _Add_courseState();
}

class _Add_courseState extends State<Add_course> {
  TextEditingController _addcourse = TextEditingController();
  TextEditingController _addfee = TextEditingController();
  TextEditingController section = TextEditingController();

  XFile? _CourseImage;
  late String _imgUrl;

  choseImageFromCg() async {
    ImagePicker picker = ImagePicker();
    _CourseImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {});}
     sendData() async {
      File ImageFile = File(_CourseImage!.path);
      FirebaseStorage _storage = FirebaseStorage.instance;
      UploadTask _uploadtask = _storage
          .ref("course")
          .child(_CourseImage!.name)
          .putFile(ImageFile);
      TaskSnapshot _snapshot = await _uploadtask;
      _imgUrl = await _snapshot.ref.getDownloadURL();
      CollectionReference _course =
          await FirebaseFirestore.instance.collection("course");
      _course.add(({
        "_coursename": _addcourse.text,
        "_coursefee": _addfee.text,
        "image": _imgUrl,
        "section":section.text,
      }
      ));
    }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(10.0)),
        color: Colors.lightGreen,
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
                controller: _addcourse,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                   hintText: "Add Course",
                  border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10.0),
                      ),

                )),
            SizedBox(
              height: 8,
            ),
            TextField(
                controller: _addfee,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Pay time",
                  border: OutlineInputBorder(
                       
                      borderRadius: BorderRadius.circular(10.0),
                      ),
                )),
            SizedBox(
              height: 8,),
              TextField(
                controller: section,
                decoration: InputDecoration(
                  fillColor: Colors.pinkAccent,
                  hintText: "Inform Your Section",
                  border: OutlineInputBorder(
                       
                      borderRadius: BorderRadius.circular(10.0),
                      ),
                )),
            SizedBox(
              height: 8,),
            Expanded(
                child: _CourseImage == null
                    ? IconButton(
                        icon: Icon(Icons.browse_gallery),
                        onPressed: () {
                          choseImageFromCg();
                        },
                        
                      )
                    : Image.file(File(_CourseImage!.path))),
            ElevatedButton(onPressed: () {
              sendData();
            }, 
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        primary: Colors.lime),
                        
                    child: Text(
                      "ADD COURSE",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      
            ),
         )
          ],
        ),
      ),
    );
  }}