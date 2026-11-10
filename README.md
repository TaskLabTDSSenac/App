# TaskLab Mobile — Seu grimório de tarefas

Aplicativo didático Flutter/Material 3 para a UC12 do Senac. Consome a mesma API
do Site: usuários, senhas e tarefas são compartilhados. Não há backend próprio,
banco de tarefas local, Firebase nem dados simulados na aplicação.

## Pré-requisitos e execução

Desenvolvido com **Flutter 3.47.8 e Dart 3.13.7**, mantendo `sdk: ^3.13.7`
do projeto base. Instale Flutter no PATH, Chrome para Web e Android SDK/JDK
compatíveis com o Flutter para Android. Não há caminhos particulares de SDK
versionados; `android/local.properties` continua local/ignorado.

```powershell
flutter pub get
.\iniciar.bat
```

Sem argumento, o BAT abre o Chrome. Ele verifica Flutter, resolve dependências e executa
`flutter run -d chrome --web-port=5501`, usando `call`. O Site continua em 5500.
Mantenha a API ativa em outro terminal.

No emulador Android:

```powershell
flutter devices
flutter run -d ID_DO_EMULADOR
```

## Endereço da API

`lib/config/app_config.dart` centraliza o endereço com `kIsWeb` e
`defaultTargetPlatform`, sem importar `dart:io` no código compartilhado:

- Web no computador: `http://127.0.0.1:8000`.
- Emulador Android padrão: `http://10.0.2.2:8000`.
- Celular físico: use o IP local do computador, na mesma rede, ou uma API remota.

Exemplos (substitua o IP/endereço):

```powershell
flutter run -d chrome --web-port=5501 --dart-define=API_BASE_URL=http://127.0.0.1:8000
flutter run -d ID_DO_CELULAR --dart-define=API_BASE_URL=http://192.168.1.100:8000
flutter build apk --release --dart-define=API_BASE_URL=https://api.exemplo.com
```

Para acesso pela rede, a API precisa escutar na interface adequada, por exemplo
`uvicorn app.main:app --host 0.0.0.0 --port 8000`, e o firewall deve permitir a porta.
Não use `127.0.0.1` do celular para alcançar o computador. Nunca inclua o segredo
JWT do backend no app.

## Pendências reais de backend

O OpenAPI da API ativa foi consultado. Foram confirmados:

| Operação | Contrato |
| --- | --- |
| Cadastro | POST /auth/register: name, email, password |
| Login | POST /auth/login: email, password; resposta access_token/token_type |
| Perfil | GET /users/me |
| Senha | PATCH /users/me/password: current_password, new_password |
| Lista/criação | GET/POST /tasks |
| Consulta/edição/exclusão | GET/PUT/DELETE /tasks/{id} |
| Conclusão | PATCH /tasks/{id}/complete, sem corpo |

**Não existe PUT ou PATCH de dados pessoais em `/users/me`.** A tela mostra ID,
nome e e-mail, mas Salvar dados permanece desabilitado com aviso. A integração
proposta `PATCH /users/me` está centralizada e bloqueada por
`AppConfig.profileEditingAvailable`; só ative depois de confirmar o contrato real.
Não são feitas tentativas em múltiplos endpoints nem apresentado sucesso falso.

**CORS do Flutter Web:** o backend deve autorizar explicitamente
`http://localhost:5501` e `http://127.0.0.1:5501`, os métodos usados pelo app e os
cabeçalhos Authorization/Content-Type. As origens do Site (5500) não bastam.
API e Site não foram modificados nesta entrega. Sem esse ajuste, o navegador
bloqueará as chamadas; CORS não se aplica ao cliente Android nativo.

## Organização

- `config/`, `theme/`: configuração e tema azul-noturno/dourado/pergaminho.
- `models/`: usuário, tarefa e validações reutilizáveis, sem defaults que ocultem campos ausentes.
- `services/`: cliente HTTP injetável, autenticação, tarefas, usuário e token seguro.
- `controllers/`: sessão e lista de tarefas com ChangeNotifier.
- `screens/`: telas, Navigator, formulários e navegação inferior Tarefas/Perfil.
- `widgets/`: campos de senha, cartões, estados e ações compartilhadas.
- `exceptions/`: erros compreensíveis em português.

O cliente HTTP usa UTF-8, timeout e Bearer apenas nas operações protegidas.
Não repete operações de escrita. Em timeout de escrita, avisa que o resultado
não foi confirmado: consulte os dados antes de repetir. DELETE 204 não é
decodificado como JSON. Erros 400/404/409/422/500 e detail textual/lista são tratados.

