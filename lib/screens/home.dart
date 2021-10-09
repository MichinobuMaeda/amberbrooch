part of amberbrooch;

class HomeScreen extends BaseScreen {
  const HomeScreen({
    Key? key,
    required ClientModel clientModel,
    required ServiceModel service,
    required AppRoute route,
  }) : super(
          key: key,
          clientModel: clientModel,
          service: service,
          route: route,
        );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return scaffoldApp(
      clientModel: widget.clientModel,
      service: widget.service,
      route: widget.route,
      child: widget.service.error
          ? Center(
              child: Text(
                widget.service.initialized
                    ? 'システムの情報を取得できませんでした。'
                    : 'システムに接続できませんでした。',
                style: const TextStyle(
                  fontSize: fontSizeH4,
                  color: colorDanger,
                ),
              ),
            )
          : widget.service.conf == null
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
                          widget.service.initialized
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
              : widget.service.me == null
                  ? ScrollView(
                      child: SigninView(
                        conf: widget.service.conf,
                        clientModel: widget.clientModel,
                        service: widget.service,
                      ),
                    )
                  : widget.service.user?.emailVerified == false
                      ? ScrollView(
                          child: VerifyEmailView(
                            service: widget.service,
                          ),
                        )
                      : const TopView(),
    );
  }
}
