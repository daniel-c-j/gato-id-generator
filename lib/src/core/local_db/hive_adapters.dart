import 'package:hive_ce/hive.dart';

import '../../data/model/app_user/app_user.dart';
import '../../data/model/app_user/local_app_user.dart';
import '../constants/_constants.dart';

part 'hive_adapters.g.dart';

// TODO when using hive.
@GenerateAdapters([
  AdapterSpec<AppUser>(),
  AdapterSpec<LocalAppUser>(),
])
class HiveAdapters {}

// TODO when using hive.

extension HiveRegistrar on HiveInterface {
  Future<void> initBoxes() async {
    await Hive.openBox<bool>(DBKeys.BRIGHTNESS_BOX);
    await Hive.openBox<AppUser?>(DBKeys.AUTH_STATE_BOX);
    // Specific for localAuthRepo only
    await Hive.openBox<LocalAppUser?>(DBKeys.LOCAL_USER_BOX);
  }
}
