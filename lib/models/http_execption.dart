class HttpExeception implements Exception {
  final String message;

  HttpExeception(this.message);

  @override
  String toString() {
    // TODO: implement toString
    //return super.toString();
    return this.message;
  }
}
