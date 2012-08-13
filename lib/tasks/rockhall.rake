require "solr_ead"
require "rockhall"

namespace :rockhall do
namespace :ead do

  desc "Index an ead using RockhallDocument"
  task :index do
    raise "Please specify your ead, ex. FILE=<path/to/ead.xml" unless ENV['FILE']
    indexer = SolrEad::Indexer.new(:document=>Rockhall::EadDocument, :component=>Rockhall::EadComponent)
    indexer.update(ENV['FILE'])
    Rockhall::XsltBehaviors.ead_to_html(ENV['FILE'])
  end

  desc "Index a directory of ead files using RockhallDocument"
  task :index_dir do
    raise "Please specify your direction, ex. DIR=path/to/directory" unless ENV['DIR']
    indexer = SolrEad::Indexer.new(:document=>Rockhall::EadDocument, :component=>Rockhall::EadComponent)
    Dir.glob(File.join(ENV['DIR'],"*")).each do |file|
      print "Indexing #{File.basename(file)}..."
      if File.extname(file).match("xml$")
        indexer.update(file)
        Rockhall::XsltBehaviors.ead_to_html(file)
      end
      print "done.\n"
    end
  end

end
end