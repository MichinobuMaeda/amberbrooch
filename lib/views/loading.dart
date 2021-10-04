part of amberbrooch;

class LoadingView extends StatelessWidget {
  final ServiceModel service;
  final Widget child;

  const LoadingView({
    Key? key,
    required this.service,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => service.error
      ? Center(
          child: Text(
            service.initialized ? 'システムの情報を取得できませんでした。' : 'システムに接続できませんでした。',
            style: const TextStyle(
              fontSize: fontSizeH4,
              color: colorDanger,
            ),
          ),
        )
      : service.conf == null
          ? Column(
              children: [
                const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.deepOrangeAccent,
                  ),
                  minHeight: fontSizeBody / 2,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      service.initialized
                          ? 'システムの情報を取得しています。'
                          : 'システムに接続しています。',
                      style: const TextStyle(
                        fontSize: fontSizeH4,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : child;
}
