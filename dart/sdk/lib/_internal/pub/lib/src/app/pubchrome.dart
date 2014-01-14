// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;

import '../entrypoint.dart';
import '../io.dart' show FileSystem;
import '../log.dart' as log;
import '../path_rep.dart';
import '../wrap/system_cache_wrap.dart';

void main() {
  new PubChrome();
}

class PubChrome {

  var commands;
  html.DivElement logtext;
  Entrypoint entrypoint;

  PubChrome() {
    html.querySelector("#get_button")
        ..onClick.listen(runGet);

    logtext = html.querySelector("#logtext");
    log.showAll();
    log.addLoggerFunction(logToWindow);

    var workingDir;
    FileSystem.obtainWorkingDirectory().then((dir) {
      workingDir = dir;
      return SystemCache.withSources(dir.path.join("cache"));
    }).then((cache) {
      entrypoint = new Entrypoint(workingDir.path, cache);
    });
  }

  void runGet(html.MouseEvent event) {
    entrypoint.acquireDependencies()
        .then((_) => log.fine("Got dependencies!"));
  }

  void logToWindow(String line, String level) {
    var line_div = new html.DivElement();
    line_div.text = line;
    line_div.classes.add("log_$level");
    logtext.children.add(line_div);
  }
}
