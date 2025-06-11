# Ticket 10: Comment Threading

**Size**: L  
**Dependencies**: Ticket 5 (Basic Comments)

## Context
- **From REQUIREMENTS**: Reply-to-comment functionality (P1)
- **From ARCHITECTURE**: Comment threading with Turbo updates

## Deliverables
- [ ] Comment threading database schema
- [ ] Reply-to-comment UI and functionality
- [ ] Nested comment display
- [ ] Turbo updates for threaded comments
- [ ] Threading tests

## Success Criteria
Readers can reply to specific comments creating conversation threads.

## Technical Notes
- Add parent_id to Comment model for self-referential association
- Implement nested comment display with proper indentation
- Add "Reply" buttons to comments
- Use Turbo frames for dynamic reply form insertion
- Limit threading depth to prevent excessive nesting
- Consider comment sorting within threads