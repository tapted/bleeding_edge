library pub.pathrep;

import 'dart:async';
import 'dart:html';

import 'package:chrome_gen/chrome_app.dart' as chrome;
import 'pathwrap.dart' as pathwrap;
import 'iowrap.dart' as io;

chrome.DirectoryEntry workingDir;

class PathRep {
  chrome.Entry dirEntry;

  PathRep(chrome.Entry this.dirEntry) {}

  String name() {
    return dirEntry.name;
  }

  String fullPath() {
    return dirEntry.fullPath;
  }

  static Future<PathRep> obtainDirectory() {
    chrome.ChooseEntryOptions options = new chrome.ChooseEntryOptions(
        type: chrome.ChooseEntryType.OPEN_DIRECTORY
    );

    return chrome.fileSystem.chooseEntry(options)
        .then((chrome.ChooseEntryResult result) => new PathRep(result.entry));

      //if (!theEntry) {
      //  output.textContent = 'No Directory selected.';
      //  return;
      //}
  }

  static Future<PathRep> obtainWorkingDirectory() {
    return obtainDirectory().then((PathRep result) {
      // TODO: use local storage to retain access to this file. Something like
      //   chrome.storage.local.set(
      //       {'chosenFile': chrome.fileSystem.retainEntry(theEntry)});
      workingDir = result.dirEntry;

      return result;
    });
  }
}
