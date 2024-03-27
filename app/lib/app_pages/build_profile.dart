import 'package:firebase_database/firebase_database.dart';
import 'package:universal_io/io.dart';
import '../design_tools/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'base_screen.dart';

class BuildProfile extends StatefulWidget {
  final User user;
  const BuildProfile({Key? key, required this.user}) : super(key: key); // recieving also the User to connect between auth and the app
  @override
  State<BuildProfile> createState() => _BuildProfileState();
}

class _BuildProfileState extends State<BuildProfile> {
  TextEditingController _name = TextEditingController();
  TextEditingController _job = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  String imageUrl = '';
  @override
 Widget build(BuildContext context) {
  User currUser=widget.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("build profile"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "build your profile",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _name,
                hintText: " Full Name",
                isPasswordField: false,

              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _phoneNumber,
                hintText: " Phone Number",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _job,
                hintText: "Job",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _age,
                hintText: "age",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _location,
                hintText: "location",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 20,
              ),
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
                * Step 5. Display the image
                *
                * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library

                    //Get a reference to storage root
                    Reference referenceDirImages = FirebaseStorage.instance.ref().child('images/${DateTime.now().toIso8601String()}.jpg');

                      await referenceDirImages.putFile(File(file.path));
                      // await referenceImageToUpload.putFile(File("assets/meeting_outline.png"));
                      print("success loading");
                      //Success: get the download URL
                      
                      imageUrl = await referenceDirImages.getDownloadURL();
                      print(imageUrl);

            },// taking photo
            icon: const Icon(
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
                    //Install image_picker
                    //Import the corresponding library

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
                      
                      imageUrl = await referenceDirImages.getDownloadURL();
            },// taking photo
            icon: const Icon(
              Icons.photo_album
            ),
        ),]),
        const SizedBox(
        height: 40,
        ),
              GestureDetector(
                onTap:  (){
                  sleep2Sec().then((value) => 
                    setState(() {
                    UserData newuser = UserData(
                    name: _name.text,
                    job: _job.text,
                    age: int.parse(_age.text),
                    location: _location.text,
                    phoneNumber: _phoneNumber.text,
                    urlphoto: imageUrl,
                  );
                  _createData(newuser,currUser.uid); // create new user in firebase realtime
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => BaseScreen(userBase: currUser),
                  ),
                  );
                  })
                  );



                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                      child: Text(
                    "Save profile",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
  }




  void _createData(UserData userData,String? uid) { // create new user and adding it to FB RT
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    Map<String,dynamic> data = {
      "name": userData.name.toString(),
      "job": userData.job.toString(),
      "age":   userData.age.toInt(),
      "location": userData.location.toString(),
      "phoneNumber": userData.phoneNumber.toString(),
      "urlphoto": userData.urlphoto.toString(),
    };
    if(uid!=null)
    {
      dbRef.child("Users").child(uid).set(data).then((value) => null);
    }
    else{
      print("error null mail user auth!!!!");
    }
    
  }




  Future<UserData> getUserData(String uid) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    UserData userData = UserData(name: "unknown", job: "unknown", age: 0, location: "unknown", phoneNumber: "xxxxxxxxxxx" ,urlphoto: "" );

    DataSnapshot datasnap = await dbRef.child("Users").child(uid).get();
      
    if (datasnap.value is Map<dynamic, dynamic>) {
      userData = UserData.fromSnapshot(datasnap.value as Map<dynamic, dynamic>);
      return userData;
    }

      return userData;
}


  Future<void> setUserData(String uid , String job , String location , String name , String phoneNumber ,String urlphoto) async { // update user data
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    dbRef.child("Users").child(uid).child("job").set(job).then((value) => null);
    dbRef.child("Users").child(uid).child("name").set(name).then((value) => null);
    dbRef.child("Users").child(uid).child("location").set(location).then((value) => null);
    dbRef.child("Users").child(uid).child("phoneNumber").set(phoneNumber).then((value) => null);
    dbRef.child("Users").child(uid).child("urlphoto").set(urlphoto).then((value) => null);


  }

Future<void> sleep2Sec() async { // wait 2sec for saving the photo into the storage and getting back url to save it in the user information in FB RT
  await Future.delayed( const Duration(seconds: 2));
}

class UserData {
  final String name;
  final String job;
  final int age;
  final String location;
  final String phoneNumber;
  final String urlphoto;

  UserData({
    required this.name,
    required this.job,
    required this.age,
    required this.location,
    required this.phoneNumber,
    required this.urlphoto,
  });

  factory UserData.fromSnapshot(Map<dynamic, dynamic> data) { // snapshot from firebase RealTime to fetch specfic user
    // Access the 'value' property to get the map containing user data
    // Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    String urlCheck = data['urlphoto'] as String;
    if (urlCheck == '')
    {
      urlCheck = "https://as2.ftcdn.net/v2/jpg/02/29/75/83/1000_F_229758328_7x8jwCwjtBMmC6rgFzLFhZoEpLobB6L8.jpg"; // adding default profile photo if the user didn't chose one
    }
    return UserData(
      name: data['name'] as String,
      job: data['job'] as String,
      age: data['age'] as int,
      location: data['location'] as String,
      phoneNumber: data['phoneNumber'] as String,
      urlphoto: urlCheck,
    );
  }

}

