// lib/printing_service.dart

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingService {
  Future<void> printReceipt() async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Sales Receipt',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text("Due gas limited",
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Text("Abia state", style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Tel: 090388943094',
                    style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Receipt No: 101',
                        style: const pw.TextStyle(fontSize: 9)),
                    // pw.Text(
                    //     '${data.dateTime.year}-${data.dateTime.month}-${data.dateTime.day} ${data.dateTime.hour}:${data.dateTime.minute}',
                    //     style: const pw.TextStyle(fontSize: 9)
                    // ),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),

                if (true)
                  pw.Container(
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(), color: PdfColors.yellow100),
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('First-Time Customer',
                          style: const pw.TextStyle(fontSize: 9))),

                pw.SizedBox(height: 15),

                // Table Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                        flex: 3,
                        child: pw.Text('Item',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text('Qty',
                            textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Expanded(
                        flex: 2,
                        child: pw.Text('Price',
                            textAlign: pw.TextAlign.right,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                pw.Divider(thickness: 1.5),

                // Table Row
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(flex: 3, child: pw.Text('Product Sale')),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text(20.toString(),
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        flex: 2,
                        child: pw.Text('1000', textAlign: pw.TextAlign.right)),
                  ],
                ),
                pw.Divider(thickness: 1.5),
                pw.SizedBox(height: 10),

                // Total
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Total: ',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text('1000',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Thanks for the patronage!',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ],
            ),
          );
        },
      ),
    );

    // This is the important part for web.
    // It will open the browser's print dialog.
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }
}
