// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import '../entrypoint.dart';
import '../wrap/path_rep.dart';
import '../wrap/system_cache.dart';

void main() {
  new PubChrome();
}

class PubChrome {

  var commands;
  Entrypoint entrypoint;

  PubChrome() {
    querySelector("#get_button")
      ..onClick.listen(runGet);
    SystemCache cache = new SystemCache();
    PathRep.obtainWorkingDirectory().then((pathRep){
      print("Loading " + pathRep.fullPath());
      entrypoint = new Entrypoint(pathRep, cache);
    });
  }

  void runGet(MouseEvent event) {
    var logtext = querySelector("#get");
    entrypoint.acquireDependencies()
        .then((_) => logtext.innerHTML += "Got dependencies!");
  }
}
