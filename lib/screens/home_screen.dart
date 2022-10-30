
import 'package:flutter/material.dart';
import '../dbhelper/database_helper.dart';
import '../model/NameIcon.dart';
import '../model/note_model.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String phone = "";
  String email="";
  bool flag = false;

  List<ContactModel> contactList = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Contacts'),
        centerTitle: true,
      ),
      body: FutureBuilder( //snapshot has the values in the function
          future: getContactList(),
          builder: (context, snapshot) {
            return createListView(context, snapshot);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAlterDialog(null);
        },
        backgroundColor: Colors.brown,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    contactList = snapshot.data ?? [];

    if (contactList != []) {
      return ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  var db = DataBaseHelper();
                  db.deleteContact(contactList[index].id!);
                },
                background: Container(
                  color: Colors.red,
                ),
                child: buildItem(contactList[index], index));
          });
    } else {
      return Container();
    }
  }

  buildItem(ContactModel contactModel, int index) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.white60,
        child: ListTile(leading:CircleAvatar(child: NameIcon(firstName:contactModel.name.isNotEmpty? contactModel.name:"null"),radius: 30) ,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contactModel.name.toString(),
                  style: TextStyle(fontSize: 30),
                ),
                Text(contactModel.phone.toString(),
                    style: TextStyle(fontSize: 15)),
                Text(contactModel.email.toString(),
                    style: TextStyle(fontSize: 15))
              ],
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              openAlterDialog(contactModel);
            },
          ),
        ),
      ),
    );
  }

  openAlterDialog(ContactModel? contactModel) {
    if (contactModel != null) {
      name = contactModel.name;
      phone = contactModel.phone;
      email = contactModel.email;
      flag = true;

    } else {
      name = '';
      phone='';
      email='';
      flag = false;
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 300,
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(initialValue:name,validator:(value){
                      if (value!.isEmpty){
                        return"please enter a name";
                      }
                    },

                      onSaved: (value) {
                        name = value!;
                      },
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextFormField(validator:(value){
                      if (value!.isEmpty){
                        return"please enter a number";
                      }
                    },keyboardType: TextInputType.phone,
                      initialValue: phone.toString(),
                      onSaved: (value) {
                        phone= value!;
                      },
                      decoration: InputDecoration(hintText: 'Phone'),

                    ),TextFormField(validator: (value){
                      if (!(value!.contains("@"))){
                        return"invalid Email";
                      }
                    },
                initialValue: email,
                onSaved: (value) {
                  email= value!;
                },
                decoration: InputDecoration(hintText: 'Email')),


                    Container(
                      width: double.infinity,
                      child: ElevatedButton(style:ElevatedButton.styleFrom(primary: Colors.brown),
                          onPressed: () {
                            flag ? editNote(contactModel!.id) : addNote();
                          },
                          child: Text(flag ? 'Edit contact' : 'Add contact')),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<List<ContactModel>> getContactList() async {
    var db = DataBaseHelper();
    await db.getAllContact().then((value) {
      //getAll note returns future so u need .then to access its value and the list returned from getAllNote func is stored in value
      contactList = value;
    });
    return contactList;
  }

  void addNote() async {

   if(_formKey.currentState!.validate()){
     _formKey.currentState!.save();
    var db = DataBaseHelper();
    await db.insertContact(ContactModel(name:name, phone:phone,email: email)).then((value){
      print("/////////////");
      print(value);
      Navigator.of(context).pop();
      setState(() {
      });
    });
  }}

  editNote(int? id) async {


    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
    var db = DataBaseHelper();
      ContactModel contactModel = ContactModel(
        id: id,
        name: name,
        phone: phone,
        email: email,
      );
    await db.updateContact(contactModel).then((value){
      Navigator.of(context).pop(context);

      setState(() {
        flag=false;

      });
    });
  }}


}
