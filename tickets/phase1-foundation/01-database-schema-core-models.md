# Ticket 1: Database Schema & Core Models

**Size**: M  
**Dependencies**: None  

## Context
- **From REQUIREMENTS**: Post CRUD (P0) and Comment System (P0)
- **From ARCHITECTURE**: Core models with rich text support and status enum

## Deliverables
- [ ] Create Post model with title, content, status enum (draft/published), published_at
- [ ] Create Comment model with post association, author fields, content, approved boolean
- [ ] Database migrations for posts and comments tables
- [ ] Model validations and scopes as per architecture patterns
- [ ] Basic model tests

## Success Criteria
Post and Comment models can be created, validated, and queried with proper associations.

## Technical Notes
- Use Rails generators for models and migrations
- Follow architecture patterns from ARCHITECTURE.md:151-164
- Post status enum: `{ draft: 0, published: 1 }`
- Comment belongs_to post, post has_many comments dependent: :destroy
- Validations: presence for title/content on Post, presence for required Comment fields