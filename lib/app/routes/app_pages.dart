import 'package:get/get.dart';
import 'package:myapp/app/modules/add_places/binding/add_place_bindings.dart';
import 'package:myapp/app/modules/add_places/views/add_place_view.dart';
import 'package:myapp/app/modules/city_selection/bindings/city_selecyion_binding.dart';
import 'package:myapp/app/modules/city_selection/views/city_selection_view.dart';
import 'package:myapp/app/modules/home/bindings/home_binding.dart';
import 'package:myapp/app/modules/home/view/home_view.dart';
import 'package:myapp/app/modules/place_details/bindings/place_details_bindings.dart';
import 'package:myapp/app/modules/place_details/views/place_detail_view.dart';
import 'package:myapp/app/routes/app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ADD_PLACE;

  static final routes = [
    GetPage(
      name: Routes.CITY_SELECTION,
      page: () => const CitySelectionView(),
      binding: CitySelectionBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PLACE_DETAILS,
      page: () => const PlaceDetailsView(),
      binding: PlaceDetailsBinding(),
    ),
    GetPage(
      name: Routes.ADD_PLACE,
      page: () => const AddPlaceView(),
      binding: AddPlaceBinding(),
    ),
  ];
}
