require 'zurb-foundation'

Awestruct::Extensions::Pipeline.new do
  helper Awestruct::Extensions::Partial
  # extension Awestruct::Extensions::Posts.new '/news'
  # extension Awestruct::Extensions::Indexifier.new
  # Indexifier *must* come before Atomizer
  # extension Awestruct::Extensions::Atomizer.new :posts, '/feed.atom'
end