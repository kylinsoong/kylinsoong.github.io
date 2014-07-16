require 'zurb-foundation'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new('/blog', :posts)
  extension Awestruct::Extensions::Paginator.new( :posts, '/blog/index', :per_page=>2 )
  extension Awestruct::Extensions::Tagger.new( :posts, '/blog/index', '/blog/tags', :per_page=>2 )
  extension Awestruct::Extensions::TagCloud.new( :posts, '/blog/tags/index.html', :per_page=>2 )
  extension Awestruct::Extensions::Atomizer.new( :posts, '/blog/blog.atom', :num_entries=>5, :feed_title=>'Latest Posts')
  extension Awestruct::Extensions::Indexifier.new
  # Indexifier *must* come before Atomizer
  # extension Awestruct::Extensions::Atomizer.new :posts, '/feed.atom'

  helper Awestruct::Extensions::GoogleAnalytics
end
