import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/format.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../blocks/presentation/blocks_screen.dart';
import '../../home/presentation/home_providers.dart';
import '../../session/presentation/session_controller.dart';
import '../../trigger/presentation/double_tap_setup_screen.dart';
import '../data/backup_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  BackupService get _backup => BackupService(ref.read(databaseProvider));

  Future<void> _export(BuildContext buttonContext) async {
    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      final json = await _backup.exportJson(now: now);
      final dir = await getTemporaryDirectory();
      final name =
          'treino-backup-${now.year}${two(now.month)}${two(now.day)}-${two(now.hour)}${two(now.minute)}.json';
      final file = File(p.join(dir.path, name));
      await file.writeAsString(json);
      if (!buttonContext.mounted) return;
      final box = buttonContext.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          subject: 'Backup do Treino',
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (e) {
      if (mounted) showSnack(context, 'Erro ao exportar: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (files.isEmpty || files.first.path == null || !mounted) return;
    final ok = await confirmDialog(
      context,
      title: 'Importar backup?',
      message: 'Todos os dados atuais serão SUBSTITUÍDOS pelo conteúdo do arquivo. Exporte um backup antes se tiver dúvida.',
      confirm: 'Substituir',
      destructive: true,
    );
    if (!ok) return;
    setState(() => _busy = true);
    try {
      final json = await File(files.first.path!).readAsString();
      await _backup.importJson(json);
      ref.read(dataVersionProvider.notifier).bump();
      await ref.read(sessionControllerProvider.notifier).reload();
      if (mounted) showSnack(context, 'Backup importado');
    } catch (e) {
      if (mounted) showSnack(context, 'Falha ao importar: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _push(Widget w) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle('Backup'),
          Text(
            'Os dados ficam só neste iPhone. Reinstalar ou apagar o app apaga tudo — exporte um backup de vez em quando (Arquivos, AirDrop, e-mail…).',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (btnCtx) => FilledButton.icon(
              onPressed: _busy ? null : () => _export(btnCtx),
              icon: const Icon(Icons.ios_share),
              label: const Text('Exportar backup'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : _import,
            icon: const Icon(Icons.file_open),
            label: const Text('Importar backup'),
          ),
          const SectionTitle('Treino'),
          ListTile(
            leading: const Icon(Icons.view_week),
            title: const Text('Blocos'),
            subtitle: const Text('Cadastrar, editar, duplicar, ativar'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(const BlocksScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.touch_app),
            title: const Text('Configurar toque duplo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(const DoubleTapSetupScreen()),
          ),
          const SectionTitle('Instalação'),
          Text(
            'Instalado pelo Xcode com Apple ID gratuito, o app expira em 7 dias e precisa ser reinstalado (os dados ficam se você não apagar o app). Com conta paga de desenvolvedor, dura 1 ano.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
