json.array!(@lists) do |list|
  json.extract! list, :user_id, :title
  json.url list_url(list, format: :json)
end
