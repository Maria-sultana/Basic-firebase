import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_app/add_course.dart';
import 'package:student_app/update.dart';

class View_Course extends StatefulWidget {
  const View_Course({super.key});

  @override
  State<View_Course> createState() => _View_CourseState();
}

class _View_CourseState extends State<View_Course> {
  addnewCourse() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black38,
        isDismissible: true,
        isScrollControlled: true,
        builder: ((context) => Add_course()));
  }

  UpdatenewCourse(documentId, coursename, coursefee, img,section) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black87,
        isDismissible: true,
        isScrollControlled: true,
        builder: ((context) =>
            UpdateCourse(documentId, coursename, coursefee, img,section)));
  }

  Future<void> deleteCourse(SelectedDocumentId) async {
    return FirebaseFirestore.instance
        .collection("course")
        .doc(SelectedDocumentId)
        .delete()
        .then((value) => print("data is deleted"));
  }

  Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection("course").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text("View Course"),
        centerTitle: true,
        actions: [
         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.menu,color: Colors.black,),
          ),
          
        ],
      ),
    
    floatingActionButton:
    FloatingActionButton(
      
      onPressed: () {
        addnewCourse();
      },
      child: Icon(Icons.add),backgroundColor: Colors.amber,
    ),
    body:
    
    
    
    StreamBuilder(
      
      stream: _courseStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something Wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs.map(
            (DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Container(
                height: 350,
                child: Card(
                  elevation: 5,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Image.network(
                            data["image"],
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Container(
                           
                            child: Text('${data["_coursename"]}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.5),
                             
                            ),
                          ),
                          Container(
                           
                            child: Text('${data["_coursefee"]}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16)),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.5),
                             
                            ),
                      
                          ),
                           Container(
                           
                            child: Text('${data["section"]}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.5),
                             
                            ),
                       

                          ),
                        ],
                      ),
                      Positioned(
                          child: Container(
                        height: 50,
                        width: 140,
                        child: Card(
                            elevation: 5,
                            child: Row(
                              children: [
                                IconButton(
                                
                                    onPressed: ((
                                    
                                    ) {
                                       UpdatenewCourse(
                                          document.id,
                                          data["_coursename"],
                                          data["coursefee"],
                                          data["Img"],
                                          data["section"]);
                                    }
                                     ),
                                  
                                    icon: Icon(Icons.edit,color: Colors.black,)),
                                IconButton(
                                    onPressed: (() {
                                      deleteCourse(document.id);
                                    }),
                                    
                                    icon: Icon(Icons.remove_circle))
                              ],
                            )),
                      ))
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    )
    );
  }
}
