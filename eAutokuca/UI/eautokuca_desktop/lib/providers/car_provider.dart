// ignore_for_file: unused_field

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';

class CarProvider extends BaseProvider<Car> {
  CarProvider() : super("Automobil/getAll");

  @override
  Car fromJson(data) {
    // TODO: implement fromJson
    return Car.fromJson(data);
  }
}
