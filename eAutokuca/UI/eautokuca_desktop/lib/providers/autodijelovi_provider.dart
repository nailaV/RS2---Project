import 'package:eautokuca_desktop/models/autodijelovi.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';

class AutodijeloviProvider extends BaseProvider<Autodijelovi> {
  AutodijeloviProvider() : super("Autodio");

  @override
  Autodijelovi fromJson(data) {
    // TODO: implement fromJson
    return Autodijelovi.fromJson(data);
  }
}
