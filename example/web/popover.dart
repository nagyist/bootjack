import 'package:web/web.dart';
import 'package:dquery/dquery.dart';
import 'package:bootjack/bootjack.dart';

void main() {
  
  $('[data-toggle]').forEach((Element elem) => Popover.wire(elem));
  
}