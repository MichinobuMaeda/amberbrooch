part of amberbrooch;

Function deepCollectionEquality = const DeepCollectionEquality().equals;

void realoadApp() {
  html.window.location.reload();
}

Future<void> signOut() async {
  await auth.signOut();
}
