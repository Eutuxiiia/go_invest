import 'package:flutter/material.dart';

class InvestPopup extends StatelessWidget {
  final Function(double, String, String, String, String) onInvest;

  InvestPopup({required this.onInvest});

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Invest in Startup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Investment Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _expiryMonthController,
              decoration: const InputDecoration(labelText: 'Expiry Month (MM)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _expiryYearController,
              decoration: const InputDecoration(labelText: 'Expiry Year (YY)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cvcController,
              decoration: const InputDecoration(labelText: 'CVC'),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              final cardNumber = _cardNumberController.text;
              final expiryMonth = _expiryMonthController.text;
              final expiryYear = _expiryYearController.text;
              final cvc = _cvcController.text;

              onInvest(amount, cardNumber, expiryMonth, expiryYear, cvc);
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
