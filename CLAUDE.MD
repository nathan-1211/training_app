# Prompt para o Claude Code — App de treino em Flutter (uso pessoal, iPhone)

> Cole tudo abaixo da linha no Claude Code, a partir de uma pasta vazia onde o projeto será criado.

---

## Contexto

Quero que você desenvolva um app **Flutter para iOS**, de **uso pessoal** (só eu, sem publicação na App Store), para registrar meus treinos de musculação, corrida e condicionamento durante a sessão, com o mínimo de atrito. Vou instalar no meu iPhone via Xcode, a partir de um MacBook Air Apple Silicon que já tem Flutter, Xcode e CocoaPods configurados.

Idioma da interface: **português do Brasil**. Unidades: kg, km, minutos. Formato de data: dd/mm/aaaa.

Antes de escrever código, leia este documento inteiro, proponha a arquitetura e o modelo de dados em um resumo curto e então implemente em fases (ver "Fases de entrega"). Ao final de cada fase, rode `flutter analyze` e os testes e me diga o que foi feito.

## Stack obrigatória

- Flutter estável mais recente, Dart null-safe, iOS 16+ como alvo mínimo.
- **Armazenamento 100% local**: SQLite via `drift` (com migrations versionadas). Nada de backend, login ou nuvem.
- Estado: `flutter_riverpod`.
- Gráficos: `fl_chart`.
- Deep links: `app_links`.
- **Não use wakelock** nem nada que impeça o iPhone de bloquear ou suspender o app. A tela apaga normalmente entre as séries.
- Notificações locais (só para o timer de descanso): `flutter_local_notifications`.
- Feedback tátil: `HapticFeedback` (nativo do Flutter).
- Estrutura por feature (`lib/features/<feature>/{data,domain,presentation}`), com lógica de domínio em classes puras e testáveis.

## Requisito central: registrar série com 2 toques atrás do iPhone

O iOS **não** permite que apps de terceiros detectem diretamente o "Tocar atrás" (Ajustes › Acessibilidade › Toque › Tocar atrás). O caminho suportado é: Tocar atrás → executa um **Atalho** → o Atalho chama o app. Implemente assim:

1. **URL scheme próprio** `treino://registrar` (configure no `Info.plist` → `CFBundleURLTypes`). Quando o app recebe esse link com um treino em andamento, abre a janela de registro. Sem treino em andamento, abre a tela inicial com o botão "Iniciar treino".
2. **(Desejável) App Intent nativo** em Swift (`AppIntent` com `openAppWhenRun = true`, exposto via `AppShortcutsProvider` com o nome "Registrar série"). Ele dispara o mesmo evento para o Flutter via `MethodChannel`/`EventChannel`. Assim o atalho aparece direto no app Atalhos, sem precisar digitar URL. Se der complexidade demais, entregue só o URL scheme e deixe o App Intent como fase extra.
3. Crie uma tela **"Configurar toque duplo"** dentro do app, com o passo a passo para eu montar o Atalho ("Abrir URL" `treino://registrar`, ou a ação do App Intent) e associá-lo ao Toque duplo em Tocar atrás.
4. **Tem que funcionar depois que a tela apagar e acender de novo.** O uso real é: termino a série → o iPhone bloqueia sozinho → acordo a tela, desbloqueio com Face ID (o iOS pode pedir o desbloqueio antes de o Atalho abrir o app) → toque duplo → a janela de registro aparece. Para isso:
   - **Persista o estado da sessão no banco a cada mudança** (sessão ativa, exercício e série atuais, horário da última série). Nada de estado importante só em memória.
   - Trate os **três cenários** de chegada do gatilho e teste cada um: (a) app em primeiro plano; (b) app suspenso em segundo plano, retomando via `app_links` (`uriLinkStream`) ou App Intent; (c) **app encerrado pelo iOS (cold start)**, recebendo o link inicial (`getInitialLink`) ou o App Intent na abertura. Nos três casos, o app deve reidratar a sessão do banco e abrir a janela já na série certa, sem passar pela tela inicial.
   - No cold start, o link pode chegar antes de o banco e o Riverpod estarem prontos. Enfileire o gatilho e processe-o assim que a sessão for carregada. O mesmo gatilho nunca pode ser processado duas vezes, por exemplo link inicial + stream.
   - Ao voltar para o primeiro plano (`AppLifecycleState.resumed`), recarregue a sessão do banco antes de qualquer ação.
   - **Timer de descanso sem rodar em segundo plano**: calcule o tempo restante a partir do horário salvo da última série (não use um `Timer` contando no background). Ao registrar a série, agende uma **notificação local** para o fim do descanso e cancele-a se eu registrar a próxima série antes.
   - Sessão esquecida aberta: se a última série tiver mais de 3 horas, pergunte ao abrir se quero continuar ou encerrar o treino.
