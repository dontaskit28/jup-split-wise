import 'package:bill_split/controllers/auth_controller.dart';
import 'package:bill_split/controllers/group_controller.dart';
import 'package:bill_split/models/coins_data.dart';
import 'package:bill_split/models/expense_model.dart';
import 'package:bill_split/models/split_model.dart';
import 'package:bill_split/screens/group_info_screen.dart';
import 'package:bill_split/screens/pay_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroupController>();
    final authController = Get.find<AuthController>();
    final group = controller.getGroupById(groupId);

    bool isDue(Expense expense) {
      final currentUser = authController.walletAddress.value;
      SplitModel? split = expense.splits.firstWhereOrNull(
        (split) => split.walletAddress == currentUser,
      );
      return split != null && !split.isPaid;
    }

    if (group == null) {
      return const Scaffold(body: Center(child: Text("Group not found")));
    }

    controller.getGroupExpenses(groupId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.groups),
            const SizedBox(width: 8),
            Text(group.name),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Get.to(GroupInfoScreen(groupId: groupId));
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isFetchingExpenses.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.expenses.isEmpty) {
          return const Center(
            child: Text("No expenses yet. Create one to get started."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.expenses.length,
          itemBuilder: (_, index) {
            final expense = controller.expenses[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Get.to(() => PayExpenseScreen(expense: expense));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            expense.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM').format(expense.createdAt),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Paid by & Amount Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Paid by: ${expense.paidByWallet}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            "${expense.totalAmount.toStringAsFixed(2)} ${expense.currency}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Amount owed by current user, if any
                      if (isDue(expense))
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                "Your share: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${(expense.totalAmount / expense.splits.length).toStringAsFixed(2)} ${expense.currency}",
                                style: TextStyle(
                                  color:
                                      !isDue(expense)
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCreateExpenseDialog(
            context: context,
            groupId: group.id,
            paidByWallet: authController.walletAddress.value!,
            controller: controller,
            onCreate: ({
              required title,
              required amount,
              required currency,
            }) async {
              await controller.createExpense(
                groupId: group.id,
                title: title,
                amount: amount,
                currency: currency,
              );
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Expense"),
      ),
    );
  }
}

void showCreateExpenseDialog({
  required BuildContext context,
  required String groupId,
  required String paidByWallet,
  required GroupController controller,
  required Future<void> Function({
    required String title,
    required double amount,
    required String currency,
  })
  onCreate,
}) {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final isLoading = false.obs;

  showDialog(
    context: context,
    builder:
        (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(() {
                final selectedToken = controller.selectedToken.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create Expense",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: "Amount",
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Currency",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Token>(
                          value: selectedToken,
                          isExpanded: true,
                          items:
                              getLocalTokens.map((token) {
                                return DropdownMenuItem<Token>(
                                  value: token,
                                  child: Row(
                                    children: [
                                      Image.network(
                                        token.logoURI,
                                        width: 24,
                                        height: 24,
                                        errorBuilder:
                                            (_, __, ___) =>
                                                const Icon(Icons.error),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(token.symbol),
                                    ],
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            controller.selectedToken.value = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon:
                              isLoading.value
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Icon(Icons.add),
                          label: Text(
                            isLoading.value ? "Creating..." : "Create",
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed:
                              isLoading.value
                                  ? null
                                  : () async {
                                    final title = titleController.text.trim();
                                    final amount = double.tryParse(
                                      amountController.text.trim(),
                                    );

                                    if (title.isEmpty ||
                                        amount == null ||
                                        selectedToken == null) {
                                      Get.snackbar(
                                        "Invalid Input",
                                        "Please fill in all fields correctly",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    try {
                                      isLoading.value = true;
                                      await onCreate(
                                        title: title,
                                        amount: amount,
                                        currency: selectedToken.symbol,
                                      );
                                      Get.back();
                                    } catch (e) {
                                      Get.snackbar(
                                        "Error",
                                        "Failed to create expense: $e",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    } finally {
                                      isLoading.value = false;
                                    }
                                  },
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
  );
}
