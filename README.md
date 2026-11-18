# Treino

App pessoal (Flutter, iOS 16+) para registrar musculação, corrida e condicionamento durante a sessão, com o mínimo de atrito. Tudo fica no iPhone (SQLite via drift), sem login e sem nuvem.

- Toque duplo atrás do iPhone → abre a janela de registro já na série certa.
- O cursor avança sozinho: série → próximo exercício → fim do treino com resumo (duração, volume, recordes).
- Timer de descanso calculado pelo horário (sem nada rodando em segundo plano) + notificação local quando o descanso acaba.
- Corrida (km + tempo → pace), EMOM/Cross, testes da semana 1 e 8, dashboard, blocos de periodização, backup em JSON.

---

## 1. Rodar no iPhone

Pré-requisitos: Flutter estável, Xcode e CocoaPods (já configurados no Mac).

1. Conecte o iPhone por cabo e desbloqueie. Na primeira vez, aceite "Confiar neste computador".
2. No iPhone: **Ajustes › Privacidade e Segurança › Modo de Desenvolvedor** → ativar (o iPhone reinicia).
3. No Mac, na pasta do projeto:
   ```bash
   flutter pub get
   open ios/Runner.xcworkspace
   ```
4. No Xcode: selecione o target **Runner** › **Signing & Capabilities**:
   - marque **Automatically manage signing**;
   - em **Team**, escolha o seu Apple ID (*Personal Team*). Se não aparecer: Xcode › Settings › Accounts › "+" › Apple ID;
   - o Bundle Identifier é `com.nathanbranco.treino`. Se o Xcode reclamar que já existe, troque por outro único (ex.: `com.seunome.treino2`).
5. Feche o Xcode e instale em modo release (mais rápido e não depende do Mac para abrir):
   ```bash
   flutter run --release
   ```
   Ou pelo Xcode: escolha o iPhone como destino, Product › Scheme › Edit Scheme › Run › Build Configuration = **Release**, e ▶︎.
6. Na primeira abertura, o iOS bloqueia o app de desenvolvedor: **Ajustes › Geral › VPN e Gerenciamento de Dispositivos** › seu Apple ID › **Confiar**.

> **Validade da instalação**
> - Com **Apple ID gratuito**, o app **expira em 7 dias**. Depois disso ele não abre; basta conectar o iPhone e rodar `flutter run --release` de novo. **Os dados ficam**, desde que você não apague o app.
> - Com a **conta paga de desenvolvedor** (US$ 99/ano), a instalação dura **1 ano**.
> - Mesmo assim, faça backup de vez em quando (seção 3).

> Modo debug (`flutter run` sem `--release`) só abre a partir do Mac/Xcode; o link `treino://` não funciona com o app aberto "sozinho" em debug. Use release no dia a dia.

## 2. Criar o Atalho e ligar ao "Tocar atrás"

O iOS não deixa apps detectarem o "Tocar atrás" diretamente. O caminho é: **Tocar atrás → Atalho → app Treino**. O app tem essas instruções na tela **Configurar toque duplo**.

1. Abra o app **Atalhos** › **+** (novo atalho).
2. **Opção A (recomendada)**: *Adicionar ação* › busque **Treino** › **Registrar série**. (Se não aparecer, abra o app Treino uma vez e tente de novo.)
   **Opção B**: ação **Abrir URLs** com o endereço `treino://registrar`.
3. Dê o nome "Registrar série" e salve.
4. **Ajustes › Acessibilidade › Toque › Tocar atrás › Toque duplo** › role até *Atalhos* › escolha **Registrar série**.

Uso: inicie o treino no app. Depois de cada série, toque duas vezes atrás do iPhone. Se a tela estiver bloqueada, o iOS pode pedir o Face ID antes de abrir o app. O botão grande **Registrar série** na tela do treino faz exatamente a mesma coisa.

## 3. Backup

**Configurações (engrenagem na tela inicial) › Exportar backup** gera um `.json` com todos os dados e abre o menu de compartilhar do iOS (salve em Arquivos/iCloud Drive, AirDrop para o Mac, e-mail…).

Para restaurar: **Importar backup** › escolha o arquivo. **Isso substitui todos os dados atuais** (o app pede confirmação). A importação é atômica: se o arquivo estiver inválido, nada muda.

Faça um backup antes de reinstalar o app ou trocar de iPhone.

## 4. Teste manual no iPhone (gatilho com a tela apagada)

Faça uma vez depois de instalar:

