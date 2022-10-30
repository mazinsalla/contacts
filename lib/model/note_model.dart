import '../dbhelper/constant.dart';

class ContactModel{
    int? id;
    String name;
    String email;
    String phone;


    ContactModel({this.id, required this.name, required this.phone,required this.email});




  Map<String, dynamic> toMap(){
    return {
      columnName: name,
      columnPhone: phone,
      columnEmail:email
    };
  }


  //this func takes value and converts it to key ,value
   factory ContactModel.fromMap(Map<String, dynamic> map){ //factory used to return value from a named constructor
    return ContactModel(
      id: map[columnId],
      name: map[columnName],
      phone: map[columnPhone],
      email: map[columnEmail]
    );
  }


}