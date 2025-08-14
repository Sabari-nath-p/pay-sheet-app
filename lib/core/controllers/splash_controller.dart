import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../controllers/update_controller.dart';
import '../../Screens/AuthenticationScreens/AuthenticationScreen.dart';

class SplashController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString loadingText = 'loading'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize Firebase Service
      loadingText.value = 'initializing_firebase'.tr;
      await Get.putAsync(
        () => FirebaseService().onInit().then((_) => FirebaseService()),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize Update Controller
      loadingText.value = 'checking_for_updates'.tr;
      Get.put(UpdateController());

      await Future.delayed(const Duration(milliseconds: 500));

      // App initialization complete
      loadingText.value = 'app_ready'.tr;
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to authentication screen
      _navigateToMain();
    } catch (e) {
      print('Error initializing app: $e');
      // Even if Firebase fails, continue to app
      _navigateToMain();
    }
  }

  void _navigateToMain() {
    isLoading.value = false;

    // Navigate to main app
    Get.offAll(() => AuthenticationScreen());
  }
}