## Funcionalidades e sessão

Cadastro sem login automático; login; restauração/validação de sessão; logout;
lista com pull-to-refresh; detalhes; criação/edição; conclusão sem reabertura;
exclusão física somente após AlertDialog; consulta de perfil e alteração de senha.
Nome/título são aparados, senhas nunca. Descrição vazia envia null no PUT.
Datas ISO 8601 são mostradas em pt-BR no horário local.

Somente o token é persistido com `flutter_secure_storage`. No Android usa o
armazenamento seguro da plataforma; no Web depende de contexto seguro
(HTTPS ou localhost) e continua exigindo proteção contra XSS. Falhas de
armazenamento são apresentadas sem travar. Não são salvos e-mails/senhas como
credenciais locais. A troca de senha mantém a sessão; tokens emitidos continuam
válidos até expirar, pois não há revogação no servidor.

401 protegido invalida a sessão uma única vez, limpa usuário/tarefas e remove
rotas autenticadas da pilha. Uma geração de sessão impede respostas antigas de
repopular os dados após logout. Erro de rede/500 na restauração preserva o token
e permite tentar novamente. Gravações e remoções do token são serializadas.
Se a remoção persistente falhar, há aviso e opção de tentar limpar novamente.

## Android, distribuição e fontes

INTERNET está no manifesto principal. HTTP sem criptografia está permitido
**somente em debug**; o manifesto principal bloqueia cleartext. Para distribuição
use HTTPS e configure assinatura release própria (o template original ainda
usa a configuração de assinatura debug). Gradle, NDK e Java foram preservados.
O minSdk do Flutter instalado é 24, atendendo o mínimo 23 do secure storage.
Auto Backup foi desabilitado para não restaurar um token sem sua chave criptográfica.

Fontes Roboto e Libre Baskerville estão empacotadas em `assets/fonts` com suas
licenças, sem Google Fonts em runtime. Ícones Material são locais. Para build Web
sem CDN de recursos do engine, use `flutter build web --no-web-resources-cdn`.

