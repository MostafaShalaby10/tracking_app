import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  static MapCubit get(context) => BlocProvider.of(context);

  late GoogleMapController googleMapController;

  late Location location = Location();
  Set<Marker> markers = {};

  // To create initial view
  CameraPosition initialCameraPosition() =>
      CameraPosition(target: LatLng(0, 0));

  void onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;
    await detectCurrentLocationFunction();
    await getCurrentLocation();
  }

  Future detectCurrentLocationFunction() async {
    return location.onLocationChanged.listen((event) {
      sendCurrentLocation(location: event);
    });
  }

  void addMarker(LatLng latLng) {
    markers = {};
    markers.add(
      Marker(markerId: MarkerId(latLng.toString()), position: latLng),
    );
  }

  Future sendCurrentLocation({required LocationData location}) async {
    return FirebaseDatabase.instance.ref('location').set({
      'latitude': location.latitude,
      'longitude': location.longitude,
      "date": DateTime.now().toString(),
    });
  }

  Future getCurrentLocation() async {
    FirebaseDatabase.instance.ref('location').onValue.listen((event) {
      var data = event.snapshot.value as Map;
      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(data['latitude'], data['longitude']),
          15,
        ),
      );
      addMarker(LatLng(data['latitude'], data['longitude']));
      emit(SuccessfullyGetCurrentLocation());
    });
  }
}