5. **Fallback**: na tela de treino em andamento, um botão grande "Registrar série" que faz exatamente a mesma coisa que o toque duplo. Toque duplo e botão chamam o mesmo método (`WorkoutSessionController.onRegisterTrigger()`).

## Fluxo do treino (comportamento exato)

1. Abro o app → tela inicial mostra **o treino de hoje** pelo bloco ativo e pelo dia da semana (ex.: "Semana 3 · Força A"), com botão **Iniciar treino**. Posso escolher outro treino manualmente.
2. Ao iniciar, a sessão é criada e o cursor aponta para o **exercício 1, série 1**.
3. A cada gatilho (toque duplo ou botão), desce do topo uma **janela (top sheet animado, ~300 ms, de cima para baixo)** com:
   - nome do exercício atual e "Série X de Y";
   - meta da série (reps e RIR da semana) e a carga/reps da **última vez** que fiz esse exercício, como referência;
   - campo **Carga (kg)** (teclado numérico decimal), pré-preenchido com a carga da série anterior desta sessão ou, se for a primeira, da última sessão;
   - campo **Reps** (teclado numérico), pré-preenchido com o alvo;
   - botão **OK**, grande.
4. Ao tocar **OK**: grava a série, faz vibração leve, a janela sobe e some, e o cursor avança.
   - Se ainda há séries no exercício → o próximo gatilho mostra a próxima série do mesmo exercício.
   - Se completou todas as séries prescritas → o próximo gatilho já mostra **o próximo exercício, série 1**.
   - Se foi a **última série do último exercício** → o treino se **encerra automaticamente** e abre a tela de resumo (duração, volume total, recordes do dia).
5. Exercícios de aquecimento (marcados como `isWarmup`) aparecem no fluxo, mas a janela deles pede só confirmação (OK), sem carga.
6. Exercícios por distância (ex.: farmer carry, "30–40 m") pedem **carga + distância** em vez de reps. Modele o tipo de registro por exercício: `loadReps`, `loadDistance`, `repsOnly`, `timeOnly`, `confirmOnly`.
7. Deslizar a janela para cima fecha sem registrar. Na tela da sessão: desfazer a última série, pular exercício e encerrar treino manualmente (com confirmação).
8. **(Desejável)** Depois do OK, um timer de descanso com o tempo prescrito do exercício. Ele aparece na tela da sessão quando o app está aberto e avisa por notificação local quando o app está em segundo plano ou com a tela apagada (ver item 4 da seção anterior).
9. A sessão em andamento sobrevive à tela apagada, ao app suspenso e ao app encerrado pelo iOS: em qualquer caso, o próximo gatilho retoma do ponto exato.

## Corrida e condicionamento

- Na tela inicial, botão **Registrar corrida**: pede só **km** e **tempo** (mm:ss ou h:mm:ss), mais RPE 1–10 e notas, ambos opcionais. O app calcula o **pace (min/km)** automaticamente, mostra antes de salvar e grava para o dashboard.
- O mesmo vale para **EMOM / Cross**: tipo, duração, RPE e notas.
- Se o dia do bloco é de corrida, a tela inicial mostra a prescrição da semana (ex.: "5× (4' corre / 1' caminha)").

## Tela "Cadastrar bloco"

Permite criar um bloco de periodização:

