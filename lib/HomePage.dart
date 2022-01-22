import 'package:flutter/material.dart';
import 'package:flutter_nearby_messages_api/flutter_nearby_messages_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterNearbyMessagesApi nearbyMessagesApi = FlutterNearbyMessagesApi();

  @override
  Widget build(BuildContext context) {
    // This callback gets the message when an a nearby device sends one
    nearbyMessagesApi.onFound = (message) {
      print('~~~onFound : $message');
    };

    // This callback gets the message when a nearby device leaves
    nearbyMessagesApi.onLost = (message) {
      print('~~~onLost : $message');
    };

    // Listen status when publish and subscribe
    // enum GNSOperationStatus { inactive, starting, active }
    nearbyMessagesApi.statusHandler = (status) {
      print('~~~statusHandler : $status');
    };

    // Use your messages to nearby permission alert
    nearbyMessagesApi.setPermissionAlert(
        'Your title', 'Your message', 'Deny', 'Grant');

    nearbyMessagesApi.permissionHandler = (status) {
      print(status);
    };

    nearbyMessagesApi.bluetoothPowerErrorHandler = (args) {
      print('~~~ bluetoothPowerErrorHandler');
    };

    nearbyMessagesApi.bluetoothPermissionErrorHandler = (args) {
      print('~~~ bluetoothPermissionErrorHandler');
    };

    nearbyMessagesApi.microphonePermissionErrorHandler = (args) {
      print('~~~ microphonePermissionErrorHandler');
    };

    @override
    void dispose() async {
      super.dispose();
      // unPublish
      await nearbyMessagesApi.unPublish();
      // backgroundUnsubscribe
      await nearbyMessagesApi.backgroundUnsubscribe();
    }

    return Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showEditText(context);
              },
              child: Text("Sent Text")),
        ],
      ),
    );
  }

  void showEditText(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            actions: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a text to sent',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Cancel"),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        sentTxT();
                      },
                      child: Text("Sent"),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void sentTxT() async {
    /**
      * Publishing a message
      * @require message
      */
    await nearbyMessagesApi.publish('Hello world!');
    /**
      * Subscribing
      */
    await nearbyMessagesApi.backgroundSubscribe();

    // // Enable debug mode
    // await nearbyMessageAPi.enableDebugMode();
    // // Disable debug mode
    // await nearbyMessageAPI.disableDebugMode();

    // Do not use it if you have not learned it carefully
    // nearbyMessagesApi.setNearbyAccessPermission(true);
  }
}
