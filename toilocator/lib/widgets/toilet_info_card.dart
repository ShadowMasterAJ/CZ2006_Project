import 'package:flutter/material.dart';
import 'package:toilocator/services/getToiletImageUrlList.dart';
import '../palette.dart';
import 'bottom_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'input_review_page.dart';
import 'toilet_card.dart';

class toiletInfoCard extends StatefulWidget {
  final Map indices;
  final List toiletList;
  final int index;

  @override
  State<toiletInfoCard> createState() => _toiletInfoCardState();

  const toiletInfoCard({
    Key? key,
    required this.indices,
    required this.toiletList,
    required this.index,
  }) : super(key: key);
}

class _toiletInfoCardState extends State<toiletInfoCard> {
  List<Widget> imageList = [];

  List<Widget> displayStarRating(int awardInt) {
    List<Widget> childrenList = [];
    if (awardInt > 5) {
      awardInt = 5;
    }
    for (int i = 0; i < awardInt; i++) {
      childrenList.add(Icon(Icons.star_rate_rounded,
          color: Color.fromARGB(255, 255, 198, 77)));
    }
    for (int i = 0; i < 5 - awardInt; i++) {
      childrenList.add(Icon(Icons.star_rate_rounded,
          color: Color.fromARGB(255, 211, 211, 211)));
    }
    return childrenList;
  }

  Future createImageList() async {
    // Convert URL links to realToiletImage

    List<Widget> realToiletImages = [];
    List? ImageUrlList =
        await getToiletImageUrlList(widget.toiletList[widget.index].image);
    for (var item in ImageUrlList!) {
      realToiletImages.add(Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Image.network(item, scale: 2.3)));
    }

    imageList = realToiletImages;

    return Future.value();
  }

  Widget UserReviewInfo() {
    //ListView builder probably needed, refer to bottom_panel line 93
    return Container(
        height: 160,
        child: Card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('User Name',
                          style: Theme.of(context).textTheme.subtitle1)),
                  // Padding(padding: const EdgeInsets.only(right: 160.0)),
                  Spacer(),
                  Row(children: displayStarRating(4)),
                ]),
                SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'according to all known laws of aviation,',
                      maxLines: 5,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
                    )),
                // Padding(padding: const EdgeInsets.only(right: 110.0)),
                SizedBox(height: 8),
                Divider(
                    color: Color.fromARGB(255, 218, 218, 218), thickness: 1),
              ]),
        ));
  }

  Route createRoute(int index, List toiletList) {
    return PageRouteBuilder(
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) =>
          InputReviewPage(index: index, toiletList: toiletList),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius.only(
        topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0));

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          color: Palette.beige[100],
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                child: Text(
                  // no splashcolour here
                  "Directions",
                ),
                onPressed: null,
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 255, 255, 255)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Palette.beige[300] as Color),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Palette.beige[300] as Color),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 58),
            Text(widget.indices[widget.index].toString() + "m",
                style: Theme.of(context).textTheme.headline5?.merge(TextStyle(
                    color:
                        Color.fromARGB(255, 87, 62, 25))) // change colour too
                ),
            // SizedBox(width: 65),
            Spacer(),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(children: [
                  TextButton(
                      child: Text(
                        "Back",
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Palette.beige[300] as Color),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 255, 255)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))))))
                ])),
          ])),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            Divider(
              thickness: 1.5,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              child: Text(
                widget.toiletList[widget.index].toiletName,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline5,
                // style: TextStyle(fontFamily: "Avenir"),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 18,
              child: Text(
                widget.toiletList[widget.index].address,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.merge(TextStyle(color: Color.fromARGB(255, 87, 87, 87))),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 30),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      "Official Hygiene Rating    ",
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
              Padding(padding: const EdgeInsets.only(right: 110.0)),
              Row(
                  children: displayStarRating(
                      widget.toiletList[widget.index].awardInt))
            ]),
            SizedBox(height: 15),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      "User Hygiene Rating    ",
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
              Padding(padding: const EdgeInsets.only(right: 110.0)),
              Row(
                  children: displayStarRating(widget
                      .toiletList[widget.index].awardInt)) //placeholder value
            ]),
            SizedBox(height: 15),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      "Accessibility    ",
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
              Padding(padding: const EdgeInsets.only(right: 110.0)),
              Row(children: [
                SizedBox(
                  width: 60,
                ),
                Icon(
                  Icons.wheelchair_pickup,
                  color: Palette.beige[300],
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.baby_changing_station)
              ])
            ]),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "Official Images",
                style: Theme.of(context).textTheme.bodyText1?.merge(
                    TextStyle(color: Color.fromARGB(255, 118, 118, 118))),
              ),
            ),
            Container(
                height: 180,
                child: FutureBuilder(
                  future: createImageList(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: imageList,
                      ),
                    );
                  },
                )),
            Divider(
                color: Color.fromARGB(255, 114, 114, 114),
                thickness: 4,
                indent: 30,
                endIndent: 30),
            SizedBox(height: 12),
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text("User Reviews",
                        style: Theme.of(context).textTheme.headline6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 115),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).push(createRoute(
                                widget.index,
                                widget
                                    .toiletList)), // ONLY IF USER IS AUTHENTICATED
                            child: Text(
                              "Write Review...",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                            ),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 185, 185, 185),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    )
                  ],
                )),
            SizedBox(height: 6),
            Divider(color: Color.fromARGB(255, 218, 218, 218), thickness: 2),
            SizedBox(height: 6),
            UserReviewInfo(),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
