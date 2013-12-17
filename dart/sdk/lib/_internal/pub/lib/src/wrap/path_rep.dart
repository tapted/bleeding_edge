import 'dart:async';
import 'dart:html';

import 'package:chrome_gen/chrome_app.dart' as chrome;

class PathRep {
  Entry dirEntry;

  PathRep() {}

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
        .then((chrome.ChooseEntryResult result) {
          PathRep entry = new PathRep();
          entry.dirEntry = result.entry;
          return entry;
        });

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
      return result;
    });
  }
}
