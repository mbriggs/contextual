# Ticket 5: Basic Comment System

**Size**: L  
**Dependencies**: Ticket 1 (Models), Ticket 4 (Public Interface)

## Context
- **From REQUIREMENTS**: Simple comment form with auto-publish (P0)
- **From ARCHITECTURE**: Turbo-powered form submissions with progressive enhancement

## Deliverables
- [ ] CommentsController with create action
- [ ] Comment form on post show page (name, email, content)
- [ ] Comments display with proper styling
- [ ] Turbo-powered form submission without page reload
- [ ] Basic validation and error handling
- [ ] Comment system tests

## Success Criteria
Readers can post comments that appear immediately with proper validation.

## Technical Notes
- Follow form pattern from ARCHITECTURE.md:85-94
- Use `form_with model: [@post, Comment.new], local: false`
- Comments auto-approved by default (approved: true)
- Implement basic spam prevention (rate limiting consideration)
- Display comments in chronological order
- Turbo frame for dynamic updates