enum Language { en, tk, ru }
enum Status { initial,onProgress, completed, warning, failed }
enum LicenseStatus { initial,registered, checking, cantCheck, unregisteredOnline, unregisteredOffline }
enum Device{mobile,tablet,desktop}
enum Orient{portrait,landscape}
enum DbConnectionMode{
  onlineMode(1),
  offlineMode(2);

  const DbConnectionMode(this.value);
  final int value;
}