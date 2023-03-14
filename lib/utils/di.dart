import 'package:game2248/data/datasources/audio_source_impl.dart';
import 'package:game2248/data/datasources/settings_source_shared_preferences.dart';
import 'package:game2248/data/repositories/settings_repository_impl.dart';
import 'package:game2248/domain/datasources/audio_source.dart';
import 'package:game2248/domain/datasources/settings_source.dart';
import 'package:game2248/domain/repositories/settings_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> setupGetIt() async {
  final settingsSource = SettingsSourceSharedPreferences();
  await settingsSource.initialize;

  final settingsRepository = SettingsRepositoryImpl(settingsDatasource: settingsSource);

  GetIt.I.registerSingleton<SettingsSource>(settingsSource);
  GetIt.I.registerSingleton<SettingsRepository>(settingsRepository);
  GetIt.I.registerSingleton<AudioSource>(AudioSourceImpl(settingsRepository: settingsRepository));
}
