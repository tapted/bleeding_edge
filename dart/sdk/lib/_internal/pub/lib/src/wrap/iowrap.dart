import 'dart:convert';

class FileSystemEntity {

}

class File {
  File(String path) {

  }
  bool existsSync() {
    return false;
  }
  String readAsStringSync({Encoding encoding: UTF8}) {
    return "";
  }
  void writeAsStringSync(String s) {

  }
  void deleteSync() {
  }
}

class Directory {
  Directory(String path) {

  }

  bool existsSync() {
    return false;
  }

  List<FileSystemEntity> listSync({bool recursive: false,
                                   bool followLinks: true}) {
    return [];
  }
  void createSync({bool recursive: false}) {
  }
  void deleteSync({bool recursive: false}) {
  }
}

class Link {
  Link(String path) {

  }
  bool existsSync () {
    return false;
  }
  String targetSync() {
    return "";
  }
  void createSync(String target, {bool recursive: false}) {

  }
  void deleteSync({bool recursive: false}) {
  }
}

class Platform {
  static String get executable => "";
  static String get operatingSystem => "";
  static Map<String, String> get environment => {};
}

class IOSink {
  void write(Object obj) {
    print(obj);
  }
  void writeln([Object obj = ""]) {
    write(obj);
    write("\n");
  }
}

IOSink _stdout;
IOSink _stderr;

IOSink get stdout {
  if (_stdout == null) {
    _stdout = new IOSink();
  }
  return _stdout;
}

IOSink get stderr {
  if (_stderr == null) {
    _stderr = new IOSink();
  }
  return _stderr;
}

class StdioType {
  static const StdioType TERMINAL = const StdioType._("terminal");
  static const StdioType PIPE = const StdioType._("pipe");
  static const StdioType FILE = const StdioType._("file");
  static const StdioType OTHER = const StdioType._("other");
  final String name;
  const StdioType._(String this.name);
  String toString() => "StdioType: $name";
}

StdioType stdioType(object) {
  return StdioType.PIPE;
}
