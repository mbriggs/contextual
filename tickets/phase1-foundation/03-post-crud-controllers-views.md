# Ticket 3: Post CRUD Controllers & Views

**Size**: L  
**Dependencies**: Ticket 1 (Models), Ticket 2 (Auth)

## Context
- **From REQUIREMENTS**: Post CRUD (P0) with draft/published status and post preview
- **From ARCHITECTURE**: RESTful controllers with Turbo responses, admin-only create/edit

## Deliverables
- [ ] PostsController with full CRUD (admin actions auth-protected)
- [ ] Admin post management views (index, new, edit, show)
- [ ] Post form with draft/publish status selection
- [ ] Basic Tailwind styling for admin interface
- [ ] Controller and integration tests

## Success Criteria
Admin can create, edit, delete posts with draft/published workflow. Posts display correctly.

## Technical Notes
- Follow controller pattern from ARCHITECTURE.md:67-82
- Use `before_action :authenticate_admin!, except: [:index, :show]`
- Implement Turbo form submissions
- Admin routes should be namespaced or prefixed
- Include post preview functionality before publishing