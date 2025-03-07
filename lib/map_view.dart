import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/logic/map_cubit.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit(),
      child: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: GoogleMap(
              onMapCreated: MapCubit.get(context).onMapCreated,
              markers: MapCubit.get(context).markers,
              initialCameraPosition: MapCubit.get(context).initialCameraPosition(),
            ),
          );
        },
      ),
    );
  }
}
