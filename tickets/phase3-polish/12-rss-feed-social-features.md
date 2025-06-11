# Ticket 12: RSS Feed & Social Features

**Size**: S  
**Dependencies**: Ticket 4 (Public Interface)

## Context
- **From REQUIREMENTS**: RSS feed and social sharing (P1/P2)
- **From ARCHITECTURE**: Standard XML feed and Open Graph meta tags

## Deliverables
- [ ] RSS feed generation for published posts
- [ ] Open Graph meta tags for social sharing
- [ ] Social share buttons
- [ ] Feed validation and testing
- [ ] Social feature tests

## Success Criteria
Blog has working RSS feed and posts can be shared on social media with proper previews.

## Technical Notes
- Create RSS feed route and controller action
- Use Rails XML builder for RSS feed generation
- Add Open Graph meta tags to post show pages
- Implement social share buttons (Twitter, Facebook, LinkedIn)
- Validate RSS feed format
- Test social media preview rendering