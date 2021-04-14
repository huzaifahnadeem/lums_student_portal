import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/validators.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';


// check android ios file and image picker configs


class UpdatePost extends StatefulWidget {
  final Post post ;
  UpdatePost({required this.post, Key? key}): super(key: key);
  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {

  // declaring state variables
  GlobalKey<FormState> _formKey = GlobalKey<FormState>() ;
  final filePicker = FilePicker.platform;
  bool loading =  false ;
  bool imageReset = false;
  bool fileReset = false;

  // prompt user to select a picture from gallery
  void selectPicture() async{
    if (imageReset == false){
      print("About to delete pictures");
      bool result = await widget.post.deletePicture();
      widget.post.pictureURL = [] ;
    }
    FilePickerResult? result = await filePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png']
    );
    // ignore: unnecessary_null_comparison
    if(result != null) {
      widget.post.images = result.paths.map((path) => File(path!)).toList();
      setState(() {
        imageReset = true ;
        widget.post.pictureChosen = true;
      });
    } else {
      setState(() {
        imageReset = true ;
        widget.post.pictureChosen = false ;
        widget.post.images = [];
      });
    }
  }

  // prompt the user to pick file from device
  void selectFile() async{
    if (fileReset == false){
      fileReset = true;
      bool result = await widget.post.deleteFile();
      widget.post.filename = null ;
      widget.post.fileURL = null ;
    }
    FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc']
    );

