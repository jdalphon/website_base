json.array!(@blog_posts) do |blog_post|
  json.extract! blog_post, :user_id, :content, :title, :category
  json.url blog_post_url(blog_post, format: :json)
end
