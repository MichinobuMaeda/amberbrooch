part of amberbrooch;

class LoadingView extends StatelessWidget {
  final FirebaseModel firebaseModel;
  final ConfModel confModel;
  final Widget child;

  const LoadingView({
    Key? key,
    required this.firebaseModel,
    required this.confModel,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => firebaseModel.error
      ? const Center(
          child: Text(
            'システムに接続できませんでした。',
            style: TextStyle(
              fontSize: fontSizeH4,
              color: colorDanger,
            ),
          ),
        )
      : !firebaseModel.initialized
          ? Column(
              children: const [
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.deepOrangeAccent,
                  ),
                  minHeight: fontSizeBody / 2,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'システムに接続しています。',
                      style: TextStyle(
                        fontSize: fontSizeH4,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : confModel.error
              ? const Center(
                  child: Text(
                    'システムの情報を取得できませんでした。',
                    style: TextStyle(
                      fontSize: fontSizeH4,
                      color: colorDanger,
                    ),
                  ),
                )
              : !confModel.initialized
                  ? Column(
                      children: const [
                        LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepOrangeAccent,
                          ),
                          minHeight: fontSizeBody / 2,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'システムの情報を取得しています。',
                              style: TextStyle(
                                fontSize: fontSizeH4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : child;
}
