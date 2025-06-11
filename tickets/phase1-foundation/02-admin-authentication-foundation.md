# Ticket 2: Admin Authentication Foundation

**Size**: M  
**Dependencies**: None  

## Context
- **From REQUIREMENTS**: Admin Controls (P0) - blogger can manage posts and delete comments
- **From ARCHITECTURE**: Rails authentication generator over Devise for simplicity

## Deliverables
- [ ] Generate Rails authentication with User model
- [ ] Admin authentication helpers and before_action patterns
- [ ] Basic admin session management
- [ ] Authentication tests

## Success Criteria
Admin can log in/out and access is properly restricted to authenticated admin only.

## Technical Notes
- Use `rails generate authentication` (Rails 8 built-in)
- Create `authenticate_admin!` helper method
- Implement session management with secure flags
- Follow security model from ARCHITECTURE.md:140-144
- Single admin user approach (not multi-user system)