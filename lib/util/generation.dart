import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/util/formatters.dart';

/// Generates a schedule PDF for the given department and week.
///
/// - [currentDepartment]: includes name and list of Employee (with IDs).
/// - [weekStart], [weekEnd]: define the week period.
/// - [displayRecords]: all records for that department & week.
/// - [weekDays]: list of 7 consecutive DateTime objects starting from weekStart.
///
/// Returns the full path to the saved PDF file.
Future<String> generateSchedulePdf({
  required Department currentDepartment,
  required DateTime weekStart,
  required DateTime weekEnd,
  required List<DisplayRecord> displayRecords,
  required List<DateTime> weekDays,
  required DateFormat timeFormatter,
  required double maxHours,
  required double bfh,
  required double bdh,
}) async {
  final pdf = pw.Document();
  final dateFmt = DateFormat('MMM d');
  final dateFullFmt = DateFormat('MMM d');

  // Build a lookup: employeeId -> fullname
  final empNames = {
    for (var e in currentDepartment.employees) e.id: e.getFullName(),
  };

  // Records grouped by employee and day
  final Map<String, Map<DateTime, List<DisplayRecord>>> byEmpDay = {};
  for (var rec in displayRecords) {
    final empId = rec.employeeId;
    final day = DateTime(
      rec.record.start.year,
      rec.record.start.month,
      rec.record.start.day,
    );
    byEmpDay.putIfAbsent(empId, () => {});
    byEmpDay[empId]!.putIfAbsent(day, () => []);
    byEmpDay[empId]![day]!.add(rec);
  }

  // Daily totals and employee totals
  final Map<DateTime, double> dailyTotals = {for (var d in weekDays) d: 0.0};
  double weekTotal = 0.0;

  // Define styles with reduced font sizes
  final headerStyle = pw.TextStyle(
    fontSize: 10, // Reduced from default
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.white,
  );
  final cellStyle = pw.TextStyle(fontSize: 5); // Reduced from 10

  // Helper function to build cells
  pw.Widget buildCell(
    String text, {
    pw.TextStyle? style,
    pw.TextAlign textAlign = pw.TextAlign.left,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.all(4),
      child: pw.Text(text, style: style, textAlign: textAlign),
    );
  }

  // Build table rows
  List<pw.TableRow> tableRows = [
    // First header row: Employee (rowspan=2), Weekday names, Total (rowspan=2)
    pw.TableRow(
      children: [
        pw.Container(
          decoration: pw.BoxDecoration(color: PdfColors.blue),
          child: pw.Center(child: pw.Text('Employee', style: headerStyle)),
          width: 100,
        ),
        ...weekDays.map(
          (d) => pw.Container(
            decoration: pw.BoxDecoration(color: PdfColors.blue),
            child: pw.Center(
              child: pw.Text(DateFormat('EEEE').format(d), style: headerStyle),
            ),
          ),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(color: PdfColors.blue),
          child: pw.Center(child: pw.Text('Total', style: headerStyle)),
          width: 100,
        ),
      ],
    ),
    // Second header row: Dates for each day
    pw.TableRow(
      children: [
        pw.Container(),
        ...weekDays.map(
          (d) => pw.Container(
            decoration: pw.BoxDecoration(color: PdfColors.blue),
            child: pw.Center(
              child: pw.Text(dateFmt.format(d), style: headerStyle),
            ),
          ),
        ),
      ],
    ),
  ];

  // Data rows for each employee
  empNames.forEach((empId, fullname) {
    final row = <pw.Widget>[
      buildCell(fullname, style: cellStyle, textAlign: pw.TextAlign.left),
    ];
    double empTotal = 0.0;

    for (var day in weekDays) {
      final recs = byEmpDay[empId]?[day] ?? [];
      final cellText = recs
          .map((r) {
            final start = timeFormatter.format(r.record.start);
            final end = timeFormatter.format(r.record.end);
            final rd = regulatedDuration(r.record.duration, bfh, bdh);
            final dur = rd.inHours + (rd.inMinutes % 60) / 60;
            dailyTotals[day] = dailyTotals[day]! + dur;
            empTotal += dur;
            return '$start - $end';
          })
          .join('\n');
      row.add(
        buildCell(cellText, style: cellStyle, textAlign: pw.TextAlign.center),
      );
    }

    row.add(
      buildCell(
        empTotal % 1 == 0
            ? empTotal.toInt().toString()
            : empTotal.toStringAsFixed(1),
        style: cellStyle,
        textAlign: pw.TextAlign.right,
      ),
    );
    tableRows.add(pw.TableRow(children: row));
    weekTotal += empTotal;
  });

  // Daily totals row
  final totalRow = <pw.Widget>[
    buildCell('Daily Totals', style: cellStyle, textAlign: pw.TextAlign.left),
  ];
  for (var day in weekDays) {
    totalRow.add(
      buildCell(
        dailyTotals[day]! % 1 == 0
            ? dailyTotals[day]!.toInt().toString()
            : dailyTotals[day]!.toStringAsFixed(1),
        style: cellStyle,
        textAlign: pw.TextAlign.right,
      ),
    );
  }
  totalRow.add(
    buildCell(
      "${weekTotal % 1 == 0 ? weekTotal.toInt().toString() : weekTotal.toStringAsFixed(1)} / ${maxHours % 1 == 0 ? maxHours.toInt().toString() : maxHours.toStringAsFixed(1)}",
      style: cellStyle,
      textAlign: pw.TextAlign.right,
    ),
  );
  tableRows.add(pw.TableRow(children: totalRow));

  // Build PDF with landscape orientation
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter.landscape,
      margin: pw.EdgeInsets.all(24),
      header:
          (_) => pw.Center(
            child: pw.Text(
              '${currentDepartment.name} Schedule - '
              '${dateFullFmt.format(weekStart)} / '
              '${dateFullFmt.format(weekEnd)} ${weekStart.year}',
              style: pw.TextStyle(fontSize: 16), // Reduced from 18
            ),
          ),
      footer:
          (ctx) => pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
              style: pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey,
              ), // Reduced from 10
            ),
          ),
      build:
          (ctx) => [
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(2), // Employee column wider
                for (var i = 1; i <= 7; i++)
                  i: pw.FlexColumnWidth(1), // Day columns
                8: pw.FlexColumnWidth(1), // Total column
              },
              children: tableRows,
            ),
          ],
    ),
  );

  // Save PDF to appropriate folder
  final baseDir =
      Platform.isAndroid || Platform.isIOS
          ? await getExternalStorageDirectory()
          : await getDownloadsDirectory();
  final targetDir = Directory('${baseDir!.path}/schedderum/pdf');
  if (!await targetDir.exists()) await targetDir.create(recursive: true);

  final filename =
      '${currentDepartment.name}_schedule_${DateFormat('yyyyMMdd').format(weekStart)}.pdf';
  final file = File('${targetDir.path}/$filename');
  final pdfBytes = await pdf.save();
  await file.writeAsBytes(pdfBytes, flush: true);

  return file.path;
}

