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

O BAT verifica Flutter, resolve dependências e executa
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

Os testes automatizados serão implementados em uma etapa futura.

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
