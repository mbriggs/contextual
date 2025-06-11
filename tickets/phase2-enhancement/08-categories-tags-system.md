# Ticket 8: Categories & Tags System

**Size**: M  
**Dependencies**: Ticket 1 (Models), Ticket 4 (Public Interface)

## Context
- **From REQUIREMENTS**: Basic content organization (P1)
- **From ARCHITECTURE**: Content organization with filtering

## Deliverables
- [ ] Category/Tag models and associations
- [ ] Category assignment in post forms
- [ ] Category filtering on public blog
- [ ] Category navigation in public interface
- [ ] Category system tests

## Success Criteria
Posts can be categorized and readers can filter by category.

## Technical Notes
- Create Category model with name, slug, description
- Post belongs_to category (simple approach vs many-to-many tags)
- Add category selection to post forms
- Implement category filtering on posts index
- Create category show pages with filtered posts
- Add category navigation to public interface