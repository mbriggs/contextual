# Ticket 7: ActionText Rich Editor

**Size**: L  
**Dependencies**: Ticket 3 (Post CRUD)

## Context
- **From REQUIREMENTS**: Rich text editor for better writing experience (P1)
- **From ARCHITECTURE**: ActionText integration with Active Storage support

## Deliverables
- [ ] ActionText integration for Post content
- [ ] Rich text editor in post forms
- [ ] Image upload support via Active Storage
- [ ] Content sanitization and security
- [ ] Rich text tests

## Success Criteria
Admin can create posts with rich formatting and embedded images.

## Technical Notes
- Replace Post content field with `has_rich_text :content`
- Configure ActionText with Trix editor
- Set up Active Storage for image uploads
- Implement Content Security Policy for ActionText
- Configure image processing and storage limits
- Test rich text rendering in public views