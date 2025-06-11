# Testing Guide for Contextual Blog Platform

This guide explains how to write and run tests for the Contextual blog platform. It's designed for developers who want to understand our testing approach and contribute quality code.

## Overview

We use **Minitest** (Rails' default testing framework) with a focus on clear, readable tests that follow the **Arrange-Act-Assert** pattern. Our goal is to maintain 90%+ test coverage while writing tests that serve as documentation for how the system works.

## Test Structure Philosophy

### The Three-Part Pattern
Every test should follow this clear structure:
1. **Arrange** - Set up the data and conditions
2. **Act** - Perform the action you're testing
3. **Assert** - Verify the expected outcome

```ruby
test "published scope returns only published posts" do
  # Arrange - Set up test data
  draft_post = posts(:one)
  published_post = posts(:two)
  draft_post.update!(status: :draft)
  published_post.update!(status: :published)

  # Act - Call the method being tested
  result = Post.published

  # Assert - Check the results
  assert result.include?(published_post), "Published posts should be included"
  refute result.include?(draft_post), "Draft posts should be excluded"
end
```

### Why We Avoid Setup Blocks
Instead of using `setup` methods, we create objects directly in each test. This makes tests self-contained and easier to understand:

```ruby
# ✅ GOOD - Everything is visible
test "post requires title" do
  post = Post.new(content: "Some content")
  
  refute post.valid?
  assert post.errors[:title].any?
end

# ❌ AVOID - Hidden dependencies
def setup
  @post = Post.new(content: "Some content")
end

test "post requires title" do
  refute @post.valid?  # Where did @post come from?
end
```

## Running Tests

### Basic Commands
```bash
# Run all tests (excluding browser tests)
bin/rails test

# Run system tests (with browser automation)
bin/rails test:system

# Run specific test types
bin/rails test test/models/
bin/rails test test/controllers/

# Run a specific test file
bin/rails test test/models/post_test.rb

# Run a specific test by line number
bin/rails test test/models/post_test.rb:25
```

### Understanding Test Output
- **Green dots (.)** - Passing tests
- **Red F** - Failing tests
- **Yellow S** - Skipped tests
- **Coverage report** - Shows at the end, aim for 90%+

## Test Organization

### File Structure
```
test/
├── models/           # Test ActiveRecord models
│   ├── post_test.rb
│   └── comment_test.rb
├── controllers/      # Test controller actions
│   ├── posts_controller_test.rb
│   └── comments_controller_test.rb
├── system/          # End-to-end user flows
│   ├── blog_reading_test.rb
│   └── admin_management_test.rb
├── fixtures/        # Test data
│   ├── posts.yml
│   └── comments.yml
└── support/         # Test helpers
    └── blog_test_helper.rb
```

### Naming Conventions
- Test files end with `_test.rb`
- Test classes end with `Test` (e.g., `PostTest`)
- Test methods start with `test` and have descriptive names

## Writing Model Tests

Model tests focus on validations, associations, and business logic:

```ruby
class PostTest < ActiveSupport::TestCase
  test "requires title and content" do
    post = Post.new
    
    refute post.valid?, "Post should be invalid without required fields"
    assert post.errors[:title].any?, "Should have title error"
    assert post.errors[:content].any?, "Should have content error"
  end
  
  test "published scope filters correctly" do
    draft = posts(:one)
    published = posts(:two)
    draft.update!(status: :draft)
    published.update!(status: :published)
    
    results = Post.published.to_a
    
    assert results.include?(published)
    refute results.include?(draft)
  end
  
  test "deleting post removes comments" do
    post = posts(:one)
    comment = comments(:one)
    comment.update!(post: post)
    
    post.destroy!
    
    refute Comment.exists?(comment.id), "Comment should be deleted"
  end
end
```

## Writing Controller Tests

Controller tests verify HTTP responses and user interactions:

```ruby
class PostsControllerTest < ActionDispatch::IntegrationTest
  test "index shows published posts to public" do
    draft = posts(:one)
    published = posts(:two)
    draft.update!(status: :draft)
    published.update!(status: :published)
    
    get posts_path
    
    assert_response :success
    assert_select "h2", text: published.title
    assert_select "h2", text: draft.title, count: 0
  end
  
  test "admin can create post" do
    login_as_admin
    
    assert_difference "Post.count" do
      post posts_path, params: {
        post: {
          title: "New Post",
          content: "Content here",
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

## Writing System Tests

System tests simulate real user interactions with a browser:

```ruby
class BlogReadingTest < ApplicationSystemTestCase
  test "visitor can read and comment on posts" do
    post = posts(:one)
    post.update!(status: :published)
    
    # Visit the blog
    visit root_path
    assert_text post.title
    
    # Read a post
    click_on post.title
    assert_text post.content
    
    # Leave a comment
    fill_in "Name", with: "John Doe"
    fill_in "Email", with: "john@example.com"
    fill_in "Comment", with: "Great post!"
    click_button "Post Comment"
    
    # Verify comment appears
    assert_text "Great post!"
  end
end
```

## Using Fixtures

Fixtures provide consistent test data. We use a simple naming convention:

```yaml
# test/fixtures/posts.yml
one:  # Default case - published post
  title: "First Blog Post"
  content: "This is the content."
  status: 1  # published
  published_at: <%= 1.day.ago %>

two:  # Alternative case - draft post  
  title: "Draft Post"
  content: "Draft content."
  status: 0  # draft
```

Access fixtures in tests:
```ruby
post = posts(:one)      # Gets the "one" fixture
comment = comments(:two) # Gets the "two" fixture
```

## Assertion Styles

We prefer simple, readable assertions:

```ruby
# ✅ GOOD - Clear and readable
assert post.published?, "Post should be published"
refute post.draft?, "Post should not be draft"
assert post.errors[:title].any?, "Should have title error"

# ❌ AVOID - Less clear
assert_equal true, post.published?
assert_not_equal "draft", post.status
assert_includes post.errors.keys, :title
```

## Testing Best Practices

### Do This ✅
- **Write descriptive test names** that explain the expected behavior
- **Test the happy path and edge cases** 
- **Create test data directly in tests** for clarity
- **Use real objects instead of mocks** when possible
- **Test business logic thoroughly** in model tests
- **Keep controller tests focused** on HTTP concerns

### Avoid This ❌
- **Don't test Rails framework behavior** (it's already tested)
- **Don't create complex test hierarchies** or abstractions
- **Don't use setup blocks** for creating test objects
- **Don't test private methods** directly
- **Don't write overly complex tests** that are hard to understand

## Test Helpers

For complex object creation, use helper methods:

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
  
  def login_admin_user(user = users(:one))
    post login_path, params: {
      email_address: user.email_address,
      password: "password"
    }
  end
end

# Include in test classes that need it
class PostsControllerTest < ActionDispatch::IntegrationTest
  include BlogTestHelper
  
  test "something requiring published post" do
    post = create_published_post(title: "Special Title")
    # ... rest of test
  end
end
```

## Debugging Tests

### Common Issues
- **Failing assertions**: Check that your test data is set up correctly
- **Missing fixtures**: Ensure fixture files exist and have valid YAML
- **Authentication errors**: Make sure login helpers are working
- **Database state**: Tests are transactional, so data doesn't persist between tests

### Debugging Techniques
```ruby
# Add debugging output
test "debugging example" do
  post = posts(:one)
  puts "Post status: #{post.status}"  # Temporary debugging
  puts "Post valid?: #{post.valid?}"   # Check validation state
  
  # Your test code here
end
```

## Code Coverage

We use SimpleCov to track test coverage:
- Coverage reports appear after running tests
- Aim for 90%+ coverage
- Focus on testing important business logic
- Don't obsess over 100% - quality matters more than quantity

## Getting Help

- **Read the test output carefully** - it usually tells you what's wrong
- **Look at existing tests** for patterns and examples
- **Use `puts` statements** for debugging test data
- **Run individual tests** to isolate problems
- **Check fixture data** if tests behave unexpectedly

Remember: Good tests serve as documentation for how your code should work. Write them clearly and they'll help future developers (including yourself) understand the system.