/// Converts your schedule data into CSV rows and writes to file.
Future<String> generateScheduleCsv({
  required Department currentDepartment,
  required DateTime weekStart,
  required DateTime weekEnd,
  required List<DisplayRecord> displayRecords,
  required List<DateTime> weekDays,
  required DateFormat timeFormatter,
  required double maxHours,
  required double bfh,
  required double bdh,
}) async {
  final dateFmt = DateFormat('EEE MMM d'); // e.g. Mon Jun 5
  final empNames = {
    for (var e in currentDepartment.employees) e.id: e.getFullName(),
  };

  // Group records by employee and day
  final Map<String, Map<DateTime, List<DisplayRecord>>> byEmpDay = {};
  for (var rec in displayRecords) {
    final empId = rec.employeeId;
    final day = DateTime(
      rec.record.start.year,
      rec.record.start.month,
      rec.record.start.day,
    );
    byEmpDay.putIfAbsent(empId, () => {});
    byEmpDay[empId]!.putIfAbsent(day, () => []);
    byEmpDay[empId]![day]!.add(rec);
  }

  final dailyTotals = {for (var d in weekDays) d: 0.0};
  double weekTotal = 0.0;
  final buffer = StringBuffer();

  // HEADER rows
  buffer.writeln(
    [
      'Employee',
      for (var d in weekDays)
        '"${DateFormat('EEEE').format(d)} (${dateFmt.format(d)})"',
      'TotalHours',
    ].join(','),
  );

  // DATA ROWS per employee
  empNames.forEach((empId, fullname) {
    double empTotal = 0.0;
    final row = <String>[];
    row.add('"$fullname"');

    for (var day in weekDays) {
      final recs =
          (byEmpDay[empId]?[day] ?? [])
            ..sort((a, b) => a.record.start.compareTo(b.record.start));
      final cell = recs
          .map((r) {
            final inStr = timeFormatter.format(r.record.start);
            final outStr = timeFormatter.format(r.record.end);
            final rd = regulatedDuration(r.record.duration, bfh, bdh);
            final dur = rd.inMinutes / 60.0;
            empTotal += dur;
            dailyTotals[day] = dailyTotals[day]! + dur;
            weekTotal += dur;
            return '$inStr - $outStr';
          })
          .join(' | ');
      row.add('"$cell"');
    }

    row.add(
      empTotal % 1 == 0
          ? empTotal.toInt().toString()
          : empTotal.toStringAsFixed(1),
    );
    buffer.writeln(row.join(','));
  });

  // TOTAL ROW
  final totalRow = <String>[];
  totalRow.add('"Daily Totals"');
  for (var day in weekDays) {
    final dTotal = dailyTotals[day]!;
    totalRow.add(
      dTotal % 1 == 0 ? dTotal.toInt().toString() : dTotal.toStringAsFixed(1),
    );
  }
  totalRow.add(
    weekTotal % 1 == 0
        ? weekTotal.toInt().toString()
        : weekTotal.toStringAsFixed(1),
  );
  buffer.writeln(totalRow.join(','));

  // WRITE TO FILE
  final baseDir =
      Platform.isAndroid || Platform.isIOS
          ? await getExternalStorageDirectory()
          : await getDownloadsDirectory();
  final targetDir = Directory('${baseDir!.path}/schedderum/csv');
  if (!await targetDir.exists()) await targetDir.create(recursive: true);

  final filename =
      '${currentDepartment.name}_schedule_${DateFormat('yyyyMMdd').format(weekStart)}.csv';
  final file = File('${targetDir.path}/$filename');
  await file.writeAsString(buffer.toString(), flush: true);

  return file.path;
}
