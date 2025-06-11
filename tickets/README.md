# Blog Platform Implementation Tickets

This directory contains implementable tickets organized by development phases, following the architecture decisions in `ARCHITECTURE.md`.

## Phase Structure

### Phase 0: Infrastructure (Setup)
Technical foundation and development workflow setup.

0. **Code Quality Setup** - RuboCop, Brakeman, SimpleCov configuration
1. **CLAUDE.md Documentation Enhancement** - AI-assisted development guidance
2. **Testing Foundation** - Comprehensive test setup with coverage
3. **Development Workflow Setup** - Streamlined development environment

### Phase 1: Foundation (P0 - Must Have)
Core blog functionality required for MVP.

1. **Database Schema & Core Models** - Post and Comment models with associations
2. **Admin Authentication Foundation** - Rails authentication for single admin
3. **Post CRUD Controllers & Views** - Admin interface for post management
4. **Public Blog Interface** - Reader-facing blog pages
5. **Basic Comment System** - Auto-publish comment functionality
6. **Admin Comment Management** - Comment moderation tools

### Phase 2: Enhancement (P1 - Should Have)
Improved user experience and content management.

7. **ActionText Rich Editor** - Rich text editing with image support
8. **Categories & Tags System** - Content organization and filtering
9. **Search Functionality** - Title and content search

### Phase 3: Polish (P2 - Nice to Have)
Advanced features for engagement and usability.

10. **Comment Threading** - Reply-to-comment functionality
11. **Email Notifications** - Background job processing for comment alerts
12. **RSS Feed & Social Features** - Feed generation and social sharing

## Dependency Flow

```
Phase 0: 0→1,2,3 (parallel after code quality setup)
         ↓
Phase 1: 1→3→4→5→6 (with 2 parallel to 1)
         ↓
Phase 2: 7(deps:3), 8(deps:1,4), 9(deps:4) 
         ↓
Phase 3: 10(deps:5), 11(deps:5), 12(deps:4)
```

## Development Workflow

Each ticket follows: **Model → Controller → Views → Tests → Turbo enhancements**

- Start with Phase 0 infrastructure setup first
- Then proceed with Phase 1 tickets in dependency order
- Phase 2 tickets can be developed in parallel after Phase 1 completion
- Phase 3 tickets add polish and advanced features
- Test each ticket thoroughly before moving to the next
- Follow Rails 8 conventions and the patterns defined in ARCHITECTURE.md