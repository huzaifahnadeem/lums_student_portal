import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
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
  final imagePicker = ImagePicker();
  final filePicker = FilePicker.platform;
  bool loading =  false ;

  // prompt user to select a picture from gallery
  void selectPicture() async{
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null){
      newPost.image = File(pickedFile.path);
      setState(() {
        newPost.pictureChosen = true;
      });
    }
    else{
      setState(() {
        newPost.pictureChosen = false;
      });
    }
  }

  // prompt the user to pick file from device
  void selectFile() async{
    FilePickerResult? result = await filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc']
    );

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
      await newPost.addObjectToDb();
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
            Text('  Done')
          ])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
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
                    decoration: InputDecoration(labelText: "Heading...", fillColor: Colors.white),
                    validator: (val) => headingValidator(newPost.subject),
                    onChanged: (val) {
                      setState(() => newPost.subject = val);
                    },
                  ),
                  SizedBox(height: 20),
                  // content input field
                  TextFormField(
                    decoration: InputDecoration(labelText: "Write your post here...", fillColor: Colors.white),
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
                    child: DropdownButton(
                      //decoration:  InputDecoration(hintText: "Select Category"),
                      hint: Text("Category"),
                      isExpanded: false,
                      value: newPost.tag,
                      focusColor: Colors.red,
                      dropdownColor: Colors.red,
                      onChanged: (newVal) {
                        setState(() {
                          newPost.tag = newVal.toString() ;
                        });
                      },
                      items: newPost.categories.map((categoryItem) {
                        return DropdownMenuItem(
                          value: categoryItem ,
                          child: Text(categoryItem),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // number of poll options input drop down
                  newPost.isPoll? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: Text("Poll",)),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        decoration:  InputDecoration(hintText: "Select number of options for your poll"),
                        isExpanded: true,
                        value: newPost.numOptions,
                        onChanged: (newVal) {
                          setState(() {
                            newPost.numOptions = int.parse(newVal.toString()) ;
                            newPost.addOptions();
                          });
                        },
                        items: newPost.chooseNumOptions.map((num) {
                          return DropdownMenuItem(
                            value: num ,
                            child: Text(num.toString() + " Options"),
                          );
                        }).toList(),
                      ),
                    ],
                  ) : Container() ,
                  // fill in poll options input fields
                  newPost.numOptions != 0 ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: newPost.options.map((e) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0,10,0,10),
                        child: TextFormField(
                          decoration: InputDecoration(),
                          validator: (val) => headingValidator(e['option']),
                          onChanged: (val) {
                            setState(() {
                              e['option'] = val;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ): Container(),
                  SizedBox(height: 20),
                  // display picture if chosen
                  newPost.pictureChosen? Column(
                      children:[
                        Align(alignment: Alignment.centerLeft,child: Text("Pictures",  style: Theme.of(context).textTheme.bodyText2,)),
                        SizedBox(height: 10,),
                        GestureDetector(
                          child: Image.file(newPost.image!),
                        )
                      ]
                  ) : Container(),
                  SizedBox(height: 20),
                  // display file if chosen
                  newPost.fileChosen? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft ,child: Text("Files",  style: Theme.of(context).textTheme.bodyText2,)),
                      SizedBox(height: 10),
                      Text(" ${newPost.filename}"),
                    ],
                  )  : Container(),
                  SizedBox(height: 20),
                  // row of poll, picture and file upload buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        tooltip: "Photo",
                        icon: new Icon(Icons.add_photo_alternate_outlined),
                        onPressed: () => selectPicture(),
                      ),
                      Text("Photo", style: Theme.of(context).textTheme.caption),
                      IconButton(
                        tooltip: "Attachment",
                        icon: new Icon(Icons.attach_file_outlined),
                        onPressed:() => selectFile(),
                      ),
                      Text("Attachment", style: Theme.of(context).textTheme.caption),
                      IconButton(
                        icon: new Icon(Icons.poll_outlined),
                        onPressed: () {
                          setState(() {
                            newPost.isPoll = !newPost.isPoll ;
                            newPost.numOptions = 0 ;
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
                      onPressed: () => validate(),
                      child: Text('Add Post',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
