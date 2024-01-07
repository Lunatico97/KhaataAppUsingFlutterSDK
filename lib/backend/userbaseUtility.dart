
// Author: Diwas Adhikari
// Firebase Access and CRUD Stuff - Userbase Utility

import "package:cloud_firestore/cloud_firestore.dart" ;
import 'package:khaata_app/backend/authentication.dart';
import '../models/structure.dart';

class Userbase{
  final _database = FirebaseFirestore.instance ;
  String collectionPath = "user-data" ; // Don't mess with this as well - HAHAHA !
  String currentDocumentID = "" ;

  // Create a new user and store it in the cloud (C)
  createNewUser(UserData user) async {
      await _database.collection(collectionPath).add(user.toJSON())
          .whenComplete((){
              // do smth
          })
          .catchError((error){
              print("Error: + $error") ;
          }) ;
  }

  // Get a list of users from the cloud whose certain field value is certain - HAHAHA ! (R)
  Future<UserData> getUserDetails(String fieldType, String value) async{
    final snapShot = await _database.collection(collectionPath).where(fieldType, isEqualTo: value).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).single ;
    return data ;
  }

  // Get a bunch of user from the cloud that satisfy the where clause - HAHAHA ! (R)
  Future<List<UserData>> getBunchOfUsers(String fieldType, String value) async{
    final snapShot = await _database.collection(collectionPath).where(fieldType, isEqualTo: value).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }

  // SAME RETREIVAL STUFF FOR ARRAYS
  // Get a specific user from the cloud stored in a list whose certain field value is certain - HAHAHA ! (R)
  Future<UserData> getUserDataWithinList(String fieldType, List<dynamic> values) async{
    final snapShot = await _database.collection(collectionPath).where(fieldType, arrayContains: values).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).single ;
    return data ;
  }

  // Get a list of users from the cloud whose certain field value is certain - HAHAHA ! (R)
  Future<List<UserData>> getBunchOfUsersWithinList(String arrayType, List<dynamic> values) async{
    final snapShot = await _database.collection(collectionPath).where(arrayType, arrayContains: values).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }

  // This is the best hack to create a somewhat LIKE query in Firestore. (Diwas - Its query system sucks !)
  Future<List<UserData>> getBunchOfUsersSimilar(String fieldType, String value) async{
    final snapShot = await _database.collection(collectionPath).orderBy(fieldType)
                                    .startAt(['$value']).endAt(['$value\uf8ff']).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }

  Future<List<UserData>> getAllUserData() async{
    final snapShot = await _database.collection(collectionPath).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }

  // Update a particular detail for only the current user (U)
  // for string updates - I miss C++ and its templates - Huhuhu {Diwas}
  updateCurrentUserDetail(String updateFieldType, String newValue) async{
    String? reqID = Authentication().currentUser?.uid ;
    final snapShot = await _database.collection(collectionPath).where("id", isEqualTo: reqID).get() ;
    final data = snapShot.docs.single ;
    // The id used here is strictly document id but, not regular or authentication uid.
    // WARNING {Diwas - Sensitive !}
    await _database.collection(collectionPath).doc(data.id).update({updateFieldType: newValue}).then((value){
      print("Updated $updateFieldType successfully! ") ;
    })
    .catchError((error){
      print(error) ;
    });
  }

  // for integer updates
  updateCurrentUserValue(String updateFieldType, int newValue) async{
    String? reqID = Authentication().currentUser?.uid ;
    final snapShot = await _database.collection(collectionPath).where("id", isEqualTo: reqID).get() ;
    final data = snapShot.docs.single ;
    // The id used here is strictly document id but, not regular or authentication uid.
    // WARNING {Diwas - Sensitive !}
    await _database.collection(collectionPath).doc(data.id).update({updateFieldType: newValue}).then((value){
      print("Updated $updateFieldType successfully! ") ;
    })
        .catchError((error){
      print(error) ;
    });
  }

  updateUserListData(String updateFieldType, String newValue) async{
    var list = [newValue] ;
    String? reqID = Authentication().currentUser?.uid ;
    var snapShot = await _database.collection(collectionPath).where("id", isEqualTo: reqID).get() ;
    var data = snapShot.docs.single ;
    // The id used here is strictly document id but, not regular or authentication uid.
    // WARNING {Diwas - Sensitive !}
    await _database.collection(collectionPath).doc(data.id).update({updateFieldType: FieldValue.arrayUnion(list)})
        .then((value){
      print("Updated $updateFieldType successfully! ") ;
    })
        .catchError((error){
      print(error) ;
    });

    list = [reqID as String] ;
    snapShot = await _database.collection(collectionPath).where("id", isEqualTo: newValue).get() ;
    data = snapShot.docs.single ;
    await _database.collection(collectionPath).doc(data.id).update({updateFieldType: FieldValue.arrayUnion(list)})
        .then((value){
      print("Updated $updateFieldType successfully! ") ;
    })
        .catchError((error){
      print(error) ;
    });
  }

  // Update a particular detail for a specified associated user (U)
  // for integer updates
  updateSpecificUserValue(String specID, String updateFieldType, int newValue) async{
    final snapShot = await _database.collection(collectionPath).where("id", isEqualTo: specID).get() ;
    final data = snapShot.docs.single ;
    // The id used here is strictly document id but, not regular or authentication uid.
    // WARNING {Diwas - Sensitive !}
    await _database.collection(collectionPath).doc(data.id).update({updateFieldType: newValue}).then((value){
      print("Updated $updateFieldType successfully! ") ;
    })
        .catchError((error){
      print(error) ;
    });
  }

  // Increment integer values if needed
  incrementCurrentUserValue(String updateFieldType, int newValue) async{
    String? reqID = Authentication().currentUser?.uid ;
    final snapShot = await _database.collection(collectionPath).where("id", isEqualTo: reqID).get() ;
    final data = snapShot.docs.single ;
    // The id used here is strictly document id but, not regular or authentication uid.
    // WARNING {Diwas - Sensitive !}
    await _database.collection(collectionPath).doc(data.id).update({updateFieldType: FieldValue.increment(newValue)}).then((value){
      print("Updated $updateFieldType successfully! ") ;
    })
        .catchError((error){
      print(error) ;
    });
  }

  incrementSpecificUserValue(String specID, String updateFieldType, int newValue) async{
    final snapShot = await _database.collection(collectionPath).where("id", isEqualTo: specID).get() ;
    final data = snapShot.docs.single ;
    // The id used here is strictly document id but, not regular or authentication uid.
    // WARNING {Diwas - Sensitive !}
    await _database.collection(collectionPath).doc(data.id).update({updateFieldType: FieldValue.increment(newValue)}).then((value){
      print("Updated $updateFieldType successfully! ") ;
    })
        .catchError((error){
      print(error) ;
    });
  }

  // Checkers
  Future<bool> doesUserAlreadyExist(String username) async{
    final snapShot = await _database.collection(collectionPath).where("name", isEqualTo: username).get() ;
    if(snapShot.docs.isNotEmpty){
      print("Username already exists !") ;
      return true ;
    }
    else{
      print("Valid username") ;
      return false ;
    }
  }

  Future<bool> isSpecifiedUserFriend(String specID) async{
    String reqID = Authentication().currentUser?.uid as String ;
    final snapShot = await _database.collection(collectionPath).where("id", isEqualTo: reqID).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).single ;
    if(data.friends.contains(specID)){
      print("Friends") ;
      return true ;
    }
    else{
      print("Not Friends") ;
      return false ;
    }
  }
}

