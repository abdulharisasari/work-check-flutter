import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workcheckapp/services/themes.dart';

class AccessPermissionModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    'Location Permission',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 2,
                    ),
                  ),
                  Text(
                    'Please allow us to access your current location.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(primaryColor),
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => Geolocator.openAppSettings(),
                    child: Center(
                      child: Text('Allow Permission'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
