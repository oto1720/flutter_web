import 'package:flutter/rendering.dart';

extension Breakpoints on BoxConstraints {
  bool get isDesktop => maxWidth >= 900;
}
