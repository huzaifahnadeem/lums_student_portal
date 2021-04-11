import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/backend/validators.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';



// check android ios file and image picker configs


class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  // declaring state variables
  Post newPost = Post(subject: '', content: '');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>() ;
  final filePicker = FilePicker.platform;
  bool loading =  false ;

  // prompt user to select a picture from gallery
  void selectPicture() async{
    FilePickerResult? result = await filePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png']
    );
    // ignore: unnecessary_null_comparison
    if(result != null) {
      newPost.images = result.paths.map((path) => File(path!)).toList();
      setState(() {
        newPost.pictureChosen = true;
      });
    } else {
      setState(() {
        newPost.pictureChosen = false ;
        newPost.images = [];
      });
    }
  }

  // prompt the user to pick file from device
  void selectFile() async{
    FilePickerResult? result = await filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc']
    );
    // ignore: unnecessary_null_comparison
    if(result != null) {
       newPost.filename = (result.names[0]);
       newPost.file = File(result.paths[0]!);
       setState(() {
         newPost.fileChosen = true;
       });
    } else {
      setState(() {
        newPost.fileChosen = false ;
      });
    }
  }
  // upload picture when add post is selected

  // function to call when user pressed "Add Post" button
  void validate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      String result = await newPost.addObjectToDb();
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: <Widget>[
            Icon(
              Icons.done_all,
              color: Colors.white,
              semanticLabel: "Done",
            ),
            Text('  $result')
          ])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post", style: GoogleFonts.robotoSlab( textStyle: Theme.of(context).textTheme.headline6),),
      ),
      body: loading? LoadingScreen(): SafeArea(
        minimum: EdgeInsets.fromLTRB(30,10,30,30),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // heading input field
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(hintText: "Heading...", fillColor: Colors.white),
                    validator: (val) => headingValidator(newPost.subject),
                    onChanged: (val) {
                      setState(() => newPost.subject = val);
                    },
                  ),
                  SizedBox(height: 20),
                  // content input field
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(hintText: "Write your post here...", fillColor: Colors.white),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (val) => postValidator(newPost.content),
                    onChanged: (val) {
                      setState(() => newPost.content = val);
                    },
                  ),
                  SizedBox(height: 20),
                  // category input dropdown
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:  InputDecoration(hintText: "Select Category", fillColor: Colors.white),
                      validator: (val) => dropDownValidator(val),
                      isExpanded: false,
                      value: newPost.tag,
                      onChanged: (newVal) {setState(() {newPost.tag = newVal.toString() ;});},
                      items: Post.categories.map((categoryItem) {
                        return DropdownMenuItem(
                          value: categoryItem ,
                          child: Text(categoryItem),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // fill in poll options input fields
                  (newPost.isPoll && newPost.numOptions > 1 && newPost.options != null) ? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Text("Poll",  style: GoogleFonts.roboto( textStyle: Theme.of(context).textTheme.bodyText2,))),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: newPost.options!.asMap().entries.map((e) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0,10,0,10),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(hintText: "Option ${e.key} ", fillColor: Color(0xFFE8E8E8)),
                              validator: (val) => headingValidator(e.value['option']),
                              onChanged: (val) {
                                setState(() {
                                  e.value['option'] = val;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ): Container(),
                  SizedBox(height: 20),
                  // display picture if chosen
                  (newPost.isPoll && newPost.numOptions > 1 && newPost.options != null)? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(icon: new Icon(Icons.add_circle_outline, color: Color(0xFF48D1E3)), onPressed: () {
                        setState(() {
                          newPost.addOption();
                        });
                      }),
                      IconButton(icon: new Icon(Icons.remove_circle_outline, color: Colors.redAccent), onPressed: (){
                        setState(() {
                          newPost.removeOption();
                        });
                      })
                    ],
                  ): Container(),
                  newPost.pictureChosen? Column(
                      children:[
                        Align(alignment: Alignment.centerLeft,child: Text("Pictures",  style: Theme.of(context).textTheme.bodyText2,)),
                        SizedBox(height: 10,),
                        GridView.count(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: newPost.images.map((image) {
                              return Image.file(image,
                                fit: BoxFit.cover,
                              );
                            }).toList()
                        )
                      ]
                  ) : Container(),
                  SizedBox(height: 20),
                  // display file if chosen
                  newPost.fileChosen? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft ,child: Text("File",  style: Theme.of(context).textTheme.bodyText2,)),
                      SizedBox(height: 10),
                      Align(alignment:Alignment.centerLeft,child: Text(" ${newPost.filename}", style: Theme.of(context).textTheme.caption,)),
                    ],
                  )  : Container(),
                  SizedBox(height: 20),
                  // row of poll, picture and file upload buttons
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Photo",
                        icon: new Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF56BF54)),
                        onPressed: () => selectPicture(),
                      ),
                      Text("Photo", style: Theme.of(context).textTheme.caption),
                      SizedBox(width: 20),
                      IconButton(
                        tooltip: "Attachment",
                        icon: new Icon(Icons.attach_file_outlined, color: Color(0xFF1E64EC)),
                        onPressed:() => selectFile(),
                      ),
                      Text("Attachment", style: Theme.of(context).textTheme.caption),
                      SizedBox(width: 20),
                      IconButton(
                        tooltip: "Poll",
                        icon: new Icon(Icons.poll_outlined, color: Color(0xFFFFB800)),
                        onPressed: () {
                          setState(() {
                            newPost.isPoll = !newPost.isPoll ;
                            if(newPost.isPoll == false){
                              newPost.options = null;
                              newPost.numOptions = 0 ;
                              newPost.alreadyVoted = [];
                            }
                            else{
                              newPost.addOption();
                              newPost.addOption();
                            }
                          });
                        } ,
                      ),
                      Text("Poll", style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                  SizedBox(height: 20),
                  // submit button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Are you sure you want to add this post?" , style: GoogleFonts.roboto(textStyle:Theme.of(context).textTheme.bodyText2,)),
                              actions: [
                                TextButton(
                                  child: Text('Yes', style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.redAccent),),
                                  onPressed: () async {
                                    validate();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('No',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.redAccent),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Add Post',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )
        ),
      ),
    );
  }
}
