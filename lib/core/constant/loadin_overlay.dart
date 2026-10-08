import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyGlobalLoader {
  static final ValueNotifier<bool> isLoading = ValueNotifier(false);
  static final ValueNotifier<String?> loadingMessage = ValueNotifier(null);

  static void show([String? message]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingMessage.value = message;
      isLoading.value = true;
    });
  }

  static void hide() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = false;
      loadingMessage.value = null;
    });
  }
}

class GlobalLoadingOverlay extends StatelessWidget {
  const GlobalLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MyGlobalLoader.isLoading,
      builder: (context, loading, child) {
        if (!loading) return const SizedBox.shrink();

        return Stack(
          children: [
            ModalBarrier(color: Colors.black.withValues(alpha: 0.7), dismissible: false),
            Center(
              child: ValueListenableBuilder<String?>(
                valueListenable: MyGlobalLoader.loadingMessage,
                builder: (context, message, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.4), shape: BoxShape.circle),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Lottie.asset('assets/lottie/loading_2.json', width: 80, height: 80, fit: BoxFit.fill),
                          ],
                        ),
                      ),
                      if (message != null && message.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            message,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
