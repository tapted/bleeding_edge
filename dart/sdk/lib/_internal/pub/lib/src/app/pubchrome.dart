// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;

import '../entrypoint.dart';
import '../io.dart' show FileSystem;
import '../path_rep.dart';
import '../wrap/system_cache_wrap.dart';

void main() {
  new PubChrome();
}

class PubChrome {

  var commands;
  Entrypoint entrypoint;

  PubChrome() {
    html.querySelector("#get_button")
      ..onClick.listen(runGet);

    var workingDir;

    FileSystem.obtainWorkingDirectory().then((dir) {
      workingDir = dir;
      print("Loaded working directory $dir");
      return SystemCache.withSources(dir.path.join("cache"));
    }).then((cache) {
      entrypoint = new Entrypoint(workingDir.path, cache);
    });
  }

  void runGet(html.MouseEvent event) {
    var logtext = html.querySelector("#get");
    entrypoint.acquireDependencies()
        .then((_) => logtext.innerHTML += "Got dependencies!");
  }
}
