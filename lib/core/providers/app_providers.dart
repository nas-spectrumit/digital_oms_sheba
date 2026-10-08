import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> appProviders = [ChangeNotifierProvider(create: (_) => DeviceInfoController())];
