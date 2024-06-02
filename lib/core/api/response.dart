class Response<T> {
  final String result;
  final T? data;
  final String? message;

  Response(this.result, {this.data, this.message});
}
