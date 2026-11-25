// Prepares and removes the staging data that the Maestro E2E flows use.
//
//   dart run scripts/e2e/fixtures.dart setup --run-id <id> --out <file>
//   dart run scripts/e2e/fixtures.dart cleanup --run-id <id>
//
// `setup` creates one notice per flow that needs one, so flows that run at
// the same time (Android and iOS, or two CI runs) never share reaction counts
// or titles. It writes `MAESTRO_*` lines to <file>; the runner exports them so
// the flows can read `${MAESTRO_READ_NOTICE_ID}` and so on.
//
// `cleanup` deletes the notices of this run and every E2E notice older than
// [_staleAfter], which a cancelled run may have left behind. The backend
// cancels the delayed push of a notice when it is deleted, so cleanup should
// run right after the flows.
//
// Credentials come from E2E_IDP_EMAIL and E2E_IDP_PASSWORD. The IdP address
// and client ID come from .env, like the app.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';

const _ziggleStagingApi = 'https://api.stg.ziggle.gistory.me/';
const _redirectUri = 'ziggle-idp-login-redirect://callback';

/// Every notice this script or a flow creates starts with this, so cleanup
/// can find them without touching anything else the test account owns.
const titlePrefix = '[E2E]';
const _staleAfter = Duration(hours: 1);

Future<void> main(List<String> args) async {
  if (args.isEmpty) _usage();
  final command = args.first;
  final options = _parseOptions(args.skip(1).toList());
  final runId = options['run-id'] ?? _usage();

  final api = await _ZiggleApi.login();
  switch (command) {
    case 'setup':
      final out = options['out'] ?? _usage();
      await _setup(api, runId, File(out));
    case 'cleanup':
      await _cleanup(api, runId);
    default:
      _usage();
  }
}

Future<void> _setup(_ZiggleApi api, String runId, File out) async {
  final values = <String, String>{'MAESTRO_RUN_ID': runId};
  // Flows 01 (read), 03 (link), 05 (reaction) and 06 (share) each get their
  // own notice. 02 writes its own and 04 only uses the local draft.
  for (final key in ['READ', 'LINK', 'REACTION', 'SHARE']) {
    final title = '$titlePrefix $runId ${key.toLowerCase()}';
    final body = 'E2E $runId ${key.toLowerCase()} body';
    final notice = await api.createNotice(title: title, body: '<p>$body</p>');
    values['MAESTRO_${key}_NOTICE_ID'] = '${notice['id']}';
    values['MAESTRO_${key}_NOTICE_TITLE'] = title;
    values['MAESTRO_${key}_NOTICE_BODY'] = body;
    stdout.writeln('created notice ${notice['id']} for $key');
  }
  await out.parent.create(recursive: true);
  // Single-quoted so the runner can `source` titles with spaces.
  String quote(String v) => "'${v.replaceAll("'", r"'\''")}'";
  await out.writeAsString(
    values.entries.map((e) => '${e.key}=${quote(e.value)}\n').join(),
  );
}

Future<void> _cleanup(_ZiggleApi api, String runId) async {
  final now = DateTime.now();
  final notices = await api.ownNotices();
  var deleted = 0;
  for (final notice in notices) {
    final title = notice['title'] as String? ?? '';
    if (!title.startsWith(titlePrefix)) continue;
    final createdAt = DateTime.parse(notice['createdAt'] as String);
    // setup writes '<prefix> <runId> <key>', so the space keeps run IDs that
    // share a beginning (local-...-12 and local-...-123) apart.
    final fromThisRun = title.startsWith('$titlePrefix $runId ');
    final stale = now.difference(createdAt) > _staleAfter;
    if (!fromThisRun && !stale) continue;
    await api.deleteNotice(notice['id'] as int);
    deleted++;
  }
  stdout.writeln('deleted $deleted E2E notices');
}

class _ZiggleApi {
  final String _token;
  _ZiggleApi(this._token);

  static Future<_ZiggleApi> login() async {
    final idpToken = await _idpAccessToken();
    final res = await _request(
      'POST',
      Uri.parse('${_ziggleStagingApi}auth/login'),
      headers: {'authorization': 'Bearer $idpToken'},
    );
    return _ZiggleApi(_json(res)['access_token'] as String);
  }

  Map<String, String> get _auth => {'authorization': 'Bearer $_token'};

  Future<Map<String, dynamic>> createNotice({
    required String title,
    required String body,
  }) async {
    final res = await _request(
      'POST',
      Uri.parse('${_ziggleStagingApi}notice'),
      headers: _auth,
      body: {'title': title, 'body': body, 'category': 'ETC'},
    );
    return _json(res);
  }

  Future<List<Map<String, dynamic>>> ownNotices() async {
    final notices = <Map<String, dynamic>>[];
    const limit = 50;
    for (var offset = 0; ; offset += limit) {
      final res = await _request(
        'GET',
        Uri.parse('${_ziggleStagingApi}notice').replace(
          queryParameters: {
            'my': 'own',
            'offset': '$offset',
            'limit': '$limit',
          },
        ),
        headers: _auth,
      );
      final page = (_json(res)['list'] as List).cast<Map<String, dynamic>>();
      notices.addAll(page);
      if (page.length < limit) return notices;
    }
  }

