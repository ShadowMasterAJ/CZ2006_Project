// ignore_for_file: import_of_legacy_library_into_null_safe

//just there cuz why not
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//files
import '/models/toilet.dart';
import '../palette.dart';
import '../services/getToiletInfo.dart';
import 'MapStack_Widgets/bottom_panel.dart';
import 'toilet_info_card.dart';

/// The main widget displayed in home_map_screen.dart
/// Displays the map with all the toilets within 1km of the location
/// Also displays the search bar and the bottom panel.
/// The bottom panel contains the information of the displayed toilets.
/// The search bar is used to search for toilets.
class MapStack extends StatefulWidget {
  const MapStack({
    Key? key,
    // required this.getLocFromInfo,
  }) : super(key: key);

  @override
  State<MapStack> createState() => _MapStackState();
}

class _MapStackState extends State<MapStack> {
  /// Initialial position of the map.
  LatLng _initialcameraposition = LatLng(1.3521, 103.8198);

  /// Initialisation of the map controller.
  late GoogleMapController _controller;

  late double userLat = 1.3521, userLong = 103.8198;

  /// Map of the index of the toilet and its distance from the user's location.
  Map indices = {};

  /// List of all markers to be displayed.
  List<Marker> _markers = [];

  /// List of all toilets.
  List<Toilet> _toiletList = [];

  /// Icon that signifies a toilet
  late BitmapDescriptor toiletIcon;

  /// Various constrains to control the bottom panel
  final double _initFabHeight = 131.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 118.0;

