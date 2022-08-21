import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/model/data_hub_model.dart';
import 'package:hyper_driver/app/core/model/driver_response_model.dart';
import 'package:hyper_driver/app/core/model/location_model.dart';
import 'package:hyper_driver/app/core/model/startLocationBooking_model.dart';
import 'package:hyper_driver/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_driver/app/modules/pick-up/controllers/pick_up_controller.dart';
import 'package:hyper_driver/app/modules/pick-up/models/view_state.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRController {
  static final SignalRController _instance = SignalRController._internal();
  static SignalRController get instance => _instance;
  SignalRController._internal();

  HubConnection? _hubConnection;
  late Logger _logger;

  bool connectionIsOpen = false;

  static const host =
      "https://tourism-smart-transportation-api.azurewebsites.net";
  final String _serverUrl = "$host/hub";

  void init() async {
    connectionIsOpen = false;

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      debugPrint(
          'Hyper SignalR: ${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    _logger = Logger("Hyper SignalR");

    _openConnection();
  }

  void _openConnection() async {
    var token = TokenManager.instance.token;

    final logger = _logger;

    if (_hubConnection == null) {
      final httpConnectionOptions = HttpConnectionOptions(
          logger: logger,
          logMessageContent: true,
          accessTokenFactory: () async {
            return token;
          });

      _hubConnection = HubConnectionBuilder()
          .withUrl(_serverUrl, options: httpConnectionOptions)
          .withAutomaticReconnect(retryDelays: [
            1000,
            2000,
            3000,
            3000,
            3000,
            3000,
            3000,
            3000,
            10000
          ])
          .configureLogging(logger)
          .build();

      _hubConnection?.onclose(({error}) => connectionIsOpen = false);
      _hubConnection?.onreconnecting(({error}) {
        debugPrint("Hyper SignalR: Onreconnecting called");
        connectionIsOpen = false;
      });
      _hubConnection?.onreconnected(({connectionId}) {
        debugPrint("Hyper SignalR: onreconnected called");
        connectionIsOpen = true;
      });
    }

    if (_hubConnection?.state != HubConnectionState.Connected) {
      try {
        await _hubConnection?.start();
        connectionIsOpen = true;
      } catch (e) {
        _checkConnection();
      }
    }

    _listen();
  }

  Future<void> _checkConnection() async {
    if (_hubConnection?.state != HubConnectionState.Connected) {
      debugPrint('Hyper SignalR: Connecting again');
      _hubConnection?.stop();
      await _hubConnection?.start();
    }
  }

  void closeConnection() {
    _hubConnection?.stop();
  }

  void _listen() {
    _hubConnection?.on("BookingRequest", _bookingRequest);
    _hubConnection?.on("CanceledBooking", _canceledBooking);
  }

  void _canceledBooking(List<Object>? parameters) {
    HyperDialog.show(title: 'Chú ý', content: 'Bạn đã bị từ chối :(((');
    Get.offAllNamed(Routes.MAIN);
  }

  void _bookingRequest(List<Object>? parameters) async {
    var mapper = parameters?[0] as Map<String, dynamic>;
    var driver = jsonEncode(DataHubModel.fromJson(mapper['driver']).toJson());

    driver = jsonEncode(DriverResponseModel.fromJson(mapper));

    var result = await Get.toNamed(Routes.BOOKING_REQUEST);

    if (result == 1) {
      await _hubConnection?.invoke(
        "CheckAcceptedRequest",
        args: [driver, "1"],
      );
      Get.offAllNamed(Routes.PICK_UP);
    } else {
      await _hubConnection?.invoke(
        "CheckAcceptedRequest",
        args: [driver, "0"],
      );
    }
  }

  void openDriver(LatLng location) async {
    await _checkConnection();
    String driverId = TokenManager.instance.user?.driverId ?? '';
    var data = {
      'Id': driverId,
      'Latitude': location.latitude,
      'Longitude': location.longitude,
    };

    final result = await _hubConnection?.invoke(
      "OpenDriver",
      args: [jsonEncode(data)],
    );

    debugPrint(result.toString());
  }

  void closeDriver() async {
    String driverId = TokenManager.instance.user?.driverId ?? '';

    final result = await _hubConnection?.invoke(
      "CloseDriver",
      args: [driverId],
    );

    debugPrint(result.toString());
  }

  void driverArrived() async {
    await _checkConnection();

    String driverId = TokenManager.instance.user?.driverId ?? '';

    final result = await _hubConnection?.invoke(
      "DriverArrived",
      args: [driverId],
    );

    PickUpController _pickUpController = Get.find<PickUpController>();
    _pickUpController.changeState(PickUpState.picked);

    debugPrint(result.toString());
  }

  void driverPickedUp() async {
    await _checkConnection();

    String driverId = TokenManager.instance.user?.driverId ?? '';

    final result = await _hubConnection?.invoke(
      "DriverPickedUp",
      args: [driverId],
    );

    PickUpController _pickUpController = Get.find<PickUpController>();
    _pickUpController.changeState(PickUpState.finished);

    debugPrint(result.toString());
  }

  void completedBooking() async {
    await _checkConnection();

    String driverId = TokenManager.instance.user?.driverId ?? '';

    final result = await _hubConnection?.invoke(
      "CompletedBooking",
      args: [driverId],
    );

    PickUpController _pickUpController = Get.find<PickUpController>();
    _pickUpController.changeState(PickUpState.completed);

    debugPrint(result.toString());
  }
}

  // void _bookingRequest(List<Object>? parameters) async {
  //   debugPrint('_bookingRequest ${parameters?[0]}');

  //   var locationModel = LocationModel(
  //     id: '84cd154d-a453-497a-b2aa-85a5aa9d9029',
  //     latitude: 10.865836,
  //     longitude: 106.781622,
  //   );

  //   String data = jsonEncode(locationModel.toJson());

  //   var mapper = parameters?[0] as Map<String, dynamic>;
  //   var driver = jsonEncode(DataHubModel.fromJson(mapper['driver']).toJson());
  //   var customer =
  //       jsonEncode(DataHubModel.fromJson(mapper['customer']).toJson());

  //   driver = jsonEncode(DriverResponseModel.fromJson(mapper));

  //   final result = await _hubConnection.invoke(
  //     "CheckAcceptedRequest",
  //     args: <Object>[driver, "1"],
  //   );

  //   debugPrint('CheckAcceptedRequest ${parameters?[0]}');
  // }

  // void _bookingResponse(List<Object>? parameters) {
  //   debugPrint('_bookingResponse ${parameters?[0]}');
  // }

  // void closeDriver() async {
  //   // var locationModel = LocationModel(
  //   //   id: '84cd154d-a453-497a-b2aa-85a5aa9d9029',
  //   //   latitude: 10.864483,
  //   //   longitude: 106.780907,
  //   //   seats: 2,
  //   // );

  //   // String data = jsonEncode(locationModel.toJson());

  //   final result = await _hubConnection.invoke(
  //     "CloseDriver",
  //     args: <Object>["84cd154d-a453-497a-b2aa-85a5aa9d9029"],
  //   );

  //   debugPrint('Hyper SignalR: $result');
  // }

  // void action1() async {
  //   var locationModel = StartLocationBookingModel(
  //     id: '1D17684A-00DD-4840-937B-9BC1E4DA033D',
  //     latitude: 10.868463,
  //     longitude: 106.779407,
  //   );
  //   String data = jsonEncode(locationModel.toJson());
  //   final String result = await _hubConnection.invoke(
  //     "GetDriversListMatching",
  //     args: <Object>[data],
  //   ) as String;

  //   debugPrint('Hyper SignalR: Action 1 Pressed $result');
  // }

  // void action2() async {
  //   var locationModel = LocationModel(
  //     id: '1D17684A-00DD-4840-937B-9BC1E4DA033D',
  //     latitude: 10.868463,
  //     longitude: 106.779407,
  //     priceBookingId: '8C06808E-E38A-4A1D-90FF-04E153DDF1FF',
  //     price: 99000,
  //     distance: 2500,
  //     seats: 2,
  //   );

  //   String data = jsonEncode(locationModel.toJson());
  //   final result = await _hubConnection.invoke(
  //     "FindDriver",
  //     args: <Object>[data],
  //   );

  //   debugPrint('Hyper SignalR: Action 2 Pressed');
  // }

  // void action3() async {
  //   debugPrint('Hyper SignalR: Action 3 Pressed');

  //   final result = await _hubConnection.invoke(
  //     "CancelBooking",
  //     args: <Object>['1D17684A-00DD-4840-937B-9BC1E4DA033D'],
  //   );
  //   // TO DO
  // }

  // void action4() async {
  //   debugPrint('Hyper SignalR: Action 4 Pressed');
  //   // TO DO
  // }

  // void action5() async {
  //   debugPrint('Hyper SignalR: Action 5 Pressed');
  //   // TO DO
  // }