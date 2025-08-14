import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_controller.dart';

class ForceUpdateWrapper extends StatefulWidget {
  final Widget child;

  const ForceUpdateWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<ForceUpdateWrapper> createState() => _ForceUpdateWrapperState();
}

class _ForceUpdateWrapperState extends State<ForceUpdateWrapper>
    with WidgetsBindingObserver {
  UpdateController? _updateController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Try to get the update controller if it exists
    try {
      _updateController = Get.find<UpdateController>();

      // Ensure force update dialog is shown when this screen loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateController?.ensureForceUpdateDialog();
      });
    } catch (e) {
      // Update controller not found, which is fine
      print('UpdateController not found: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, ensure force update dialog is shown
      _updateController?.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation if force update is required
        if (_updateController?.isForceUpdateBlocking == true) {
          _updateController?.ensureForceUpdateDialog();
          return false;
        }
        return true;
      },
      child: widget.child,
    );
  }
}
