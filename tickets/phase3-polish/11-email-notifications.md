# Ticket 11: Email Notifications

**Size**: M  
**Dependencies**: Ticket 5 (Comments), Solid Queue setup

## Context
- **From REQUIREMENTS**: New comment alerts (P2)
- **From ARCHITECTURE**: Background job processing with Solid Queue

## Deliverables
- [ ] Email notification job for new comments
- [ ] Admin email preferences
- [ ] Email templates for notifications
- [ ] Background job processing setup
- [ ] Email notification tests

## Success Criteria
Admin receives email notifications for new comments via background jobs.

## Technical Notes
- Create CommentNotificationJob using Solid Queue
- Set up Action Mailer for comment notifications
- Create email templates for new comment alerts
- Add admin email preferences (enable/disable notifications)
- Implement job queuing on comment creation
- Configure SMTP settings for email delivery