import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review.dart';
import '../models/toilet.dart';

// DO NOT DELETE
// Must press run to initialise app
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   addReview(DateTime.now(), 'user2', '0', 5, "High class toilet, enjoyed it!");
//   getReviewList('0', 1);
//   test('hi2');
// //   helperConvertToiletJSON();

//     // put this in addMarker map_stack
//     // print("Comment: main running");
//     // print('----------------------');
//     // print('----------------------');
//     // print('----------------------');
//     // print('----------------------');
//     // helperConvertToiletJSON(); ady converted, don't use anymore

// }

/// Adds a document in firebase with field test: [test].
Future<void> test(String test) async {
  await FirebaseFirestore.instance.collection("userInput").add({'test': test});
}

/// Adds a new toilet document to firebase given all the attributes.
// Adds a toilet instance to firebase.
// doc() specifies the new index used.
// .set updates doc().
Future<void> addToilet(
    int index,
    String type,
    String albumURL,
    String address,
    String toiletName,
    List coords,
    int officialRating,
    double userRating) async {
  await FirebaseFirestore.instance
      .collection("toilets")
      .doc(index.toString())
      .set({
        'index': index.toString(),
        'type': type,
        'albumURL': albumURL,
        'address': address,
        'toiletName': toiletName,
        'latitude': coords[0],
        'longitude': coords[1],
        'officialRating': officialRating,
        'userRating': userRating
      })
      .then((value) => print("Toilet Added"))
      .catchError((error) => print("Failed to add toilet: $error"));
}
// DO NOT DELETE
// convert toilet JSON format to firebase
// Future<void> helperConvertToiletJSON() async {
//   final String toiletJson =
//         await rootBundle.loadString('lib/data/toilets.json');
//   final toiletParsed = await json.decode(toiletJson);

//   List _toiletTemp = toiletParsed["toilets"];
//   //for (int i = 0; i < 1; i++) {
//   for (int i = 0; i < _toiletTemp.length; i++) {
//     int index = _toiletTemp[i]["index"];
//     String type = _toiletTemp[i]["type"];
//     String image = _toiletTemp[i]["image_link-href"];
//     String address = _toiletTemp[i]["address"];
//     String name = _toiletTemp[i]["toilet_name"];
//     List coords = _toiletTemp[i]["coords"];
//     int award = _toiletTemp[i]["award_int"];
//     addToilet(index, type,
//       image, address, name,
//       coords, award, 0);
//     // Toilet toilet = new Toilet(
//     //     index: index,
//     //     type: type,
//     //     image: image,
//     //     address: address,
//     //     toiletName: name,
//     //     //district: district,
//     //     coords: coords,
//     //     awardInt: award);
//     // _toiletList.add(toilet);
//     print("Comment: Successfully added toilet[$i]");
//   }
// }

/// Adds a new review document to firebase given all the attributes.
/// addReview for a toilet ID = index.
Future<void> addReview(DateTime dateTime, String userID, String toiletID,
    int userRating, String userComment) async {
  CollectionReference toilets =
      FirebaseFirestore.instance.collection('toilets');

  // try to get the doc ref given index
  await toilets.doc(toiletID).collection("reviews").add({
    'dateTime': dateTime,
    'userID': userID,
    'toiletID': toiletID,
    'userRating': userRating,
    'userComment': userComment
  });
  print('Comment: addReview - review added');
}

/// Gets all the reviews from firebase given [toiletID].
/// Returns a list of reviews.
Future<List<Review>> getReviewList(String toiletID, int numOfReview) async {
  List<Review> reviewList = [];
  CollectionReference toilets =
      FirebaseFirestore.instance.collection('toilets');
  await toilets
      .doc(toiletID)
      .collection('reviews')
      .orderBy("dateTime", descending: true)
      .limit(numOfReview)
      .get() // get all the documents
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      Review review = new Review(
          DateTime.parse(doc['dateTime'].toDate().toString()),
          doc['userID'],
          doc['toiletID'],
          doc['userRating'],
          doc['userComment']);
      reviewList.add(review);
    });
  });
  print('Comment: getReviewList length of reviewList: ${reviewList.length}');
  return reviewList;
}

/// Gets all the toilets from firebase.
/// Returns a list of toilets.
Future<List<Toilet>> getToiletList() async {
  List<Toilet> toiletList = [];
  CollectionReference toilets =
      FirebaseFirestore.instance.collection('toilets');
  await toilets.get() // get all the documents
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      Toilet toilet = new Toilet(
          index: int.parse(doc['index']),
          type: doc['type'],
          image: doc['albumURL'],
          address: doc['address'],
          toiletName: doc['toiletName'],
          coords: [doc['latitude'], doc['longitude']],
          awardInt: doc['officialRating']);
      // print('Comment: alolo ${doc['toiletName']}');
      toiletList.add(toilet);
    });
  });
  print(
      'Comment: alolo getToiletList length of toiletList: ${toiletList.length}');
  return toiletList;
}
