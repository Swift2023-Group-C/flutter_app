import 'package:dotto/importer.dart';

class SettingsLicenseScreen extends StatelessWidget {
  const SettingsLicenseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: 'Dotto',
      applicationIcon: Image.asset(
        'assets/dotto_icon.png',
        width: 150,
      ),
    );
  }
}
