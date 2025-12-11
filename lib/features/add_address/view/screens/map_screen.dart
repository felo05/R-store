import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  LocationPickerScreenState createState() => LocationPickerScreenState();
}

class LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _selectedPosition = LatLng(37.7749, -122.4194);
  bool _isLoading = true;
  final MapController _mapController = MapController();
  Placemark? _placeMark; // Nullable to handle uninitialized state

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
      return AppLocalizations.of(context)?.error_getting_current_location; // Localized error message;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Fetch placemark for current location
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() {
          _placeMark = placemarks[0];
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(_selectedPosition, 17);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        debugPrint("Error getting location: $e");
      }
      return AppLocalizations.of(context)!.error_getting_current_location;
    }
    return null;
  }

  void _onTap(LatLng position) async {
    setState(() {
      _selectedPosition = position;
    });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() {
          _placeMark = placemarks[0];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error during reverse geocoding: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get address: $e")),
      );
    }
  }

  void _updateToCurrentLocation() async {
    setState(() => _isLoading = true);
    await _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: BackAppBar(
          title: AppLocalizations.of(context)!.select_location,
          color: baseColor,
          textColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: BackAppBar(
        title: AppLocalizations.of(context)!.select_location,
        color: baseColor,
        textColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
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
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
          ),
          if (_placeMark != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Street: ${_placeMark!.street ?? 'Not available'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "City: ${_placeMark!.administrativeArea ?? 'Not available'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: AppLocalizations.of(context)!.current_location,
            onPressed: _updateToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: AppLocalizations.of(context)!.confirm_location,
            onPressed: () {
              if (_placeMark != null) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.completeAddAddress,
                  arguments: CompleteAddAddressArguments(
                    position: _selectedPosition,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please select a location first")),
                );
              }
            },
            child: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}