import 'package:matrix/matrix.dart';

class EmailValidation {
  static EmailValidation? _instance;

  Client? client;
  bool? isEmailVerified;

  EmailValidation._(this.client);

  factory EmailValidation(Client? client) {
    return _instance ??= EmailValidation._(client);
  }

  Future<void> init() async {
    Logs().i('Initializing EmailValidation');
    if (client == null) return;
    final account3PIDs = await client!.getAccount3PIDs();
    isEmailVerified = account3PIDs?.any((e) => e.medium == ThirdPartyIdentifierMedium.email);
    Logs().i('isEmailVerified: $isEmailVerified');
  }
}