  Future<void> deleteNotice(int id) async {
    await _request(
      'DELETE',
      Uri.parse('${_ziggleStagingApi}notice/$id'),
      headers: _auth,
    );
  }
}

/// Signs in to the IdP the same way the app does, but without a browser:
/// password login, then the authorization code flow with PKCE.
Future<String> _idpAccessToken() async {
  final env = _readDotenv();
  final idpApi = env['IDP_API_BASE_URL'] ?? _fail('IDP_API_BASE_URL in .env');
  final clientId =
      env['ZIGGLE_IDP_CLIENT_ID'] ?? _fail('ZIGGLE_IDP_CLIENT_ID in .env');
  final email = Platform.environment['E2E_IDP_EMAIL'] ?? _fail('E2E_IDP_EMAIL');
  final password =
      Platform.environment['E2E_IDP_PASSWORD'] ?? _fail('E2E_IDP_PASSWORD');

  final login = await _request(
    'POST',
    Uri.parse('${idpApi}auth/login'),
    body: {'email': email, 'password': password},
  );
  final userToken = _json(login)['accessToken'] as String;

  // Ask only for the scopes every consent to this client includes. The app
  // asks for more, but the IdP rejects scopes the account has not consented
  // to, and the backend needs only these.
  final client = await _request(
    'GET',
    Uri.parse('${idpApi}client/$clientId/public'),
  );
  final scopes = (_json(client)['scopes'] as List).cast<String>();

  final verifier = _randomString();
  final challenge = base64Url
      .encode(sha256.convert(utf8.encode(verifier)).bytes)
      .replaceAll('=', '');
  final state = _randomString();
  final authorize = await _request(
    'GET',
    Uri.parse('${idpApi}oauth/authorize').replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': _redirectUri,
        'scope': scopes.join(' '),
        'state': state,
        'code_challenge': challenge,
        'code_challenge_method': 'S256',
      },
    ),
    headers: {'authorization': 'Bearer $userToken'},
    expectRedirect: true,
  );
  final location = Uri.parse(authorize.headers.value('location') ?? '');
  if (location.queryParameters['state'] != state) {
    _fail('authorize redirect with the same state, got ${location.query}');
  }
  final code =
      location.queryParameters['code'] ??
      _fail(
        'an authorization code. The IdP answered '
        '${location.queryParameters['error'] ?? location}. Log in once in '
        'the app with this account so it consents to Ziggle',
      );

  final token = await _request(
    'POST',
    Uri.parse('${idpApi}oauth/token'),
    body: {
      'grant_type': 'authorization_code',
      'code': code,
      'code_verifier': verifier,
      'client_id': clientId,
    },
  );
  return _json(token)['access_token'] as String;
}

class _Response {
  final int statusCode;
  final HttpHeaders headers;
  final String body;
  _Response(this.statusCode, this.headers, this.body);
}

final _client = HttpClient();

Future<_Response> _request(
  String method,
  Uri uri, {
  Map<String, String> headers = const {},
  Map<String, Object?>? body,
  bool expectRedirect = false,
}) async {
  final request = await _client.openUrl(method, uri);
  request.followRedirects = false;
  headers.forEach(request.headers.set);
  if (body != null) {
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(body));
  }
  final response = await request.close();
  final text = await response.transform(utf8.decoder).join();
  final ok = expectRedirect
      ? response.isRedirect
      : response.statusCode >= 200 && response.statusCode < 300;
  if (!ok) {
    // The path is enough to locate the failure; query strings and bodies may
    // carry codes or tokens.
    _fail(
      '$method ${uri.host}${uri.path} to succeed, got ${response.statusCode}: '
      '${text.length > 300 ? text.substring(0, 300) : text}',
    );
  }
  return _Response(response.statusCode, response.headers, text);
}

Map<String, dynamic> _json(_Response res) =>
    jsonDecode(res.body) as Map<String, dynamic>;

Map<String, String> _readDotenv() {
  final file = File('.env');
  if (!file.existsSync()) _fail('.env in the project root');
  final values = <String, String>{};
  for (final line in file.readAsLinesSync()) {
    final index = line.indexOf('=');
    if (line.trimLeft().startsWith('#') || index < 0) continue;
    values[line.substring(0, index).trim()] = _unquote(
      line.substring(index + 1).trim(),
    );
  }
  return values;
}

/// Drops matching quotes around a value, as flutter_dotenv does for the app.
String _unquote(String value) {
  final quoted =
      value.length >= 2 &&
      ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'")));
  return quoted ? value.substring(1, value.length - 1) : value;
}

String _randomString() {
  final random = Random.secure();
  return base64Url
      .encode(List.generate(32, (_) => random.nextInt(256)))
      .replaceAll('=', '');
}

Map<String, String> _parseOptions(List<String> args) {
  final options = <String, String>{};
  for (var i = 0; i + 1 < args.length; i += 2) {
    if (!args[i].startsWith('--')) _usage();
    options[args[i].substring(2)] = args[i + 1];
  }
  return options;
}

Never _fail(String expected) {
  stderr.writeln('fixtures: expected $expected');
  exit(1);
}

Never _usage() {
  stderr.writeln(
    'usage: dart run scripts/e2e/fixtures.dart '
    '(setup --run-id <id> --out <file> | cleanup --run-id <id>)',
  );
  exit(64);
}
