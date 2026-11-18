import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/common.dart';

const registerUrl = 'treino://registrar';

class DoubleTapSetupScreen extends StatelessWidget {
  const DoubleTapSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget step(int n, String title, String body) => Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, child: Text('$n')),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(body, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Configurar toque duplo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'O iOS não deixa apps detectarem o "Tocar atrás" diretamente. '
            'O caminho é: Tocar atrás → Atalho → app Treino.',
            style: theme.textTheme.bodyLarge,
          ),
          const SectionTitle('1. Criar o Atalho'),
          step(
            1,
            'Abra o app Atalhos',
            'Toque em "+" para criar um novo atalho.',
          ),
          step(
            2,
            'Opção A (recomendada): ação do app',
            'Em "Adicionar ação", busque "Treino" e escolha "Registrar série". '
                'Se não aparecer, abra o app Treino uma vez e tente de novo.',
          ),
          step(
            3,
            'Opção B: abrir URL',
            'Adicione a ação "Abrir URLs" e digite exatamente o endereço abaixo.',
          ),
          Card(
            child: ListTile(
              title: const Text(
                registerUrl,
                style: TextStyle(fontSize: 20, fontFamily: 'Menlo'),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copiar',
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: registerUrl));
                  showSnack(context, 'Endereço copiado');
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          step(
            4,
            'Dê um nome',
            'Ex.: "Registrar série". Toque em OK para salvar.',
          ),
          const SectionTitle('2. Ligar ao Toque duplo'),
          step(5, 'Ajustes › Acessibilidade › Toque › Tocar atrás', ''),
          step(
            6,
            'Toque duplo',
            'Role até "Atalhos" e escolha o atalho que você criou.',
          ),
          const SectionTitle('3. Como usar'),
          Text(
            '• Inicie o treino no app.\n'
            '• Depois de cada série, toque duas vezes atrás do iPhone: a janela de registro aparece já na série certa.\n'
            '• Se a tela estiver bloqueada, desbloqueie com o Face ID antes (o iOS pode pedir).\n'
            '• Funciona com o app aberto, em segundo plano ou fechado.\n'
            '• O botão "Registrar série" na tela do treino faz exatamente a mesma coisa.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
