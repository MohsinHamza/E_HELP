import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LoggerServices extends GetxService {
  static LoggerServices get find => Get.find();
  Logger logger = Logger();

  logError(dynamic val) {
    logger.e(val);
  }

  log(dynamic val) {
    logger.i(val);
  }

  logD(dynamic val) {
    logger.d(val);
  }
}