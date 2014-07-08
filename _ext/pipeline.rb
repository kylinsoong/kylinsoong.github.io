require 'zurb-foundation'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new( '/blog' )
  extension Awestruct::Extensions::Paginator.new( :posts, '/index', :per_page=>10 )
  extension Awestruct::Extensions::Tagger.new( :posts, '/index', '/blog/tags', :per_page=>10 )
  extension Awestruct::Extensions::TagCloud.new( :posts, '/blog/tags/index.html', :layout=>:base, :title=>'Blog Tags' )
  extension Awestruct::Extensions::Atomizer.new( :posts, '/blog.atom', :num_entries=>20 )
  extension Awestruct::Extensions::IntenseDebate.new
  extension Awestruct::Extensions::Indexifier.new

  helper Awestruct::Extensions::GoogleAnalytics
  helper Awestruct::Extensions::Partial
  # extension Awestruct::Extensions::Posts.new '/news'
  # extension Awestruct::Extensions::Indexifier.new
  # Indexifier *must* come before Atomizer
  # extension Awestruct::Extensions::Atomizer.new :posts, '/feed.atom'
end
