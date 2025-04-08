import 'package:gato_id_generator/src/data/model/gato_id_content.dart';
import 'package:hive_ce/hive.dart';

import '../../data/model/app_user/app_user.dart';
import '../../data/model/app_user/local_app_user.dart';
import '../constants/_constants.dart';

part 'hive_adapters.g.dart';

// TODO when using hive.
@GenerateAdapters([
  AdapterSpec<AppUser>(),
  AdapterSpec<LocalAppUser>(),
  AdapterSpec<GatoId>(),
])
class HiveAdapters {}

// TODO when using hive.

extension HiveRegistrar on HiveInterface {
  Future<void> initBoxes() async {
    await Hive.openBox<bool>(DBKeys.BRIGHTNESS_BOX);
    await Hive.openBox<AppUser?>(DBKeys.AUTH_STATE_BOX);
    // Specific for localAuthRepo only
    await Hive.openBox<LocalAppUser>(DBKeys.USER_BOX); // TODO be utilizing encryption shceme

    await Hive.openBox<String>(DBKeys.SAVED_ID_BOX);
    await Hive.openBox<int>(DBKeys.GENERATED_ID_COUNT_BOX);
  }
}