1. Inicie um treino e registre 1 ou 2 séries.
2. Bloqueie a tela (botão lateral) e espere **2 minutos**.
3. Acorde a tela, desbloqueie com Face ID e dê o **toque duplo** atrás.
4. ✅ A janela de registro aparece direto, na série certa (sem passar pela tela inicial), com a carga pré-preenchida.
5. Feche a janela, vá ao seletor de apps (deslizar de baixo para cima e segurar) e **force o fechamento** do Treino.
6. Repita o toque duplo. ✅ O app abre do zero (cold start) e mostra a janela na mesma série.
7. Registre uma série com descanso (ex.: Terra, 150 s), bloqueie a tela e espere. ✅ Chega a notificação "Descanso terminou". Se registrar a próxima série antes, a notificação é cancelada.

## 5. Desenvolvimento

```bash
flutter analyze                     # deve ficar sem issues
flutter test                        # unitários + widget test do fluxo completo
dart run build_runner build         # regenerar o código do drift após mudar tabelas
```

Estrutura (`lib/features/<feature>/{data,domain,presentation}`):

| Pasta | O que tem |
|---|---|
| `core/db` | Tabelas drift e `AppDatabase` (schema versionado, seed do Bloco 1 na criação) |
| `features/session` | `CursorLogic` (avanço), `RestTimer`, snapshot do plano, `SessionRepository`, `WorkoutSessionController`, top sheet |
| `features/trigger` | `TriggerQueue` (fila + dedupe), `TriggerService` (app_links + App Intent), tela de configuração |
| `features/blocks` | `BlockSpec`, gerador de sessões, seed, repositório, telas de bloco |
| `features/cardio`, `assessments`, `dashboard`, `settings` | Corrida/condicionamento, testes, gráficos, backup |
| `ios/Runner/AppDelegate.swift` | App Intent "Registrar série", `AppShortcutsProvider` e ponte `MethodChannel` `treino/trigger` |

Migrations: ao mudar uma tabela, incremente `schemaVersion` em `lib/core/db/database.dart` e adicione um passo `if (from < N)` em `onUpgrade`. Nunca altere um passo já instalado.

## 6. Decisões tomadas

- **Plano congelado por sessão**: ao iniciar um treino, a lista de exercícios × séries (da semana do bloco) é salva como JSON na própria sessão. Editar o bloco depois não bagunça um treino em andamento nem o histórico.
- **Estado só no banco**: o cursor (exercício, série), o horário da última série e o fim do descanso são gravados a cada série. Ao voltar para o primeiro plano e a cada gatilho, a sessão é recarregada do banco antes de qualquer ação.
- **Gatilho único**: toque duplo (URL), App Intent e botão chamam `WorkoutSessionController.onRegisterTrigger()`. As operações do controller são serializadas.
- **Cold start**: os gatilhos entram numa fila que só é liberada depois que a sessão foi lida do banco. Gatilhos acumulados viram uma única abertura da janela. O plugin `app_links` no iOS reenvia o link de abertura também pelo stream; a fila descarta o mesmo link vindo pelo outro canal em até 3 s. Cada execução do App Intent tem um UUID, consumido uma única vez.
- **OK duplicado**: cada OK carrega o cursor da janela; se o banco já passou daquela série, o segundo OK é ignorado.
- **Sessão esquecida**: se a última série (ou o início) tiver mais de 3 h, o app pergunta se continua ou encerra. Encerrar fecha a sessão no horário da última série; uma sessão sem nenhuma série é descartada.
- **Pré-preenchimento**: carga = série anterior desta sessão; senão, a mesma série da última vez que fez o exercício. Reps = topo da faixa alvo (ex.: "6–8" → 8). Distância = última registrada ou o topo da faixa ("30–40 m" → 40).
- **Semana do bloco**: a semana 1 começa na data de início do bloco (o seed usa a segunda-feira da semana da instalação). Datas fora do bloco: a tela inicial avisa e deixa escolher um treino manualmente.
- **Aderência**: por semana e por tipo (força, corrida, condicionamento), conta min(feitas, planejadas). Fazer o treino em outro dia da mesma semana também vale.
- **Recordes**: só contam quando superam uma marca anterior (a primeira vez de um exercício não é "PR").
- **Notificação** agendada em UTC (instante absoluto), sem dependência de fuso.
- **Exercícios** são globais por nome, então o histórico do "Terra com trap bar" atravessa blocos.
- **Editar um bloco** regenera as sessões planejadas daquele bloco; treinos já feitos não mudam.
- Sem wakelock: a tela apaga normalmente entre as séries.