1. **Nome** do bloco e **data de início**.
2. **Quantidade de semanas** (1–16).
3. **Treinos do bloco** (ex.: Força A, Força B), cada um com uma lista ordenada de exercícios: nome, tipo de registro, é aquecimento?, reps alvo (texto livre como "6–8" ou "10/lado", e também `repsMin`/`repsMax` numéricos para lógica), descanso em segundos e dica técnica.
4. **Agenda semanal**: qual treino (ou corrida/condicionamento/descanso) cai em cada dia da semana.
5. **Tabela de progressão por semana**: para cada semana, número de séries dos exercícios principais, RIR alvo, prescrição de corrida (texto) e de condicionamento (texto). Os aquecimentos têm séries fixas.
6. Botão **Gerar bloco**: cria todas as sessões planejadas (semana × dia) no banco. A tela inicial passa a usar o bloco ativo. Também quero poder **duplicar** um bloco (para o Bloco 2) e editar.

Ao instalar pela primeira vez, faça o **seed** do bloco abaixo, para eu já começar a usar.

## Seed — Bloco 1 (8 semanas)

Agenda: Seg = Força A · Ter = Corrida · Qui = Força B · Sáb = Condicionamento/Cross · demais dias = descanso.

**Progressão por semana**

| Semana | Fase | Séries (principais) | RIR | Corrida | Condicionamento |
|---|---|---|---|---|---|
| 1 | Readaptação | 2 | 3–4 | 5' caminhada + 8× (1' corre / 2' caminha) | EMOM 12' leve (RPE ≤ 6) + testes iniciais |
| 2 | Readaptação | 2 | 3–4 | 8× (2' corre / 2' caminha) | EMOM 14' (RPE ≤ 6) |
| 3 | Construção | 3 | 3 | 6× (3' corre / 1'30 caminha) | EMOM 16' (RPE ≤ 7) |
| 4 | Construção | 3 | 3 | 5× (4' corre / 1' caminha) | EMOM 16' (RPE ≤ 7) |
| 5 | Progressão | 3 | 2–3 | 3× (8' corre / 1' caminha) | EMOM 18' ou cross escalado (RPE ≤ 8) |
| 6 | Progressão | 3 | 2 | 2× (12' corre / 1' caminha) | EMOM 20' ou cross |
| 7 | Progressão | 4 | 2 | 20' contínuos em ritmo de conversa | EMOM 20' ou cross |
| 8 | Deload + testes | 2 | 4 | 25' contínuos leves | Testes finais |

**Força A** (aquecimento: 2 séries fixas)
| Exercício | Tipo | Reps | Descanso | Dica |
|---|---|---|---|---|
| Aq. Mobilização joelho-parede com elástico | confirmOnly | 10/lado | 0 | Joelho passa da ponta do pé, calcanhar no chão |
| Aq. Passada lateral com mini-band | confirmOnly | 12/lado | 0 | Joelho não cai para dentro |
| Aq. Prancha lateral com abdução | confirmOnly | 8/lado | 0 | Sinta o glúteo médio, não o TFL |
| Terra com trap bar | loadReps | 6–8 | 150 s | Quadril e joelho estendem juntos |
| Agachamento goblet, calcanhar elevado | loadReps | 8–10 | 120 s | Anilha sob o calcanhar; tronco ereto |
| Afundo búlgaro | loadReps | 8/perna | 90 s | Joelho alinhado com o 2º dedo |
| Remada unilateral com halter | loadReps | 10/lado | 90 s | Escápula para trás e para baixo |
| Panturrilha excêntrica em pé | loadReps | 12 | 60 s | 3 s descendo, amplitude total |
| Pallof press | loadReps | 10/lado | 60 s | Resista à rotação |

**Força B** (aquecimento: 2 séries fixas)
| Exercício | Tipo | Reps | Descanso | Dica |
|---|---|---|---|---|
| Aq. Chin tuck | confirmOnly | 10 | 0 | Queixo para trás, sem inclinar |
| Aq. Open book | confirmOnly | 8/lado | 0 | Gira o tronco, não o quadril |
| Aq. Face pull leve | confirmOnly | 15 | 0 | Cotovelos altos |
| Puxada alta (ou barra com elástico) | loadReps | 6–10 | 120 s | Pegada neutra se o ombro reclamar |
| Supino com halteres | loadReps | 8–10 | 120 s | Cotovelo ~45° |
| Remada apoiada no banco | loadReps | 10–12 | 90 s | Pausa 1 s em cima |
| Desenvolvimento meio-ajoelhado unilateral | loadReps | 8/lado | 90 s | Glúteo da perna de trás contraído |
| Elevação pélvica | loadReps | 10 | 90 s | Pausa 1 s no topo |
| Face pull | loadReps | 15 | 60 s | Puxar mais do que empurrar |
| Farmer carry | loadDistance | 30–40 m | 60 s | Postura alta |

