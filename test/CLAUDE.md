# TEST STANDARDS [HIGHEST PRIORITY]

## TEST STRUCTURE [HIGHEST PRIORITY]

### Organization Principles
- ✅ DO: Follow Arrange-Act-Assert pattern with all steps visible
- ✅ DO: Create objects directly in test methods (no setup/before for object creation)
- ✅ DO: Use clear test names with the `test` method
- ❌ DON'T: Use `setup` blocks except for necessary side effects
- ❌ DON'T: Add explicit `# Arrange`, `# Act`, `# Assert` comments

### Example Test Structure
```ruby
# CORRECT - Blog-specific example
test "published scope returns only published posts" do
  draft_post = posts(:one)
  published_post = posts(:two)
  draft_post.update!(status: :draft)
  published_post.update!(status: :published)

  result = Post.published

  assert result.include?(published_post), "Published posts should be included"
  refute result.include?(draft_post), "Draft posts should be excluded"
end

# INCORRECT
def setup
  @draft_post = posts(:one)
  @published_post = posts(:two)
  @draft_post.status = :draft
  @published_post.status = :published
end

test "published scope returns only published posts" do
  assert Post.published.include?(@published_post), "Should work with instance variables"
end
```

## ASSERTION STYLE [HIGHEST PRIORITY]

### Core Rules
- ✅ DO: Use plain `assert` and `refute` with boolean conditions whenever possible
- ✅ DO: Use `assert x == y` instead of `assert_equal y, x`
- ✅ DO: Use `assert value.nil?` instead of `assert_nil value` 
- ✅ DO: Use `refute value.nil?` instead of `assert_not_nil value`
- ✅ DO: Use `assert collection.include?(item)` instead of `assert_includes collection, item`
- ✅ DO: Use `refute collection.include?(item)` instead of `assert_not_includes collection, item`
- ✅ DO: Use `assert collection.empty?` instead of `assert_empty collection`
- ✅ DO: Use `refute collection.empty?` instead of `assert_not_empty collection`
- ✅ DO: Use `assert value.is_a?(Type)` instead of `assert_instance_of Type, value`
- ✅ DO: Use `refute x == y` instead of `assert_not_equal y, x`
- ✅ DO: Add descriptive messages to assertions when meaning isn't immediately obvious

### Blog-Specific Examples
```ruby
# CORRECT - Blog model testing
test "post requires title and content" do
  post = Post.new

  refute post.valid?, "Post should be invalid without required fields"
  assert post.errors[:title].include?("can't be blank"), "Title error should be present"
  assert post.errors[:content].include?("can't be blank"), "Content error should be present"
end

# CORRECT - Comment association testing
test "deleting post removes associated comments" do
  post = posts(:one)
  comment = comments(:one)
  comment.update!(post: post)

  post.destroy!

  refute Comment.exists?(comment.id), "Comment should be deleted when post is destroyed"
end
```

## FILE STRUCTURE [ALWAYS FOLLOW]

### Blog Platform Structure
- ✅ DO: Follow Rails conventions for test organization
- ✅ DO: Use pattern: `test/[type]/[class]_test.rb`
- ✅ DO: Name test classes with `Test` suffix

#### File Organization
```
test/
├── models/
│   ├── post_test.rb
│   ├── comment_test.rb
│   └── user_test.rb
├── controllers/
│   ├── posts_controller_test.rb
│   ├── comments_controller_test.rb
│   └── sessions_controller_test.rb
├── system/
│   ├── blog_reading_test.rb
│   ├── admin_post_management_test.rb
│   └── comment_posting_test.rb
├── fixtures/
│   ├── posts.yml
│   ├── comments.yml
│   └── users.yml
└── support/
    └── blog_test_helper.rb
```

## FIXTURE USAGE [HIGHEST PRIORITY]

### Naming and Access
- ✅ DO: Use fixtures named `:one` (default case) and `:two` (alternative case)
- ✅ DO: Use direct fixture accessors (e.g., `posts(:one)`, `comments(:two)`)
- ✅ DO: Modify fixtures directly within tests as needed - we use transactional fixtures
- ✅ DO: Create helper methods for complex object creation patterns
- ❌ DON'T: Invent new fixture names - stick with `:one` and `:two`

