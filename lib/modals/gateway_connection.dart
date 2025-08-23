import 'package:flutter/material.dart';
import 'package:workcheckapp/services/themes.dart';

class GatewayConnectionModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  'Gateway Timeout',
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 2,
                  ),
                ),
                Text(
                  'There are some issues with the network or system. Please check your connection.',
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Center(
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
