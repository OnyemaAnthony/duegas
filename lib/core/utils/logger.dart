import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    errorMethodCount: 8,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);
