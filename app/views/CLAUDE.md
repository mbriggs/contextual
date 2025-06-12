# VIEWS STANDARDS [HIGHEST PRIORITY]

## TURBO METHOD SYNTAX [MANDATORY]

### HTTP Method Links
- ✅ DO: Use `data: { turbo_method: :delete }` for DELETE requests in `link_to`
- ✅ DO: Use `data: { turbo_method: :patch }` for PATCH requests in `link_to`
- ✅ DO: Use `data: { turbo_method: :put }` for PUT requests in `link_to`
- ❌ DON'T: Use deprecated `method: :delete` syntax in `link_to`

```erb
<!-- CORRECT - Rails 8 with Turbo -->
<%= link_to "Sign out", session_path, data: { turbo_method: :delete } %>
<%= link_to "Delete Post", admin_post_path(post), data: { turbo_method: :delete } %>
<%= link_to "Update Status", post_path(post), data: { turbo_method: :patch } %>

<!-- INCORRECT - Deprecated syntax -->
<%= link_to "Sign out", session_path, method: :delete %>
<%= link_to "Delete Post", admin_post_path(post), method: :delete %>
```

### Button Exception
- ✅ DO: Use `method: :delete` syntax with `button_to` (not data attribute)

```erb
<!-- CORRECT - button_to uses method attribute -->
<%= button_to "Delete", post_path(post), method: :delete %>
<%= button_to "Sign out", session_path, method: :delete %>
```