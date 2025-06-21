// lib/modules/auth/login_screen.dart
import 'package:bill_split/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Connect Wallet")),
      body: Center(
        child: Obx(() {
          final address = controller.walletAddress.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              address == null
                  ? ElevatedButton.icon(
                    icon: const Icon(Icons.account_balance_wallet),
                    label: const Text("Connect Phantom Wallet"),
                    onPressed: controller.connectWallet,
                  )
                  : Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      const Text("Connected Wallet:"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          address,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.disconnectWallet,
                        child: const Text("Disconnect Wallet"),
                      ),
                    ],
                  ),
            ],
          );
        }),
      ),
    );
  }
}