Referências de configuração: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
e [Libre Baskerville/OFL](https://github.com/google/fonts/tree/main/ofl/librebaskerville).

## Verificação

```powershell
dart format lib
flutter analyze
flutter build web --no-web-resources-cdn
flutter build apk --debug
```

<<<<<<< HEAD
Os testes automatizados serão implementados em uma etapa futura.
=======
O primeiro teste de integração Android está descrito na seção CT-02 abaixo.
>>>>>>> a5c59c2aa9e171a63f4cb649e43ea092650e2b7d

Mantenha `pubspec.lock` versionado: é um aplicativo. Não há dependência de Node.js.
A compilação não substitui a verificação manual em dispositivo. A edição de perfil depende do backend e o Web depende do
CORS para a porta 5501.

### Resultados desta implementação

- `dart format lib`: concluído.
- `flutter analyze`: nenhum problema encontrado.
- `flutter build web --no-web-resources-cdn`: concluído.
- `flutter build apk --debug`: concluído; APK em `build/app/outputs/flutter-apk/app-debug.apk`.
- Houve aviso de versões diferentes do formato XML do Android SDK; não impediu o build.
- Preflights reais para as duas origens 5501 retornaram 400 sem autorização CORS.
- Não foram executados fluxos ponta a ponta no emulador/celular contra a API da turma.
<<<<<<< HEAD
=======

## Teste funcional Mobile — CT-02

Esta estrutura inclui **CT-01 — Cadastrar usuário com sucesso** e
**CT-02 — Não permitir cadastro com senha inferior a 8 caracteres**, pela interface Android real, com `integration_test` e
`flutter_test` do SDK. As regras e os defeitos didáticos permanecem ativos.

### Pré-requisitos e API de testes

Use o Flutter compatível com o `pubspec.yaml`, Android Studio/SDK, Java configurado,
um emulador Android iniciado e a API com suas dependências instaladas.
Não é necessário atualizar globalmente o SDK para executar o teste.

O teste pode cadastrar uma conta real na API caso o defeito esteja ativo.
Use somente dados fictícios e banco exclusivo. O SQLite temporário das fixtures
do pytest **não é automaticamente utilizado pelo App**.

Na pasta `TaskLab\Api`, execute:

```powershell
.\iniciar_testes_site_app.bat
```
Esse iniciador serve aos testes Web e Mobile: limpa somente
`tasklab_web_testes.db` e inicia a API na porta 8000. Não use `iniciar.bat` da API,
que seleciona o banco principal. Encerre a outra API antes; mantenha esta janela
aberta durante os testes. Reiniciar esse BAT apaga os registros do banco de testes.

### Preparar o emulador e as dependências

Abra o Device Manager do Android Studio e inicie manualmente um emulador Android.
Na pasta `TaskLab\App`, execute:

```powershell
flutter devices
```
Lista os dispositivos conectados. Copie o identificador da linha do emulador
Android; ele não é necessariamente `emulator-5554`.

```powershell
flutter pub get
```
Instala as dependências, incluindo os pacotes de teste do SDK. Preserve o
`pubspec.lock` no repositório para registrar as versões resolvidas.

### Executar

Substitua `ID_DO_DISPOSITIVO` pelo identificador obtido acima:

```powershell
flutter test integration_test/cadastro_test.dart -d ID_DO_DISPOSITIVO --dart-define=API_BASE_URL=http://10.0.2.2:8000
```
Executa CT-01 e CT-02 no Android. A API é acessada a partir do emulador pelo
endereço especial `10.0.2.2`, que alcança o computador. `localhost` no emulador
representa o próprio emulador. O App já suporta `API_BASE_URL` e não foi alterado.

```powershell
.\iniciar_testes.bat ID_DO_DISPOSITIVO
```
Confere o Flutter, executa `flutter pub get` e inicia os dois testes de cadastro. Usa por
padrão `http://10.0.2.2:8000`, mantém o resultado na janela e devolve o código de saída.

```powershell
.\iniciar_testes.bat ID_DO_DISPOSITIVO http://10.0.2.2:8000
```
Permite informar explicitamente a URL como segundo argumento. O BAT não inicia
a API nem o emulador. Executá-lo sem argumentos exibe instruções para identificar
o dispositivo. Não há mocks, interceptação de cadastro ou chamadas diretas à API
substituindo as ações de interface.

### Preparação da sessão e passos do cenário

O teste inicializa `IntegrationTestWidgetsFlutterBinding`, apaga somente a chave
`tasklab_access_token` usando `SecureTokenStorage.delete()` e aguarda `app.main()`.
Isso usa a inicialização assíncrona e a restauração de sessão reais, mas garante
login desautenticado. Não usa `deleteAll`, não limpa o dispositivo e não adiciona
uma opção para ignorar autenticação. Execute em emulador de testes, pois a sessão
salva do TaskLab nele será encerrada. Nenhum token ou senha é impresso pelo teste.

1. Aguarda a tela de login após a inicialização real.
2. Toca em “Ainda não possui uma conta? Cadastre-se”.
3. Preenche nome válido e e-mail fictício exclusivo, com horário e sufixo aleatório.
4. Preenche senha e confirmação com seis caracteres.
5. Fecha o teclado, rola até o botão e toca em Criar conta.
6. Aguarda uma rejeição relacionada à senha ou outro resultado observável.
7. Exige mensagem de senha inválida e manutenção da tela de cadastro.
   Mensagem de conta criada causa falha. Permanecer na tela por erro de conexão
   não é suficiente para aprovação.

O App atualmente aceita seis caracteres. Se a API também aceitar, ele retorna
ao login com “Conta criada com sucesso. Faça login para continuar.” e o teste
deve falhar. A expectativa não será invertida para aceitar o defeito.

O erro local correto seria “Senha: informe de 8 a 128 caracteres.”. Uma resposta
de validação da API para password é exibida pelo App como “Senha: valor inválido
ou fora dos limites permitidos.”. O teste usa esses textos reais. A API tem sua
mensagem simplificada pelo cliente; o teste de interface não inspeciona o HTTP 422.
Se o formulário rejeitar antes do envio, o resultado comprova a proteção da
interface, não a validação da API. Essa última deve ser verificada com pytest.

### Arquivos e conceitos para a aula

- `integration_test/cadastro_test.dart`: CT-01, CT-02, inicialização e helpers
  para preenchimento e espera com limite. Utiliza as Keys já existentes.
- `pubspec.yaml` / `pubspec.lock`: dependências de desenvolvimento e versões.
- `iniciar_testes.bat`: execução assistida no Windows, por dispositivo e URL.
- `README.md`: preparo, comandos e interpretação do resultado.

| Termo | Significado |
| --- | --- |
| `testWidgets` | Declara o cenário e recebe o controlador do teste. |
| `WidgetTester` | Permite interagir com widgets e processar quadros da interface. |
| `find` | Localiza um widget por Key, texto ou tipo. |
| `enterText` | Preenche uma entrada de texto. |
| `tap` | Toca em um controle. |
| `pump` | Processa um quadro e permite refletir mudanças na tela. |
| `pumpAndSettle` | Aguarda as animações terminarem; usado só em transições curtas, com limite de 5 segundos. |
| `expect` | Compara o observado com o requisito esperado. |

`aguardar` consulta uma condição da tela com `pump` e prazo máximo de 25 segundos.
Não espera indefinidamente uma animação de carregamento nem usa um atraso fixo
para presumir que uma requisição terminou. O cenário tem limite total de 2 minutos.

Um teste de widget pode exercitar componentes isolados com dependências simuladas.
Aqui, a integração executa o aplicativo real no Android, armazenamento seguro,
navegação, formulário e comunicação HTTP real. Não é um teste do Playwright.

### Interpretar e registrar evidências

- **Sucesso**: mensagem de rejeição relacionada à senha, mantendo o cadastro.
- **Falha de expectativa**: o aplicativo aceitou seis caracteres; registre o defeito.
- **Infraestrutura/configuração**: falta de dispositivo, erro de compilação,
  armazenamento, timeout, rede ou API indisponível. Não classifique isso como
  comprovação do defeito de senha. Falha de seletor também exige investigação.

Relacione o nome CT-02 no terminal à mesma linha da planilha utilizada nos testes
manuais. Registre resultado esperado, observado, versão e dispositivo. Capture
manualmente as evidências necessárias; esta estrutura não gera automaticamente
relatório HTML, screenshots ou vídeos.

Na preparação, a API respondeu a `/health` no computador, mas `flutter devices`
não encontrou emulador Android conectado. Isso não comprova conectividade a partir
do Android, nem valida o fluxo do CT-02.

## Iniciar o aplicativo por dispositivo

```powershell
.\iniciar.bat chrome
```
Abre o aplicativo Flutter no Chrome, na porta 5501. Sem argumento, esse também
é o comportamento padrão. Mantenha a API iniciada em outro terminal.

```powershell
flutter devices
```
Lista os IDs disponíveis. Inicie o emulador pelo Android Studio antes de continuar.

```powershell
.\iniciar.bat emulator-5554
```
Compila, instala e abre o aplicativo no dispositivo indicado. Substitua
`emulator-5554` pelo ID real; não use o nome traduzido `emulador-5554`.
O endereço da API continua sendo escolhido por `lib/config/app_config.dart`:
`10.0.2.2:8000` no Android e `127.0.0.1:8000` no Chrome.

O `iniciar.bat` é para uso manual do aplicativo. O `iniciar_testes.bat` executa
o CT-02 via `flutter test`, que no SDK instalado não suporta integration_test
em dispositivos Web. Portanto, `iniciar_testes.bat chrome` não funciona nesta
estrutura. Para o CT-02, use o ID do emulador Android; não é necessário executar
`iniciar.bat` antes. Testes de integração Flutter Web exigiriam outra preparação,
com driver e ChromeDriver. Os testes Playwright do projeto Site são separados.


## CT-01 — Cadastro com sucesso no aplicativo

O segundo teste usa a interface e a API reais. Apaga apenas o token salvo do
TaskLab, inicia o App, abre o cadastro, preenche nome válido, e-mail exclusivo,
senha `SenhaSegura123` e confirmação igual. Fecha o teclado, toca em Criar conta
e exige a mensagem “Conta criada com sucesso. Faça login para continuar.”,
retorno ao login e botão Entrar visível e habilitado.

O cliente Mobile não expõe o status HTTP ao teste de interface; este caso
verifica o resultado exibido ao usuário, sem adicionar interceptação de HTTP
ou alterar o código de produção para conferir 201. O contrato HTTP pode ser
verificado nos testes da API.

```powershell
flutter test integration_test/cadastro_test.dart -d ID_DO_DISPOSITIVO --dart-define=API_BASE_URL=http://10.0.2.2:8000 --plain-name "CT-01 — Cadastrar usuário com sucesso"
```
Executa somente o CT-01. Substitua o identificador pelo mostrado em `flutter devices`.
A API com banco exclusivo e o emulador devem estar iniciados; o teste grava
uma conta fictícia. O `iniciar_testes.bat ID_DO_DISPOSITIVO` executa ambos os casos.
O CT-02 continua exigindo rejeição da senha curta e pode falhar pelo defeito didático.
>>>>>>> a5c59c2aa9e171a63f4cb649e43ea092650e2b7d
