# Ticket 4: Public Blog Interface

**Size**: M  
**Dependencies**: Ticket 1 (Models), Ticket 3 (Post CRUD)

## Context
- **From REQUIREMENTS**: Blog readers need to view posts
- **From ARCHITECTURE**: Public blog access pattern, published posts only

## Deliverables
- [ ] Public posts index page (published posts only)
- [ ] Public post show page with clean reading layout
- [ ] Responsive design with Tailwind for mobile/desktop
- [ ] SEO-friendly URLs and basic meta tags
- [ ] Public interface tests

## Success Criteria
Readers can browse and read published posts with good mobile/desktop experience.

## Technical Notes
- Use `Post.published.recent` scope for public listing
- Implement clean, readable typography with Tailwind
- Add basic SEO meta tags (title, description)
- Ensure mobile-responsive design
- Public routes: root (posts#index), posts#show
- No authentication required for public routes