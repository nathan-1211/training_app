import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/theme.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/session/presentation/session_controller.dart';
import 'features/session/presentation/session_screen.dart';
import 'features/session/presentation/summary_screen.dart';

class TreinoApp extends StatelessWidget {
  const TreinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treino',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: buildTheme(),
      darkTheme: buildTheme(),
      themeMode: ThemeMode.dark,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AppShell(),
    );
  }
}

/// Raiz: mostra a sessão em andamento (se houver), o resumo do treino
/// recém-encerrado ou a tela inicial. Recarrega a sessão ao voltar para o
/// primeiro plano.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  bool _staleDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(sessionControllerProvider.notifier).reload();
    }
  }

  Future<void> _showStaleDialog() async {
    if (_staleDialogOpen) return;
    _staleDialogOpen = true;
    final controller = ref.read(sessionControllerProvider.notifier);
    final keep = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Treino ainda aberto'),
        content: const Text(
          'A última série foi há mais de 3 horas. Quer continuar este treino ou encerrá-lo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Encerrar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    _staleDialogOpen = false;
    if (keep == null) {
      // Diálogo fechado por um gatilho externo: pergunta de novo.
      if (mounted &&
          ref.read(sessionControllerProvider).value?.stalePrompt == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showStaleDialog());
      }
      return;
    }
    if (keep) {
      await controller.continueStale();
    } else {
      await controller.closeStale();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionControllerProvider, (prev, next) {
      if (next.value?.stalePrompt == true && prev?.value?.stalePrompt != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showStaleDialog());
      }
    });
    final async = ref.watch(sessionControllerProvider);
    return async.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Erro ao carregar: $e'))),
      data: (s) {
        if (s.summary != null) return SummaryScreen(summary: s.summary!);
        if (s.active != null) return const SessionScreen();
        return const HomeScreen();
      },
    );
  }
}
