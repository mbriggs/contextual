# VIEWS STANDARDS [HIGHEST PRIORITY]

## RAILS 8 PATTERNS [MANDATORY]

### HTTP Methods and Turbo
- ✅ DO: Use Rails 8/Turbo conventions for non-GET HTTP methods
- ✅ DO: Prefer project helper abstractions over manual framework syntax  
- ✅ DO: Use `data: { turbo_* }` attributes when writing manual `link_to`
- ❌ DON'T: Use deprecated Rails 7 `method:` syntax in `link_to`
- ❌ DON'T: Mix manual Turbo attributes with helper methods that abstract them

### General Principles
- **Helper-first**: Use `button_link` for button-like actions, `button_to` for forms
- **Consistency**: Follow existing patterns in the codebase
- **Modern syntax**: Rails 8 with Turbo, not legacy Rails patterns

## BUTTON HELPER USAGE [HIGHEST PRIORITY]

### Consistent Button Styling
- ✅ DO: Use `button_link` helper for all button-like links
- ✅ DO: Use `button_classes` helper for form submit buttons
- ✅ DO: Use appropriate variants: `:primary`, `:secondary`, `:danger`, `:success`
- ❌ DON'T: Write custom button classes in views

### Helper Methods
- `button_link(text, url, variant: :primary, size: :medium, method: nil, confirm: nil, **options)`
- `button_classes(variant: :primary, size: :medium, full_width_mobile: false)`

### Examples
```erb
<!-- CORRECT - Using button helpers -->
<%= button_link "New Post", new_admin_post_path %>
<%= button_link "Delete", post_path(@post), variant: :danger, method: :delete, confirm: "Are you sure?" %>
<%= button_link "Cancel", posts_path, variant: :secondary %>
<%= form.submit "Sign in", class: button_classes(full_width_mobile: true) %>

<!-- INCORRECT - Custom button classes -->
<%= link_to "New Post", new_admin_post_path, class: "bg-blue-600 hover:bg-blue-700..." %>
<%= form.submit "Save", class: "bg-blue-600 hover:bg-blue-700 text-white..." %>
```

### Variants
- **`:primary`** (default) - Blue background, for main actions
- **`:secondary`** - White background with border, for cancel/alternative actions  
- **`:danger`** - Red background, for destructive actions like delete
- **`:success`** - Green background, for positive confirmations

### Convenience Parameters
- **`method:`** - Automatically converts to `data-turbo-method` (e.g., `method: :delete`)
- **`confirm:`** - Automatically converts to `data-turbo-confirm` (e.g., `confirm: "Are you sure?"`)
- **`full_width_mobile:`** - Adds responsive width classes `w-full sm:w-auto` for form buttons
```