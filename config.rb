Dir['./lib/*'].each { |f| require f }

activate :blog do |blog|
  blog.permalink = ":year/:month/:day/:title.html"
  blog.sources = "posts/:year-:month-:day-:title.html"
  blog.paginate = true
  blog.tag_template = 'tag.html'
  blog.taglink = 'categories/:tag'
  blog.calendar_template = 'calendar.html'
  blog.author_template = 'author.html'
  blog.authorlink = 'authors/:author'
end

module Middleman::Blog::BlogArticle
  def summary
    data['summary']
  end

  def tags
    article_tags = data['tags']

    if data['tags'].is_a? String
        article_tags = article_tags.split(',').map(&:strip)
    else
      article_tags = Array.wrap(article_tags)
    end
    Array.wrap(data['legacy_category']) + article_tags
  end
end

helpers do
  def tag_links(tags)
    tags.map do |tag|
      link_to tag, tag_path(tag), class: 'tag-link'
    end.join(', ')
  end
end

set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :erb, :fenced_code_blocks => true, :lax_html_blocks => true, :renderer => ::Highlighter::HighlightedHTML.new
activate :highlighter
activate :author_pages
activate :legacy_category
ignore 'author.html.haml'

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :haml, remove_whitespace: true
