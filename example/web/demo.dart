import 'dart:js_interop';

import 'package:web/web.dart';
import 'package:dquery/dquery.dart';
import 'package:bootjack/bootjack.dart';

final List<String> COLORS = [
  ' alert-danger', ' alert-warning', ' alert-success', ' alert-info'
];

void main() {
  
  Bootjack.useDefault(); // use all
  
  final alertPool = document.querySelector('#alert-pool')!;
  var i = 0;
  
  $('#alert-spawn-btn').on('click', (QueryEvent e) {

    alertPool.setHTMLUnsafe('''
      <div class="alert${COLORS[i]} alert-dismissable fade in">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        Oh snap! A new <code>alert</code> spawned.
      </div>
    '''.toJS);
    
    i = (i + 1) % 4;
    
  });
  
  $('#btn').on('click', (QueryEvent e) {
    $('#btn')
    ..toggleClass('btn-info')
    ..toggleClass('btn-danger');
  });
  
}
