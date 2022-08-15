import 'package:get/get.dart';

import 'local_source_bindings.dart';
import 'repository_bindings.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    RepositoryBindings().dependencies();
    LocalSourceBindings().dependencies();
  }
}
