

import 'package:awesome_notifications/awesome_notifications.dart';

class SendNotification{

  showNotification(var id,var title,var body) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'key1',
            title:'$title',
            body: '$body'
        )
    );
  }

}
