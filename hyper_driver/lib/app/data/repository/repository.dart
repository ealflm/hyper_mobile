import 'package:hyper_driver/app/data/models/activity_model.dart';
import 'package:hyper_driver/app/data/models/auth_model.dart';
import 'package:hyper_driver/app/data/models/bus_direction_model.dart';
import 'package:hyper_driver/app/data/models/bus_stations_model.dart';
import 'package:hyper_driver/app/data/models/bus_trip_model.dart';
import 'package:hyper_driver/app/data/models/current_package_model.dart';
import 'package:hyper_driver/app/data/models/notification_model.dart';
import 'package:hyper_driver/app/data/models/order_detail_model.dart';
import 'package:hyper_driver/app/data/models/order_model.dart';
import 'package:hyper_driver/app/data/models/rent_stations_model.dart';
import 'package:hyper_driver/app/data/models/vehicle_rental_model.dart';
import 'package:latlong2/latlong.dart';

import '../models/package_model.dart';

abstract class Repository {
  Future<String> verify(String phoneNumber);
  Future<Auth> login(String phoneNumber, String password);

  Future<String> deposit(double amount, int method, String customerId);

  Future<bool> checkDeposit(String id);

  Future<double> getBalance(String customerId);

  Future<bool> cardLink(String customerId, String uid);

  Future<RentStations> getRentStations();

  Future<VehicleRental> getVehicleRental(String id);

  Future<bool> createRentCustomerTrip(
      String customerId, String vehicleId, DateTime deadline);

  Future<bool> createOrder(Order order);

  Future<List<BusDirection>> getBusDirection(LatLng start, LatLng end);

  Future<BusStations> getBusStation();

  Future<BusTrip> getBusTrip(String id, String customerId);

  Future<bool> busPayment({
    required String customerId,
    required String uid,
    required LatLng location,
  });

  Future<String> sendOtp(String phoneNumber);

  Future<bool> verifyOtp(String phoneNumber, String otp, String requestId);

  Future<Activity> getActivity(String customerId);

  Future<List<OrderDetail>> getOrderDetails(String id);

  Future<List<Package>> getPackages(String customerId);

  Future<bool> buyPackage(String customerId, String packageId);

  Future<CurrentPackage> getCurrentPackage(String customerId);

  Future<bool> registerNotification(String customerId, String code);

  Future<List<Notification>> getNotifications(String driverId);

  Future<bool> clearNotifications(String driverId);
}
