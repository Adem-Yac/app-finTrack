import 'package:fintrack/data/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationInbox', () {
    test('parses unread count from meta', () {
      final inbox = NotificationInbox.fromJson({
        'data': [
          {
            'id': 1,
            'title': 'Budget',
            'body': '98%',
            'type': 'warning',
            'read_at': null,
            'created_at': '2026-09-20T10:00:00.000000Z',
          },
        ],
        'meta': {'unread_count': 1},
      });

      expect(inbox.unreadCount, 1);
      expect(inbox.items.single.isUnread, isTrue);
      expect(inbox.items.single.type, 'warning');
    });

    test('treats a read notification as seen', () {
      final item = NotificationModel.fromJson({
        'id': 2,
        'title': 'Marché',
        'body': 'Spread élevé',
        'type': 'info',
        'read_at': '2026-09-20T11:00:00.000000Z',
      });

      expect(item.isUnread, isFalse);
    });
  });
}
