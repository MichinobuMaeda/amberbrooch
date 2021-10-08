part of amberbrooch;

void showConfirmationDialog({
  required BuildContext context,
  String title = '操作の確認',
  required String message,
  String labelCancel = '中止する',
  String labelOK = '実行する',
  required Function onPressed,
}) =>
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.caption,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(labelCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'OK');
              await onPressed();
            },
            child: Text(labelOK),
          ),
        ],
      ),
    );

void showNotificationSnackBar({
  required BuildContext context,
  required String message,
  int durationMilliSec = 4000,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: '閉じる',
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {},
      ),
      content: Text(
        message,
        style: const TextStyle(fontFamily: fontFamilySansSerif),
      ),
      duration: Duration(milliseconds: durationMilliSec),
      padding: const EdgeInsets.symmetric(
        horizontal: fontSizeBody,
        vertical: fontSizeBody,
      ),
    ),
  );
}
