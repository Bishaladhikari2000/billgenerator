import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/bill_model.dart';

class PaymentScreen extends StatefulWidget {
  final String customerName;
  final String address;
  final String phoneNumber;
  final List<BillItem> items;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.customerName,
    required this.address,
    required this.phoneNumber,
    required this.items,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Cash';
  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'UPI',
    'Bank Transfer',
  ];

  Future<void> _generateAndPrintBill() async {
    try {
      // Validate input parameters
      if (_selectedPaymentMethod.isEmpty) {
        throw Exception('Payment method not selected');
      }

      if (widget.items.isEmpty) {
        throw Exception('No items in the bill');
      }

      if (widget.totalAmount <= 0) {
        throw Exception('Invalid total amount');
      }
      final bill = BillModel(
        customerName: widget.customerName,
        address: widget.address,
        phoneNumber: widget.phoneNumber,
        items: widget.items,
        totalAmount: widget.totalAmount,
        paymentMethod: _selectedPaymentMethod,
        billDate: DateTime.now(),
      );

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build:
              (context) => pw.Container(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Bill To:',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(bill.customerName),
                            pw.Text(bill.address),
                            pw.Text(bill.phoneNumber),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Date: ${bill.billDate.toString().split(' ')[0]}',
                            ),
                            pw.Text(
                              'Invoice #: ${DateTime.now().millisecondsSinceEpoch}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 30),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.5),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3),
                        1: const pw.FlexColumnWidth(1),
                        2: const pw.FlexColumnWidth(2),
                        3: const pw.FlexColumnWidth(2),
                      },
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                'Item',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                'Qty',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                'Price',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                'Total',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...bill.items.map(
                          (item) => pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(item.itemName),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(item.quantity.toString()),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  '${item.price.toStringAsFixed(2)}',
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  '${item.total.toStringAsFixed(2)}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Total Amount: ${bill.totalAmount.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text('Payment Method: ${bill.paymentMethod}'),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 40),
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Text(
                        'Thank you for your business!',
                        style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      );

      final pdfBytes = await pdf.save();

      // Show preview dialog
      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Bill Preview'),
              content: SizedBox(
                width: double.maxFinite,
                child: PdfPreview(
                  build: (format) => pdfBytes,
                  allowPrinting: false,
                  allowSharing: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  maxPageWidth: 700,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Printing.sharePdf(
                      bytes: pdfBytes,
                      filename:
                          'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bill generated successfully!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Print/Share'),
                ),
              ],
            ),
      );
    } catch (e) {
      String errorMessage;

      if (e.toString().contains('Payment method not selected')) {
        errorMessage = 'Please select a payment method';
      } else if (e.toString().contains('No items in the bill')) {
        errorMessage = 'Cannot generate bill without items';
      } else if (e.toString().contains('Invalid total amount')) {
        errorMessage = 'Total amount must be greater than zero';
      } else {
        errorMessage = 'Error generating PDF document. Please try again.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              _paymentMethods.length,
              (index) => RadioListTile<String>(
                title: Text(_paymentMethods[index]),
                value: _paymentMethods[index],
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateAndPrintBill,
              child: const Text('Generate & Print Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
