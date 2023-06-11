enum AppError {
  NotFound,
  // some errors codes
}

class MyError {
  final AppError key;
  final String? message;

  const MyError({
    required this.key, 
    this.message,
  });
}