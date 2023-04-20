import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class MapSample extends StatefulWidget {
  const MapSample(
      {Key? key, required this.setter, required this.currentLocation})
      : super(key: key);

  final Function(String) setter;
  final LatLng? currentLocation;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with TickerProviderStateMixin {
  void _mapEventHandler(MapEvent evt) {
    if (evt is MapEventMove) {
      _onMapEventMoveEnd(evt);
    }
  }

  late final mapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  void _onMapEventMoveEnd(MapEventMove e) {
    LatLng center = e.center;
    // widget.setter('${center.latitude},${center.longitude}');
    widget.setter('Zoom level: ${e.zoom}');
  }

  void _goToSelf() {
    print(widget.currentLocation);
    if (widget.currentLocation != null) {
      // mapController.move(widget.currentLocation!, 13.0);
      mapController.animateTo(
        dest: widget.currentLocation!,
        zoom: 13.0,
      );
    }
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];
    if (widget.currentLocation != null) {
      markers.add(Marker(
          point: widget.currentLocation!,
          builder: (BuildContext context) => const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              )));
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: FloatingActionButton(
          onPressed: _goToSelf,
          child: const Icon(Icons.location_on),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onMapReady: _goToSelf,
          keepAlive: true,
          rotation: 0,
          center: widget.currentLocation,
          zoom: 13.0,
          maxZoom: 22.0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          onMapEvent: _mapEventHandler,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png?api_key=12178e99-9ee2-46f3-8a94-c3fcfa50e7ac',
            maxNativeZoom: 18.0,
          ),
          MarkerLayer(
            markers: _getMarkers(),
          )
        ],
      ),
    );
  }
}