### Blog-Specific Examples
```ruby
# CORRECT - Using fixtures with modification
test "admin can update post status" do
  post = posts(:one)
  post.update!(status: :draft)
  
  post.update!(status: :published, published_at: Time.current)
  
  assert post.published?, "Post should be published after status update"
  refute post.published_at.nil?, "Published at should be set"
end

# CORRECT - Helper method for complex creation
# In test/support/blog_test_helper.rb
module BlogTestHelper
  def create_post_with_comments(comment_count = 2)
    post = Post.create!(
      title: "Test Post",
      content: "Test content",
      status: :published,
      published_at: Time.current
    )
    
    comment_count.times do |i|
      Comment.create!(
        post: post,
        author_name: "Commenter #{i + 1}",
        author_email: "commenter#{i + 1}@example.com",
        content: "Test comment #{i + 1}",
        approved: true
      )
    end
    
    post
  end
end
```

## FIXTURE ORGANIZATION [CRITICAL]

### Blog Platform Fixtures
- ✅ DO: Include minimal attributes needed for validity
- ✅ DO: Order attributes consistently: associations first, then required attributes
- ✅ DO: Use realistic but simple test data

```yaml
# CORRECT - test/fixtures/posts.yml
one:  # Default case - published post
  title: "First Blog Post"
  content: "This is the content of the first blog post."
  status: 1  # published
  published_at: <%= 1.day.ago %>

two:  # Alternative case - draft post
  title: "Draft Post"
  content: "This is a draft post content."
  status: 0  # draft
  published_at: 

# CORRECT - test/fixtures/comments.yml
one:  # Default case - approved comment
  post: one
  author_name: "John Doe"
  author_email: "john@example.com"
  content: "Great post! Thanks for sharing."
  approved: true

two:  # Alternative case - pending comment
  post: one
  author_name: "Jane Smith"
  author_email: "jane@example.com"
  content: "Interesting thoughts on this topic."
  approved: false

# CORRECT - test/fixtures/users.yml
one:  # Default admin user
  email_address: "admin@example.com"
  password_digest: <%= BCrypt::Password.create("password", cost: 4) %>

two:  # Alternative admin user
  email_address: "admin2@example.com"
  password_digest: <%= BCrypt::Password.create("password2", cost: 4) %>
```

## MODEL TESTING PATTERNS [BLOG-SPECIFIC]

### Post Model Testing
```ruby
class PostTest < ActiveSupport::TestCase
  test "post has required validations" do
    post = Post.new
    
    refute post.valid?, "Post should require title and content"
    assert post.errors[:title].any?, "Title should be required"
    assert post.errors[:content].any?, "Content should be required"
  end
  
  test "published scope includes only published posts" do
    draft = posts(:one)
    published = posts(:two)
    draft.update!(status: :draft)
    published.update!(status: :published)
    
    result = Post.published.to_a
    
    assert result.include?(published), "Should include published posts"
    refute result.include?(draft), "Should exclude draft posts"
  end
  
  test "destroying post removes associated comments" do
    post = posts(:one)
    comment = comments(:one)
    comment.update!(post: post)
    
    post.destroy!
    
    refute Comment.exists?(comment.id), "Comments should be destroyed with post"
  end
end
```

### Comment Model Testing
```ruby
class CommentTest < ActiveSupport::TestCase
  test "comment requires all author fields and content" do
    comment = Comment.new
    
    refute comment.valid?, "Comment should require all fields"
    assert comment.errors[:author_name].any?, "Author name should be required"
    assert comment.errors[:author_email].any?, "Author email should be required"
    assert comment.errors[:content].any?, "Content should be required"
    assert comment.errors[:post].any?, "Post association should be required"
  end
  
  test "comment belongs to post" do
    comment = comments(:one)
    post = posts(:one)
    comment.update!(post: post)
    
    assert comment.post == post, "Comment should belong to assigned post"
  end
end
```

## CONTROLLER TESTING PATTERNS [BLOG-SPECIFIC]

### Posts Controller Testing
```ruby
class PostsControllerTest < ActionDispatch::IntegrationTest
  test "index shows published posts only" do
    draft = posts(:one)
    published = posts(:two)
    draft.update!(status: :draft)
    published.update!(status: :published)
    
    get posts_path
    
    assert_response :success
    assert_select "h2", text: published.title
    assert_select "h2", text: draft.title, count: 0
  end
  
  test "show displays post and comments" do
    post = posts(:one)
    comment = comments(:one)
    post.update!(status: :published)
    comment.update!(post: post, approved: true)
    
    get post_path(post)
    
    assert_response :success
    assert_select "h1", text: post.title
    assert_select ".comment", text: comment.content
  end
  
  test "admin can create new post" do
    login_as_admin
    
    assert_difference "Post.count" do
      post posts_path, params: {
        post: {
          title: "New Post",
          content: "New content",
          status: "published"
        }
      }
    end
    
    assert_redirected_to Post.last
  end

  private
  
  def login_as_admin
    post login_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }
  end
end
```