  /// The first thing that is called when the widget is created.
  /// Sets up the various constrains and icons.
  /// Gets the toilets from the database.
  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
    retrieveIcon();
    prepareToilets();
  }

  /// Fills toiletList with all toilets from the database.
  void prepareToilets() async {
    _toiletList = await getToiletList();
  }

  /// Adds marker to the map for the searched/current location
  void addMarker() {
    _markers.add(
      Marker(
          markerId: MarkerId(_initialcameraposition.toString()),
          draggable: false,
          onTap: () {
            print(_initialcameraposition.toString());
          },
          position: _initialcameraposition),
    );
  }

  /// Retrieves the icon for the toilet.
  void retrieveIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'lib/assets/toilet_marker.png')
        .then((onValue) {
      toiletIcon = onValue;
    });
  }

  /// Adds markers to the map for selected toilets.
  void addToiletMarker(int markerId, double lat, double long) {
    LatLng _position = LatLng(lat, long);
    Marker marker = Marker(
        markerId: MarkerId(_position.toString()),
        position: _position,
        onTap: () {
          print("what");
          Navigator.of(context).push(createRoute(markerId));
        },
        icon: toiletIcon);
    _markers.add(marker);
    print('added marker');
  }

  /// Marks the toilets that are within 1km of the user's location.
  void markNearestToilets(double lat, double long) {
    indices.clear();
    indices = calculateNearestToilets(lat, long);
    for (int k in indices.keys) {
      int index = k;
      List coords = _toiletList[index].coords;
      addToiletMarker(index, coords[0], coords[1]);
      print('marked nearest toilets');
    }
    print(indices);
  }

  /// Calculates the distance of each toilet from the user's location.
  Map calculateNearestToilets(double lat, double long) {
    Map nearestToiletList = {};
    for (int i = 0; i < _toiletList.length; i++) {
      // calculation by haversine
      double targetCoord_lat = _toiletList[i].coords[0];
      double targetCoord_long = _toiletList[i].coords[1];
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((targetCoord_lat - lat) * p) / 2 +
          c(lat * p) *
              c(targetCoord_lat * p) *
              (1 - c((targetCoord_long - long) * p)) /
              2;
      double dist = 12742 * asin(sqrt(a)); // in KM
      if (dist < 1) {
        // CURRENT THRESHOLD AT 1KM
        nearestToiletList[i] = (dist * 1000).ceil();
      }
    }
    print('calcd nearest toilets');
    print(nearestToiletList);
    Map nearestToiletListSorted = Map.fromEntries(
        nearestToiletList.entries.toList()
          ..sort((e1, e2) => e1.value.compareTo(e2.value)));
    return nearestToiletListSorted;
  }

  /// Centers the map on the user's location and marks it.
  void centerToPositionandMark(double lat, double long) {
    print('fetched in function');
    print("Latitude: $lat and Longitude: $long");

    setState(() => _initialcameraposition = LatLng(lat, long));
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _initialcameraposition,
        zoom: 15,
      ),
    ));
    _markers.clear();
    polylines.clear();
    addMarker();
    print('addMarker called');

    markNearestToilets(lat, long);
    print('centered and marked');
    for (int i = 0; i < _markers.length; i++) {
      print(_markers[i].markerId.toString());
    }
  }

  /// Function to fetch the user's location.
  Future<LatLng> getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lat = position.latitude;
    var long = position.longitude;
    return LatLng(lat, long);
  }

  /// Function to center to the user's fetched location.
  void centerToCurrentLocation() async {
    LatLng latlng = await getCurrentLocation();
    centerToPositionandMark(latlng.latitude, latlng.longitude);
  }

  /// When the map is created, the map controller is set.
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

  /// Show toilet info when its marker is tapped
  Route createRoute(int markerId) {
    return PageRouteBuilder(
      settings: RouteSettings(name: "/toiletInfo"),
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) =>
          toiletInfoCard(
        indices: indices,
        toiletList: _toiletList,
        index: markerId,
        getPolyLines: (polies) => setPolyLines(polies),
        lat: userLat,
        lng: userLong,
      ),
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

  /// The polylines for the route between the user and the toilet.
  Map<PolylineId, Polyline> polylines = {};

  /// Sets the polylines for the route between the user and the toilet.
  void setPolyLines(Map<PolylineId, Polyline> poly) {
    print('set poly points set state map stack');
    setState(() {
      polylines = poly;
    });
    print('Printing poly: ${poly.entries}');
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .8;
    return Stack(
        alignment: AlignmentDirectional.topStart,
        fit: StackFit.loose,
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialcameraposition,
              zoom: 11.0,
            ),
            buildingsEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            markers: Set.from(_markers),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: TextField(
                onSubmitted: (value) async {
                  try {
                    var addr =
                        await Geocoder.local.findAddressesFromQuery(value);
                    var lat = addr.first.coordinates.latitude;
                    var long = addr.first.coordinates.longitude;
                    setState(() {
                      userLat = lat;
                      userLong = long;
                    });
                    print('Mapstack latlng: $lat, $long');
                    centerToPositionandMark(lat, long);
                  } catch (PlatformException) {
                    Fluttertoast.showToast(
                        msg: "Invalid Location, please try again!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Color.fromARGB(255, 99, 99, 99),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 20,
                      color: Palette.beige.shade900,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  suffixIcon: Icon(
                    Icons.search_sharp,
                    size: 30,
                    color: Palette.beige.shade800,
                  ),
                  filled: true,
                  fillColor: Palette.beige[100]?.withOpacity(0.95),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.brown.shade100, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.brown.shade100, width: 5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                  hintText: 'Enter your location',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 13, vertical: 18),
                ),
              )),
          SlidingUpPanel(
            snapPoint: 0.35,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .1,
            panelBuilder: (sc) => bottomPanel(
              indices: indices,
              context: context,
              toiletList: _toiletList,
              getPolyLines: (polies) => setPolyLines(polies),
              sc: sc,
              lat: userLat,
              lng: userLong,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),
          Positioned(
            bottom: _fabHeight,
            right: 10,
            child: FloatingActionButton(
              tooltip: "Center to your location",
              elevation: 10,
              backgroundColor: Palette.beige[200],
              onPressed: centerToCurrentLocation,
              child: Icon(
                Icons.gps_fixed,
                size: 25,
                color: Palette.beige[900],
              ),
            ),
          ),
        ]);
  }
}