**Testes** (semanas 1 e 8): joelho-parede D e E (cm), barras máximas, flexões máximas, terra trap bar 5 reps com RIR 2 (kg), distância em 12' (m). Crie uma tela simples para registrar e comparar os testes.

## Dashboard (só números que importam)

1. **Força**: 1RM estimado (Epley: `carga × (1 + reps/30)`, usando a melhor série da sessão) ao longo do tempo para cada exercício principal, com seletor de exercício. Destaque de recordes (PR de carga e de 1RM estimado).
2. **Volume semanal**: soma de carga × reps por semana, separado em Força A e Força B, e número de séries efetivas por semana.
3. **Aderência**: sessões feitas ÷ planejadas por semana do bloco, e sequência de semanas cumpridas.
4. **Corrida**: km por semana, tendência de pace (linha), maior tempo contínuo e melhor pace por faixa de distância.
5. **Condicionamento**: minutos e RPE médio por semana.
6. **Testes**: semana 1 vs semana 8 lado a lado, com diferença.
7. Filtro por bloco e "todos os blocos".

## Dados e segurança dos dados

- Modelo mínimo sugerido (ajuste se tiver motivo): `Block`, `BlockWeek` (prescrição por semana), `WorkoutTemplate`, `TemplateExercise`, `Exercise`, `PlannedSession`, `Session`, `SetLog` (sessionId, exerciseId, setIndex, loadKg, reps, distanceM, createdAt), `CardioLog` (tipo, km, durationSec, paceSecPerKm, rpe, notes), `TestResult`.
- **Exportar/Importar backup** em JSON pela tela de configurações (usando o share sheet do iOS), porque o armazenamento é só local e reinstalar o app pode apagar os dados.
- Tudo funciona offline.

## Assinatura e instalação

- Configure o projeto para rodar no meu iPhone físico pelo Xcode com o meu Apple ID (Signing & Capabilities → Team pessoal).
- Me lembre no README: com Apple ID gratuito o app expira em **7 dias** e precisa ser reinstalado pelo Xcode (os dados ficam se eu não apagar o app). Com a conta paga de desenvolvedor, dura 1 ano.
- O README deve ter o passo a passo de: rodar no iPhone, criar o Atalho e ligar ao Tocar atrás, e fazer backup.

## Qualidade

- Testes unitários para: avanço do cursor (série → próximo exercício → fim do treino), geração de sessões do bloco, cálculo de pace (ex.: 3,2 km em 21:30 = 6:43 min/km), 1RM de Epley, retomada de sessão interrompida, gatilho recebido em cold start com o banco ainda carregando (deve ser enfileirado e processado uma vez só) e tempo restante de descanso calculado por timestamp.
- Teste manual no iPhone, descrito no README: iniciar treino → bloquear a tela → esperar 2 min → desbloquear → toque duplo → a janela aparece na série certa. Repetir depois de forçar o fechamento do app pelo seletor de apps.
- Pelo menos um widget test do fluxo: iniciar → registrar todas as séries → treino encerrado.
- `flutter analyze` sem warnings.
- UI: tema escuro por padrão, alvos de toque grandes (uso com mão suada e na academia), textos legíveis a um braço de distância, sem telas desnecessárias.

## Fases de entrega

1. **Fundação**: projeto, drift + schema + seed do Bloco 1, navegação básica.
2. **Sessão de treino**: tela inicial com o treino do dia, sessão, top sheet de registro, avanço automático, fim automático e retomada.
3. **Gatilho externo**: URL scheme + `app_links` nos três cenários (primeiro plano, suspenso, cold start), timer de descanso por timestamp + notificação local, tela "Configurar toque duplo". Depois, App Intent nativo (desejável).
4. **Corrida/condicionamento e testes**.
5. **Cadastrar bloco** (criar, gerar, duplicar, editar).
6. **Dashboard**.
7. **Backup, README e polimento** (timer de descanso, haptics, testes finais).

Pergunte só o que for realmente bloqueante. Nas demais decisões, escolha o mais simples e robusto e registre no README.