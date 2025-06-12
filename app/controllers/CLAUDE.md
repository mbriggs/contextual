# CONTROLLERS: LLM INSTRUCTIONS

## INSTANCE VARIABLE PATTERNS [MANDATORY]

- ✅ DO: Set all instance variables directly in the action method
- ❌ DON'T: Use private methods to set instance variables for views
- ❌ DON'T: Use `before_action` callbacks to set instance variables

```ruby
# CORRECT - Set instance variables in action
def show
  @post = Post.find(params[:id])
  @comments = @post.comments.approved
end

# INCORRECT - Private method setting instance variables
def show
  set_post
  @comments = @post.comments.approved
end

private

def set_post
  @post = Post.find(params[:id])
end
```