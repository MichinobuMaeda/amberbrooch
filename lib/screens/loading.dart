import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';
import 'base.dart';

class LoadingScreen extends BaseScreen {
  const LoadingScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends BaseState {
  @override
  void initState() {
    ClientModel clientModel = Provider.of<ClientModel>(context, listen: false);
    clientModel.init();
    Provider.of<FirebaseModel>(context, listen: false).init(
      deepLink: clientModel.deepLink,
    );
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    return Consumer<FirebaseModel>(
      builder: (context, firebase, child) {
        if (!firebase.initialized) {
          if (!firebase.error) {
            return const LoadingStatus(
              message: '接続の準備をしています。',
            );
          } else {
            return LoadingStatus(
              message: '接続の設定のエラーです。',
              color: Theme.of(context).errorColor,
              subsequents: const <Widget>[
                Text('管理者に連絡してください。'),
              ],
            );
          }
        }

        AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
        ConfModel confModel = Provider.of<ConfModel>(context, listen: false);
        authModel.listen();
        confModel.listen();

        if (!confModel.initialized) {
          return const LoadingStatus(
            message: 'サービスの設定を取得しています。',
          );
        }

        return LoadingStatus(
          message: 'サービスの設定が取得できませんでした。',
          color: Theme.of(context).errorColor,
          subsequents: const <Widget>[
            Text('管理者に連絡してください。'),
          ],
        );
      },
    );
  }
}
