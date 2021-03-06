// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:scheduled_test/scheduled_test.dart';

import '../descriptor.dart' as d;
import '../test_pub.dart';

main() {
  initConfig();

  integration("compiles Dart entrypoints in web/ to JS", () {
    // Dart2js can take a long time to compile dart code, so we increase the
    // timeout to cope with that.
    currentSchedule.timeout *= 3;

    d.dir(appPath, [
      d.appPubspec(),
      d.dir('web', [
        d.file('file.dart', 'void main() => print("hello");'),
        d.file('lib.dart', 'void foo() => print("hello");'),
        d.dir('subdir', [
          d.file('subfile.dart', 'void main() => print("ping");')
        ])
      ])
    ]).create();

    schedulePub(args: ["build"],
        output: new RegExp(r"Built 6 files!"));

    d.dir(appPath, [
      d.dir('build', [
        d.dir('web', [
          d.matcherFile('file.dart.js', isNot(isEmpty)),
          d.matcherFile('file.dart.precompiled.js', isNot(isEmpty)),
          d.matcherFile('file.dart.js.map', isNot(isEmpty)),
          d.nothing('file.dart'),
          d.nothing('lib.dart'),
          d.dir('subdir', [
            d.matcherFile('subfile.dart.js', isNot(isEmpty)),
            d.matcherFile('subfile.dart.precompiled.js', isNot(isEmpty)),
            d.matcherFile('subfile.dart.js.map', isNot(isEmpty)),
            d.nothing('subfile.dart')
          ])
        ])
      ])
    ]).validate();
  });
}
