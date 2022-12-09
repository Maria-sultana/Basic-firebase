import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:student_app/add_course.dart';

class UpdateCourse extends StatefulWidget {
  String documentId;
  String coursename;
  String coursefee;
  String img;
  String section;

  UpdateCourse(this.documentId, this.coursefee, this.coursename, this.img,this.section);

  @override
  State<UpdateCourse> createState() => UpdateCourseState();
}

class UpdateCourseState extends State<UpdateCourse> {
  TextEditingController _addcourse = TextEditingController();
  TextEditingController _addfee = TextEditingController();
   TextEditingController section = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addcourse.text = widget.coursename;
    _addfee.text = widget.coursefee;
    section.text = widget.section;
  }

  XFile? _CourseImage;
  late String _imgUrl;

  choseImageFromCg() async {
    ImagePicker picker = ImagePicker();
    _CourseImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  sendData(SelectedDocument) async {
    if(_CourseImage==null){
      CollectionReference _course =
        await FirebaseFirestore.instance.collection("course");
    _course.add(({
      "_coursename": _addcourse.text,
      "_coursefee": _addfee.text,
      "image":widget.img,
      "section":section.text,
    }));
    }
    else{
      File ImageFile = File(_CourseImage!.path);
    FirebaseStorage _storage = FirebaseStorage.instance;
    UploadTask _uploadtask =
        _storage.ref("course").child(_CourseImage!.name).putFile(ImageFile);
    TaskSnapshot _snapshot = await _uploadtask;
    _imgUrl = await _snapshot.ref.getDownloadURL();
    CollectionReference _course =
        await FirebaseFirestore.instance.collection("course");
    _course.add(({
      "_coursename": _addcourse.text,
      "_coursefee": _addfee.text,
      "image": _imgUrl,
      "section":section.text,
    }));
  }

    }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
                controller: _addcourse,
                decoration: InputDecoration(
                  hintText: "Add Course",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                )),
            SizedBox(
              height: 8,
            ),
            TextField(
                controller: _addfee,
                decoration: InputDecoration(
                  hintText: "Pay Time",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                )),
            SizedBox(
              height: 8,
            ),
             TextField(
                controller: section,
                decoration: InputDecoration(
                  hintText: "Inform Your Section",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                )),
            SizedBox(
              height: 8,),            Expanded(
                child: _CourseImage == null
                    ? Stack(
                        children: [
                          Image.network(
                            widget.img,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                              child: CircleAvatar(
                            child: IconButton(
                                onPressed: (() {
                                  choseImageFromCg();
                                }),
                                icon: Icon(Icons.camera)),
                          ))
                        ],
                      )
                    : Image.file(File(_CourseImage!.path))),
            ElevatedButton(
                onPressed: () {
                  sendData(widget.documentId);
                },
                child: Text("Rolling with Courses"))
          ],
        ),
      ),
    );
  }
}
