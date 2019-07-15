import 'package:test/test.dart';
import 'dart:io';
import 'dart:convert';
// import 'package:first_app/models/appstate.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// localhost certificate
final List<int> cert = utf8.encode("""-----BEGIN CERTIFICATE-----
MIIC+zCCAeOgAwIBAgIJALlbe3SOkNe1MA0GCSqGSIb3DQEBBQUAMBQxEjAQBgNV
BAMMCWxvY2FsaG9zdDAeFw0xOTAyMTMwNzM2NTZaFw0yOTAyMTAwNzM2NTZaMBQx
EjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALQWN1YV/iv+JutKrpPKQy837ZZXFGb5Bshs3IX8JqfHaTao8r9m4lxPbkDi
l804K4PY4KqTjBMDJ+js758rmxIurrlEthGG1E9mh9GLubr/atNwJuxX4xd3yagg
+iTNKT0KAMZhKJzUvn0DbDbXNfJB8KvTfpch+cTaceu5/XoHh1Y92vhC3oWT222K
JerC8Jbx7x3EfWXuRyhMHTKgs3ps9oc/BS9STs83VZLCKCSL7wTVNaGzlnTRUM7r
63AmZUL+eloXqRQYQYlzt1RX/zN7AuLl0BXTk0xOwCdA5QAz4G64yeYQL5HqpbeV
wruTvbuCifrvsyHgsziQF3aasesCAwEAAaNQME4wHQYDVR0OBBYEFI3wyF9wbrBr
h/Wv4nv/DxeVBnSBMB8GA1UdIwQYMBaAFI3wyF9wbrBrh/Wv4nv/DxeVBnSBMAwG
A1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBABJtrVFKtXBnWMyZKT/gauhW
sEEmV7SqCOMvyZ1z/r5Kj12JE2Dw7Pdr1XH6UDQg4RPP1dHCmsqvg+abkRPQ4bEx
i77npWV4ZCkYnVyYdU8PuHUnKFdiRh02LC8+10Z5gkcwmgUWONxnpphTxDK2JJxt
RfQ2jdhlMUi8DOYt+0D3iXLxVc0zE8zpwM2MZBheCEy2m2bGUWcUB7WRhkkAPhYR
DmD7Z4T04iN+IsxX6J8/Isl64T5MI5gw3suo2Y2bcR3Oq1DKcrVDOVHEhlFzqFp5
KB3YzhvscGAXfpG0Q1gX4bkXuwhjOLjKG5GFnscKmfHcE7ZGKjnlyC0Po7o13ys=
-----END CERTIFICATE-----
""");

final List<int> key = utf8.encode("""-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAtBY3VhX+K/4m60quk8pDLzftllcUZvkGyGzchfwmp8dpNqjy
v2biXE9uQOKXzTgrg9jgqpOMEwMn6OzvnyubEi6uuUS2EYbUT2aH0Yu5uv9q03Am
7FfjF3fJqCD6JM0pPQoAxmEonNS+fQNsNtc18kHwq9N+lyH5xNpx67n9egeHVj3a
+ELehZPbbYol6sLwlvHvHcR9Ze5HKEwdMqCzemz2hz8FL1JOzzdVksIoJIvvBNU1
obOWdNFQzuvrcCZlQv56WhepFBhBiXO3VFf/M3sC4uXQFdOTTE7AJ0DlADPgbrjJ
5hAvkeqlt5XCu5O9u4KJ+u+zIeCzOJAXdpqx6wIDAQABAoIBAEPpJND31jOs0exk
61ScL528z4GkMPNr8VzfgIGeRs16a3jLWU9IcxAwe/lH+crP5ckAnih1H5uD0ycJ
QouZnA7NP+JpwOb3G1Ud6xXgRRf5fcViQ6tYsTCGYatfVDVQkL6N6SDmPrR1nafz
BHnhylwi9ak2RkSj8VaEsfUc3DOJxIZOrQwlEbf8vZ5nA3giVzfT0yAuV0BOokKg
TyItsRcyqYAmLWdZRse8YUu0J+6Q2XZHWlwLEkdUO9zS0drSrttIf3ttTbZNGI4P
by628OhfwGCFNGWt46Hk2xF89kZR7YZeGcILo64QOOv76+DFLqCy/DQkBwK4MWMR
sN0V/SECgYEA7T8gVrDQfaNouOF+Yi4994W/t0BR0fkNGEt5GWyy2FJ2vQ/yeSHS
gxsG8kmaAGx1g2G9+fJwi3xdEx5fA8cu0aOLmDcdX9CgCbOj1ykDrpSBCEYqDgIA
jGK6sL1Q3g1M+wGDYccPZkGrquZohjAt8KxZSi8n3pbgfbYgRBvyBukCgYEAwlJq
Z3lVBhyAuJFXzB1qMUqXmOyTrX2EPZ7qfVXiDhG8Kw8tvtsRJRZVix+ql9pN0UNU
DTj+keAggt+cxGH24CbcnXCYnUu6MWFXVM3vknIt8zvyq1zJYUhAAFlXzRKuAkhG
Kly5qvIGrnO7+mNR6z7AiT8xTy4NR8TS2oOg1bMCgYEA6Z6K4rL0a3O5UK1D/bxZ
at963SHqMCDWI0FWu5GNP3Vc1WnZtCx5Fn9LxNRzYM1snnZmU7XH26MYKBZ1K8w9
L1Sjxr0nIM3YehU6VkpeBNDZiuNE0Exqa9Ng0V9rPW3NizJ/RI53fJNYT07aSKEy
69dbibCLyyW5ZDEu7sKx/tkCgYB7akqH80hrvDiIgE7JpTjnm19S0ZYtTpVpaX+2
IJCUrPDcTCSanZly+49S78ax8QURTfiY+US9MyKS3CA9nZZk4GmnWHalGA5mBFOp
2a05TmkenUlPSnvf3DpBvnyEE0QO0QY3K3MEPfi+XWTa7q99f/pacJcJmc73cOsV
uxmv/wKBgQCpumBavWASpBiQOYPYvI/5+qChpPpy3yrIjOmwnx9JcgZQi731SOMv
T44MUkYLl7/T51eqO6Cu1B3U4GO97E73sOauWKwDW7ynvHMinbO8qwKWdOeEWyRH
8MytIWrJlFhcyA8iU6xc2ZqutmO//jxTKtMUjH6kqxinECFvb5vZyA==
-----END RSA PRIVATE KEY-----
""");

void main() {
  HttpServer server;
  setUp(() async {
    SecurityContext context = new SecurityContext();
    context.useCertificateChainBytes(cert);
    context.usePrivateKeyBytes(key);
    server = await HttpServer.bindSecure('localhost', 0, context);
    // var url = "${server.address.host}:${server.port}";
    server.listen((HttpRequest request) {
      request.response.write('Hello, world!');
    });
  });

  // var prefs = SharedPreferences.setMockInitialValues({});
  // var appState = new AppStateModel(prefs);

  tearDown(() async {
    await server.close(force: true);
    server = null;
  });

  // ...

}
