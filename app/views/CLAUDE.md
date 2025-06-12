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

## HELPER USAGE [HIGHEST PRIORITY]

### Button Helper
- ✅ DO: Use `button_link` helper for all button-like links
- ✅ DO: Use `button_classes` helper for form submit buttons
- ✅ DO: Use appropriate variants: `:primary`, `:secondary`, `:danger`, `:success`
- ❌ DON'T: Write custom button classes in views

### Card Helper
- ✅ DO: Use `card` helper for all white card containers
- ✅ DO: Use `padding: :large` for forms, `:medium` for content cards, `:small` for compact cards
- ✅ DO: Use `header:` parameter for consistent card titles
- ✅ DO: Use `tag: :article` for semantic article cards
- ❌ DON'T: Write custom card container classes

### Form Helper [MANDATORY]
- ✅ DO: Use `styled_form_with` for forms with styled fields and automatic button classes
- ✅ DO: Use simple field methods for labeled forms: `form.text_field :title`
- ✅ DO: Use `labeled: false` for auth/simple forms: `form.email_field :email, labeled: false`
- ✅ DO: Use `hint:` parameter for field explanations
- ✅ DO: Use `label:` parameter for custom label text
- ✅ DO: Let `form.submit` use button styling automatically
- ✅ DO: Use regular `form_with` when you need vanilla Rails behavior
- ❌ DON'T: Write manual label/field/hint combinations
- ❌ DON'T: Write custom field classes in views

### Helper Methods
- `styled_form_with(*, **kwargs, &block)` - Form with custom FormBuilder
- `button_link(text, url, variant: :primary, size: :medium, method: nil, confirm: nil, **options)`
- `button_classes(variant: :primary, size: :medium, full_width_mobile: false)`
- `card(padding: :medium, tag: :div, header: nil, header_class: nil, **options)`
- `form.text_field(method, label: nil, hint: nil, labeled: true, **options)`
- `form.text_area(method, label: nil, hint: nil, labeled: true, **options)`
- `form.email_field(method, label: nil, hint: nil, labeled: true, **options)`
- `form.password_field(method, label: nil, hint: nil, labeled: true, **options)`
- `form.select(method, choices, options = {}, html_options = { label: nil, hint: nil, labeled: true })`

### Button Examples
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

### Form Examples
```erb
<!-- CORRECT - Content forms with labels and hints -->
<%= styled_form_with model: @post, local: true, class: "space-y-6" do |form| %>
  <%= form.text_field :title %>
  <%= form.text_area :excerpt, rows: 3, hint: "Optional - will auto-generate from content if left blank" %>
  <%= form.text_area :content, rows: 15 %>
  <%= form.select :status, [["Draft", "draft"], ["Published", "published"]], {}, { hint: "Drafts are only visible to admins" } %>
  <%= form.submit "Save Post" %>
<% end %>

<!-- CORRECT - Auth forms (simple styling) -->
<%= styled_form_with url: session_url, class: "contents" do |form| %>
  <%= form.email_field :email_address, labeled: false, placeholder: "Enter your email address" %>
  <%= form.password_field :password, labeled: false, placeholder: "Enter your password" %>
  <%= form.submit "Sign in" %>
<% end %>

<!-- CORRECT - Custom labels -->
<%= form.text_field :title, label: "Post Title" %>
<%= form.text_area :content, label: "Article Content", hint: "Use Markdown for formatting" %>

<!-- INCORRECT - Manual field markup -->
<div>
  <%= form.label :title, class: "block text-sm font-medium text-gray-700 mb-2" %>
  <%= form.text_field :title, class: "w-full px-3 py-2 border border-gray-300..." %>
</div>
```

### Card Examples
```erb
<!-- CORRECT - Using card helper -->
<!-- Form card with header -->
<%= card padding: :large, header: "Edit Post" do %>
  <%= form_with model: @post do |form| %>
    <%= form.text_field :title %>
  <% end %>
<% end %>

<!-- Article listing card -->
<%= card tag: :article, padding: :medium do %>
  <h2><%= post.title %></h2>
  <p><%= post.excerpt %></p>
<% end %>

<!-- Card with custom header styling -->
<%= card header: "Dashboard", header_class: "text-2xl font-semibold text-blue-900 mb-4" do %>
  <!-- content -->
<% end %>

<!-- INCORRECT - Manual card classes -->
<div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8">
  <h1 class="text-3xl font-bold text-gray-900 mb-8">Edit Post</h1>
  <!-- content -->
</div>
```

### Variants
- **`:primary`** (default) - Blue background, for main actions
- **`:secondary`** - White background with border, for cancel/alternative actions  
- **`:danger`** - Red background, for destructive actions like delete
- **`:success`** - Green background, for positive confirmations

### Form Field Parameters
- **`labeled: false`** - Disables label generation for simple auth-style forms
- **`label: "Custom Text"`** - Override default humanized label text
- **`hint: "Help text"`** - Adds gray help text below field
- **Standard Rails options** - All normal form field options still work (placeholder, required, etc.)

### Convenience Parameters
- **`method:`** - Automatically converts to `data-turbo-method` (e.g., `method: :delete`)
- **`confirm:`** - Automatically converts to `data-turbo-confirm` (e.g., `confirm: "Are you sure?"`)
- **`full_width_mobile:`** - Adds responsive width classes `w-full sm:w-auto` for form buttons

### Field Styling
- **Labeled fields** (default): Full label + styled input + optional hint in `<div>` wrapper
- **Simple fields** (`labeled: false`): Just styled input, no label or wrapper
- **Auto button styling**: `form.submit` automatically uses `button_classes` unless custom class provided