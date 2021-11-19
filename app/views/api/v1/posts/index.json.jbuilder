json.array! @posts do |post|
    json.id post.id
    json.title post.title
    json.description post.description
end