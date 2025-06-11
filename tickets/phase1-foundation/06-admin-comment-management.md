# Ticket 6: Admin Comment Management

**Size**: M  
**Dependencies**: Ticket 2 (Auth), Ticket 5 (Comments)

## Context
- **From REQUIREMENTS**: Admin can delete inappropriate comments
- **From ARCHITECTURE**: Comment moderation interface

## Deliverables
- [ ] Admin comments index with moderation tools
- [ ] Delete comment functionality with confirmation
- [ ] Comment status indicators in admin interface
- [ ] Bulk actions for comment management
- [ ] Admin comment management tests

## Success Criteria
Admin can view all comments and delete inappropriate ones efficiently.

## Technical Notes
- Admin-only comments controller actions
- Use Turbo for dynamic comment deletion
- Include post context in admin comment listings
- Implement delete confirmation dialog
- Consider soft-delete vs hard-delete approach
- Show comment approval status in admin interface