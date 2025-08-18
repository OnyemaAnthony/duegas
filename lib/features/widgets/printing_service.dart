import 'package:duegas/features/app/model/sales_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingService {
  Future<void> printReceipt(SalesModel sale) async {
    final doc = pw.Document();
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_NG', symbol: '₦');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // --- Header ---
                pw.Text(
                  'Sales Receipt',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 12),
                pw.Text("Due Gas Limited",
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    "Opposite water board afara umuahia, Abia State, Nigeria",
                    style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Tel: +234 708 132 8997',
                    style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 12),

                pw.Divider(height: 1, borderStyle: pw.BorderStyle.dashed),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Receipt No:',
                          style: const pw.TextStyle(fontSize: 9)),
                      pw.Text(sale.id!.substring(0, 8).toUpperCase(),
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Date:', style: const pw.TextStyle(fontSize: 9)),
                    pw.Text(
                        DateFormat('dd MMM yyyy, hh:mm a')
                            .format(sale.createdAt!),
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sold by:', style: const pw.TextStyle(fontSize: 9)),
                    pw.Text(sale.sellerName!,
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.Divider(height: 1, borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 16),

                _buildTableHeader(),
                pw.Divider(thickness: 1),
                _buildTableRow(
                  'Gas Sale',
                  '${sale.quantityInKg} Kg',
                  currencyFormatter.format(sale.priceInNaira),
                ),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 12),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Total: ',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      currencyFormatter.format(sale.priceInNaira),
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Text('Thanks for your patronage!',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                pw.SizedBox(height: 8),

                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: sale.id!,
                  width: 50,
                  height: 50,
                ),
                pw.SizedBox(height: 4),
                pw.Text('Scan to verify',
                    style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  pw.Widget _buildTableHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
            flex: 3,
            child: pw.Text('Item',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        pw.Expanded(
            flex: 2,
            child: pw.Text('Qty',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        pw.Expanded(
            flex: 2,
            child: pw.Text('Price',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      ],
    );
  }

  pw.Widget _buildTableRow(String item, String qty, String price) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(flex: 3, child: pw.Text(item)),
          pw.Expanded(
              flex: 2, child: pw.Text(qty, textAlign: pw.TextAlign.center)),
          pw.Expanded(
              flex: 2, child: pw.Text(price, textAlign: pw.TextAlign.right)),
        ],
      ),
    );
  }
}
