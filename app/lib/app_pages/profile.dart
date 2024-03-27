import 'package:first_flutter_proj/app_pages/build_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageUrl = '';
  bool isLoading = true;
  UserData userData = UserData(name: "unknown", job: "unknown", age: 0, location: "unknown", phoneNumber: "xxxxxxxxxxx" ,urlphoto: ""); // if profile not found
  late String tempName;
  late String tempPhoneNumber;
  late String tempJob;
  late String tempAddress;
  late String tempurlphoto;
  Map<String, bool> isEditing = {
    'Name': false,
    'Phone': false,
    'Address': false,
    'Job': false,
  };

  @override
  void initState() {
    super.initState();
    getUserDataStr(widget.user.uid);
  }

  void getUserDataStr(String uid) async { // fetching the user data from FB RT from the uid that got from firebase auth
    UserData userDatatemp = await getUserData(widget.user.uid);
    setState(() {
      userData = userDatatemp;
      isLoading = false;
      tempName = userData.name;
      tempPhoneNumber = userData.phoneNumber;
      tempJob = userData.job;
      tempAddress = userData.location;
      tempurlphoto = userData.urlphoto;
    });
  }

Widget itemProfile(String title, String initialValue, IconData iconData, Function(String) onSaved, {bool isEditable = true}) {
  TextEditingController _controller = TextEditingController(text: initialValue);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 3),
          color: Colors.deepOrange.withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 10
        )
      ]
    ),
    child: Row(
      children: [
        Icon(iconData, size: 24),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              isEditing[title] ?? false
                ? TextFormField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter $title',
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                        onSaved(value);
                        isEditing[title] = false;
                      });
                    },
                  )
                : GestureDetector(
                    onTap: () {
                      if (isEditable) {
                        setState(() {
                          isEditing[title] = true;
                        });
                      }
                    },
                    child: Text(
                      initialValue,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            ],
          ),
        ),
        SizedBox(width: 10),
        if (isEditable) IconButton(
          icon: Icon(isEditing[title] ?? false ? Icons.check : Icons.edit),
          onPressed: () {
            if (isEditing[title] ?? false) {
              setState(() {
                onSaved(_controller.text);
                isEditing[title] = false;
              });
            } else {
              setState(() {
                isEditing[title] = true;
              });
            }
          },
        ),
      ],
    ),
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 28),
            userData.urlphoto != null ?
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(tempurlphoto),
            ) : const SizedBox(height: 25),
                          Row(
              mainAxisAlignment: MainAxisAlignment.center, // This centers the icons in the Row
              children: [
              IconButton(onPressed: () async{
                    /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);

                    if (file == null) return;
                    
                    //Import dart:core
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    print(uniqueFileName);
                    /*Step 2: Upload to Firebase storage*/

                    //Get a reference to storage root
                    Reference referenceDirImages = FirebaseStorage.instance.ref().child('images/${DateTime.now().toIso8601String()}.jpg');


                      await referenceDirImages.putFile(File(file.path));
                      // await referenceImageToUpload.putFile(File("assets/meeting_outline.png"));
                      print("success loading");
                      //Success: get the download URL
                      
                      imageUrl = await referenceDirImages.getDownloadURL().then((value) => tempurlphoto = value);
                      print(imageUrl);

            },// taking photo
            icon: Icon(
              Icons.add_a_photo
            ),
        ),
            IconButton(onPressed: () async{
                    /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                    /*Step 1:Pick image*/

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.gallery);
                    print('${file?.path}');
                    print("chossing imageee");

                    if (file == null) return;

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library

                    //Get a reference to storage root
                    Reference referenceDirImages = FirebaseStorage.instance.ref().child('images/${DateTime.now().toIso8601String()}.jpg');


                      await referenceDirImages.putFile(File(file.path));
                      // await referenceImageToUpload.putFile(File("assets/meeting_outline.png"));

                      //Success: get the download URL
                      
                      imageUrl = await referenceDirImages.getDownloadURL().then((value) => tempurlphoto = value);


            },// taking photo
            icon: Icon(
              Icons.photo_album
            ),
        ),]),
            itemProfile(
              'Name',
              tempName,
              CupertinoIcons.person,
              (newValue) {
                setState(() {
                  tempName = newValue;
                });
              }
            ),
            const SizedBox(height: 4),
            itemProfile(
              'Phone',
              tempPhoneNumber,
              CupertinoIcons.phone,
              (newValue) {
                setState(() {
                  tempPhoneNumber = newValue;
                });
              }
            ),
            const SizedBox(height: 4),
            itemProfile(
              'Address',
              tempAddress,
              CupertinoIcons.location,
              (newValue) {
                setState(() {
                  tempAddress = newValue;
                });
              }
            ),
            const SizedBox(height: 4),
            itemProfile(
              'Job',
              tempJob,
              CupertinoIcons.settings,
              (newValue) {
                setState(() {
                  tempJob = newValue;
                });
              }
            ),
            const SizedBox(height: 4),
            // Assuming email is not editable
            itemProfile(
            'Email',
            widget.user.email.toString(),
            CupertinoIcons.mail,
            (_) {}, // Empty function since it's not editable
            isEditable: false, // Email is not editable
          ),
          const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                      setUserData(widget.user.uid, tempJob, tempAddress, tempName, tempPhoneNumber, tempurlphoto); // update user data on press
                  });
                  // Save the updated userData to your backend or local storage
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ), 
    );
  }
}
