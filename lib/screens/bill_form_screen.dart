import 'package:billgenerate/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import '../models/bill_model.dart';

class BillFormScreen extends StatefulWidget {
  const BillFormScreen({super.key});

  @override
  State<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends State<BillFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<BillItem> _items = [];

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        onItemAdded: (item) {
          setState(() {
            _items.add(item);
          });
        },
      ),
    );
  }

  double _calculateTotal() {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  void _proceedToPayment() {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            customerName: _customerNameController.text,
            address: _addressController.text,
            phoneNumber: _phoneController.text,
            items: _items,
            totalAmount: _calculateTotal(),
          ),
        ),
      );
    }
  }

  void _loadTestData() {
    setState(() {
      _customerNameController.text = 'John Doe';
      _addressController.text = '123 Main Street, City, State 12345';
      _phoneController.text = '(555) 123-4567';
      _items.clear();
      _items.addAll([
        BillItem(itemName: 'Laptop', quantity: 1, price: 999.99),
        BillItem(itemName: 'Wireless Mouse', quantity: 2, price: 29.99),
        BillItem(itemName: 'USB-C Cable', quantity: 3, price: 15.99),
      ]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test data loaded successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Form'),
        actions: [
          IconButton(
            onPressed: _loadTestData,
            icon: const Icon(Icons.data_array),
            tooltip: 'Load Test Data',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter customer name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.itemName),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text('\$${item.total.toStringAsFixed(2)}'),
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
              const SizedBox(height: 24),
              Text(
                'Total Amount: \$${_calculateTotal().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _proceedToPayment,
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddItemDialog extends StatefulWidget {
  final Function(BillItem) onItemAdded;

  const AddItemDialog({super.key, required this.onItemAdded});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _itemNameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_itemNameController.text.isEmpty ||
                _quantityController.text.isEmpty ||
                _priceController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill all fields'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final quantity = int.tryParse(_quantityController.text);
            final price = double.tryParse(_priceController.text);

            if (quantity == null || quantity <= 0 || price == null || price <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter valid quantity and price'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final item = BillItem(
              itemName: _itemNameController.text,
              quantity: quantity,
              price: price,
            );
            widget.onItemAdded(item);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}