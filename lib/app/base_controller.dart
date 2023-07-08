import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/// Represents the state of the view
enum ViewState { Idle, Busy }

class BaseController extends GetxController {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state = viewState;
      update();
    });
  }

}