## SYSTEM TESTING PATTERNS [BLOG-SPECIFIC]

### End-to-End Blog Workflows
```ruby
class BlogReadingTest < ApplicationSystemTestCase
  test "reader can browse and comment on posts" do
    post = posts(:one)
    post.update!(status: :published, published_at: Time.current)
    
    visit root_path
    
    assert_text post.title
    click_on post.title
    
    assert_text post.content
    
    fill_in "Name", with: "Test Reader"
    fill_in "Email", with: "reader@example.com"
    fill_in "Comment", with: "Great post!"
    click_button "Post Comment"
    
    assert_text "Great post!"
  end
end

class AdminPostManagementTest < ApplicationSystemTestCase
  test "admin can create and publish posts" do
    login_as_admin
    
    visit new_post_path
    
    fill_in "Title", with: "New Blog Post"
    fill_in "Content", with: "This is the content of my new post."
    select "Published", from: "Status"
    click_button "Create Post"
    
    assert_text "Post was successfully created"
    assert_text "New Blog Post"
  end
  
  private
  
  def login_as_admin
    visit login_path
    fill_in "Email", with: users(:one).email_address
    fill_in "Password", with: "password"
    click_button "Log in"
  end
end
```

## HELPER MODULES [REFERENCE]

### Blog-Specific Test Helpers
```ruby
# test/support/blog_test_helper.rb
module BlogTestHelper
  def create_published_post(attrs = {})
    defaults = {
      title: "Test Post",
      content: "Test content",
      status: :published,
      published_at: Time.current
    }
    Post.create!(defaults.merge(attrs))
  end
  
  def create_comment_for_post(post, attrs = {})
    defaults = {
      post: post,
      author_name: "Test Author",
      author_email: "test@example.com",
      content: "Test comment content",
      approved: true
    }
    Comment.create!(defaults.merge(attrs))
  end
  
  def login_admin_user(user = users(:one))
    post login_path, params: {
      email_address: user.email_address,
      password: "password"
    }
  end
end
```

## BEST PRACTICES [BLOG-SPECIFIC]

### Testing Strategy
- ✅ DO: Test model validations and associations thoroughly
- ✅ DO: Test controller actions for both admin and public access
- ✅ DO: Test the published/draft post visibility logic
- ✅ DO: Test comment approval/moderation workflows
- ✅ DO: Use system tests for critical user journeys (reading, commenting, admin management)
- ✅ DO: Test Turbo form submissions and dynamic updates
- ❌ DON'T: Test ActionText internals - focus on your business logic
- ❌ DON'T: Test Rails framework behavior - focus on your application logic

### Data Modification Over Mocking
- ✅ DO: Modify fixture data directly to create test scenarios
- ✅ DO: Update post status, comment approval, etc. to test different states
- ✅ DO: Create realistic test data that exercises your business rules
- ❌ DON'T: Mock internal Rails methods or your own model methods
- ❌ DON'T: Use stubs when you can modify data to achieve the same result

```ruby
# CORRECT - Modify data to create test condition
test "admin dashboard shows draft count" do
  post1 = posts(:one)
  post2 = posts(:two)
  post1.update!(status: :draft)
  post2.update!(status: :published)
  
  login_as_admin
  get admin_dashboard_path
  
  assert_select ".draft-count", text: "1"
end

# INCORRECT - Mock method return values
test "admin dashboard shows draft count" do
  Post.stub(:draft_count, 1) do
    login_as_admin
    get admin_dashboard_path
    assert_select ".draft-count", text: "1"
  end
end
```

## RUNNING TESTS

### Command Reference
- `bin/rails test` - Run all tests except system tests
- `bin/rails test test/models/` - Run model tests only
- `bin/rails test test/controllers/` - Run controller tests only
- `bin/rails test:system` - Run system tests with browser automation
- `bin/rails test test/models/post_test.rb` - Run specific test file
- `bin/rails test test/models/post_test.rb:42` - Run specific test by line number

### Coverage and Quality
- Tests run with SimpleCov coverage reporting
- Maintain 90%+ test coverage
- All tests must pass before committing code
- Use `bundle exec rubocop -A` after test changes