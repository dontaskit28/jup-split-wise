import 'dart:math';

import 'package:bill_split/controllers/group_controller.dart';
import 'package:bill_split/models/coins_data.dart';
import 'package:bill_split/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayExpenseScreen extends StatefulWidget {
  final Expense expense;

  const PayExpenseScreen({super.key, required this.expense});

  @override
  State<PayExpenseScreen> createState() => _PayExpenseScreenState();
}

class _PayExpenseScreenState extends State<PayExpenseScreen> {
  final groupController = Get.find<GroupController>();

  Token? selectedToken;
  String? quotedAmount;
  bool isFetchingQuote = false;

  @override
  void initState() {
    super.initState();
    selectedToken = getLocalTokens.firstWhereOrNull((t) => t.symbol == 'SOL');
    _getQuote();
  }

  Future<void> _getQuote() async {
    if (selectedToken == null) return;

    setState(() => isFetchingQuote = true);
    try {
      Token token = getLocalTokens.firstWhere(
        (t) => t.symbol == widget.expense.currency,
      );
      setState(() {
        quotedAmount = null;
      });
      final quote = await groupController.getQuote(
        amount:
            (widget.expense.totalAmount / widget.expense.splits.length) *
            pow(10, token.decimals),
        inputmint: selectedToken!.address,
        outputMint: token.address,
      );
      setState(
        () =>
            quotedAmount = (quote / pow(10, selectedToken!.decimals))
                .toStringAsPrecision(4),
      );
    } catch (e) {
      Get.snackbar("Quote Error", "Unable to fetch quote: $e");
    } finally {
      setState(() => isFetchingQuote = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay Your Share")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile("Title", widget.expense.title),
              const SizedBox(height: 8),
              _buildInfoTile(
                "You Owe",
                "${(widget.expense.totalAmount / (widget.expense.splits.length)).toStringAsPrecision(4)} ${widget.expense.currency}",
              ),
              const SizedBox(height: 20),
              const Text(
                "Choose Token to Pay With",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Token>(
                value: selectedToken,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    getLocalTokens.map((token) {
                      return DropdownMenuItem<Token>(
                        value: token,
                        child: Row(
                          children: [
                            Image.network(
                              token.logoURI,
                              height: 24,
                              width: 24,
                              errorBuilder:
                                  (_, __, ___) => const Icon(Icons.token),
                            ),
                            const SizedBox(width: 8),
                            Text(token.symbol),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  selectedToken = val;
                  _getQuote();
                },
              ),
              const SizedBox(height: 24),
              if (isFetchingQuote)
                const Center(child: CircularProgressIndicator())
              else if (quotedAmount != null)
                Text(
                  "You need to pay ~ $quotedAmount ${selectedToken!.symbol}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("Pay Now"),
                  onPressed:
                      quotedAmount != null
                          ? () async {
                            await groupController.getPaymentTransaction(
                              widget.expense.paidByWallet,
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}
