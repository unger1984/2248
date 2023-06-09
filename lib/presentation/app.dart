import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game2248/domain/datasources/audio_source.dart';
import 'package:game2248/domain/repositories/settings_repository.dart';
import 'package:game2248/domain/usecases/locale_use_case.dart';
import 'package:game2248/domain/usecases/sound_use_case.dart';
import 'package:game2248/generated/l10n.dart';
import 'package:game2248/presentation/blocs/locale_bloc.dart';
import 'package:game2248/presentation/blocs/sound_bloc.dart';
import 'package:game2248/presentation/game_2248.dart';
import 'package:get_it/get_it.dart';

@immutable
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final soundBLoC = SoundBLoC(
    soundUseCase: SoundUseCase(
      audioSource: GetIt.I<AudioSource>(),
    ),
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    soundBLoC.close();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBLoC>(
          create: (_) => LocaleBLoC(
            localeUseCase: LocaleUseCase(
              settingsRepository: GetIt.I<SettingsRepository>(),
            ),
          ),
        ),
        BlocProvider<SoundBLoC>.value(value: soundBLoC),
      ],
      child: BlocBuilder<LocaleBLoC, LocaleState>(
        builder: (context, state) => state.map(
          loading: (_) => const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))),
          success: (st) => MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Locale.fromSubtags(languageCode: st.locale),
            supportedLocales: S.delegate.supportedLocales,
            onGenerateTitle: (context) => S.of(context).title,
            restorationScopeId: 'root',
            home: GameWidget(
              game: Game2248(soundBLoC: soundBLoC),
            ),
          ),
        ),
      ),
    );
  }
}
