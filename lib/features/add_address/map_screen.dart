import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'complete_adding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  LocationPickerScreenState createState() => LocationPickerScreenState();
}

class LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _selectedPosition = LatLng(37.7749, -122.4194);
  bool _isLoading = true; // Loading state
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<String?> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(_selectedPosition, 17);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return  AppLocalizations.of(context)!.error_getting_current_location;
    }
    return null;
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  void _updateToCurrentLocation() async {
    setState(() => _isLoading = true);
    await _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: BackAppBar(title: AppLocalizations.of(context)!.select_location, color: baseColor, textColor: Colors.black,),
        body: const Center(child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    return Scaffold(
      appBar: BackAppBar(title: AppLocalizations.of(context)!.select_location, color: baseColor, textColor: Colors.black,),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _selectedPosition,
          zoom: 17,
          maxZoom: 18,
          minZoom: 1,
          onTap: (_, position) => _onTap(position),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedPosition,
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag:  AppLocalizations.of(context)!.current_location,
            onPressed: _updateToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag:  AppLocalizations.of(context)!.confirm_location,
            onPressed: () {
              Get.to(() => CompleteAddAddress(position: _selectedPosition));
            },
            child: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
