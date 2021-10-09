part of amberbrooch;

class AccountsView extends StatefulWidget {
  final ServiceModel service;
  final ClientModel clientModel;

  const AccountsView({
    Key? key,
    required this.clientModel,
    required this.service,
  }) : super(key: key);

  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<AccountsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [],
    );
  }
}
