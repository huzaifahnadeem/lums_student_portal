import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lums_student_portal/backend/validators.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';


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
      imageReset = true ;
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
        widget.post.pictureChosen = true;
      });
    } else {
      setState(() {
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
        title: Text("Update Post"),
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
                    child: DropdownButton(
                      //decoration:  InputDecoration(hintText: "Select Category"),
                      hint: Text("Category"),
                      isExpanded: false,
                      value: widget.post.tag,
                      focusColor: Colors.red,
                      dropdownColor: Colors.red,
                      onChanged: (newVal) {
                        setState(() {
                          widget.post.tag = newVal.toString() ;
                        });
                      },
                      items: Post.categories.map((categoryItem) {
                        return DropdownMenuItem(
                          value: categoryItem ,
                          child: Text(categoryItem),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // number of poll options input drop down
                  widget.post.isPoll? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: Text("Poll",)),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        decoration:  InputDecoration(hintText: "Select number of options for your poll"),
                        isExpanded: true,
                        value: widget.post.numOptions,
                        onChanged: (newVal) {
                          setState(() {
                            widget.post.numOptions = int.parse(newVal.toString()) ;
                            widget.post.addOptions();
                          });
                        },
                        items: widget.post.chooseNumOptions.map((num) {
                          return DropdownMenuItem(
                            value: num ,
                            child: Text(num.toString() + " Options"),
                          );
                        }).toList(),
                      ),
                    ],
                  ) : Container() ,
                  // fill in poll options input fields
                  (widget.post.isPoll && widget.post.numOptions > 1 && widget.post.options != null)? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.post.options!.map((e) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0,10,0,10),
                        child: TextFormField(
                          initialValue: e['option'],
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
                  (widget.post.fileChosen && fileReset) ? Column(
                    children: [
                      Align(alignment: Alignment.centerLeft ,child: Text("Files",  style: Theme.of(context).textTheme.bodyText2,)),
                      SizedBox(height: 10),
                      Text(" ${widget.post.filename}"),
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
                            widget.post.isPoll = !widget.post.isPoll ;
                            widget.post.numOptions = 2 ;
                            if(widget.post.isPoll == false){
                              widget.post.options = null;
                              widget.post.numOptions = 1 ;
                              widget.post.alreadyVoted = [];
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
                      onPressed: () => validate(),
                      child: Text('Update Post',
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
