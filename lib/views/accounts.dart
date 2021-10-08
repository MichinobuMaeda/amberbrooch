part of amberbrooch;

@visibleForTesting
class AccountsView extends StatefulWidget {
  final String routeId;
  final ServiceModel service;
  final ClientModel clientModel;

  const AccountsView({
    Key? key,
    required this.routeId,
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
      children: [],
    );
  }
}