    if(result != null) {
      widget.post.filename = (result.names[0]);
      widget.post.file = File(result.paths[0]!);
      setState(() {
        widget.post.fileChosen = true;
      });
    } else {
      setState(() {
        widget.post.fileChosen = false ;
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
      String result = await widget.post.updateObjectToDb(fileReset,imageReset);
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
        title: Text("Update Post", style: GoogleFonts.robotoSlab( textStyle: Theme.of(context).textTheme.headline6),),
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
                    initialValue: widget.post.subject,
                    decoration: InputDecoration(labelText: "Heading...", fillColor: Colors.white),
                    validator: (val) => headingValidator(widget.post.subject),
                    onChanged: (val) {
                      setState(() => widget.post.subject = val);
                    },
                  ),
                  SizedBox(height: 20),
                  // content input field
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: widget.post.content,
                    decoration: InputDecoration(labelText: "Write your post here...", fillColor: Colors.white),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (val) => postValidator(widget.post.content),
                    onChanged: (val) {
                      setState(() => widget.post.content = val);
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
                      value: widget.post.tag,
                      onChanged: (newVal) {setState(() {widget.post.tag = newVal.toString() ;});},
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
                  (widget.post.isPoll && widget.post.numOptions > 1 && widget.post.options != null)? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Text("Poll",  style: Theme.of(context).textTheme.bodyText2,)),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: widget.post.pollQuestion,
                        decoration: InputDecoration(hintText: "Poll Question", fillColor: Colors.white),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (val) => emptyNullValidator(widget.post.pollQuestion),
                        onChanged: (val) {
                          setState(() => widget.post.pollQuestion = val);
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: widget.post.options!.asMap().entries.map((e) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0,10,0,10),
                            child: TextFormField(
                              initialValue: e.value['option'],
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
                  (widget.post.isPoll && widget.post.numOptions > 1 && widget.post.options != null)? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(icon: new Icon(Icons.add_circle_outline, color: Color(0xFF48D1E3)), onPressed: () {
                        setState(() {
                          widget.post.addOption();
                        });
                      }),
                      IconButton(icon: new Icon(Icons.remove_circle_outline, color: Colors.redAccent), onPressed: (){
                        setState(() {
                          widget.post.removeOption();
                        });
                      })
                    ],
                  ): Container(),
                  SizedBox(height: 20),
                  // display picture if chosen
                  (widget.post.pictureChosen && imageReset) ? Column(
                      children:[
                        Align(alignment: Alignment.centerLeft,child: Text("Pictures",  style: Theme.of(context).textTheme.bodyText2,)),
                        SizedBox(height: 10,),
                        GridView.count(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: widget.post.images.map((image) {
                              return Image.file(image,
                                fit: BoxFit.cover,
                              );
                            }).toList()
                        )
                      ]
                  ) : Container(),
                  (widget.post.pictureChosen && imageReset == false) ? Column(
                      children:[
                        Align(alignment: Alignment.centerLeft,child: Text("Pictures",  style: Theme.of(context).textTheme.bodyText2,)),
                        SizedBox(height: 10,),
                        GridView.count(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: widget.post.pictureURL.map((url) {
                              return Image.network(url,
                                fit: BoxFit.cover,
                              );
                            }).toList()
                        )
                      ]
                  ) : Container(),
                  SizedBox(height: 20),
                  // display file if chosen
                  (widget.post.fileChosen) ? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft ,child: Text("Files",  style: Theme.of(context).textTheme.bodyText2,)),
                      SizedBox(height: 10),
                      Align(alignment:Alignment.centerLeft,child: Text(" ${widget.post.filename}", style: Theme.of(context).textTheme.caption,)),
                    ],
                  )  : Container(),
                  SizedBox(height: 20),
                  // row of poll, picture and file upload buttons
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Photo",
                        icon: new Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF56BF54)),
                        onPressed: () async{
                          if(imageReset){
                          selectPicture();
                          }
                          else if(!imageReset && !widget.post.pictureChosen){
                          selectPicture();
                          }
                          else {
                            return showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Caution",
                                      style: GoogleFonts.roboto(textStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6,)),
                                  content: Text(
                                      "Selecting a new picture will delete previously posted images. Are you sure you want to delete the previous images from your post?",
                                      style: GoogleFonts.roboto(textStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2,)),
                                  actions: [
                                    TextButton(
                                      child: Text('Yes', style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(color: Colors.redAccent),),
                                      onPressed: () async {
                                        selectPicture();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('No', style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(color: Colors.redAccent),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                      Text("Photo", style: Theme.of(context).textTheme.caption),
                      SizedBox(width: 20),
                      IconButton(
                        tooltip: "Attachment",
                        icon: new Icon(Icons.attach_file_outlined, color: Color(0xFF1E64EC)),
                        onPressed: () async{
                          if(fileReset){
                            selectFile();
                          }
                          else if(!fileReset && !widget.post.fileChosen){
                            selectFile();
                          }
                          else{
                            return showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Caution" , style: GoogleFonts.roboto(textStyle:Theme.of(context).textTheme.headline6,)),
                                  content: Text("Selecting a new file will delete previously posted file. Are you sure you want to delete the previous file from your post?" , style: GoogleFonts.roboto(textStyle:Theme.of(context).textTheme.bodyText2,)),
                                  actions: [
                                    TextButton(
                                      child: Text('Yes', style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.redAccent),),
                                      onPressed: () async {
                                        selectFile();
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
                          }
                        },
                      ),
                      Text("Attachment", style: Theme.of(context).textTheme.caption),
                      SizedBox(width: 20),
                      IconButton(
                        tooltip: "Poll",
                        icon: new Icon(Icons.poll_outlined, color: Color(0xFFFFB800)),
                        onPressed: () {
                          setState(() {
                            widget.post.isPoll = !widget.post.isPoll ;
                            if(widget.post.isPoll == false){
                              widget.post.options = null;
                              widget.post.numOptions = 0 ;
                              widget.post.pollQuestion = null;
                              widget.post.alreadyVoted = [];
                            }
                            else{
                              widget.post.addOption();
                              widget.post.addOption();
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
                      onPressed: () async{
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Are you sure you want to update this post? This action can not be undone." , style: GoogleFonts.roboto(textStyle:Theme.of(context).textTheme.bodyText2,)),
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
                      child: Text('Update Post',
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
