require 'github/repository_client'
class RepositoryActivity
  def initialize(source, client, args={})
    @client = client
    @source = source
  end
  
  class << self
    def update_all(args={})
      client =  Github::RepositoryClient.new(args)
      Source.where(kind: 'repository').each do |source|
        new(source, client).update
      end
    end
  end
  
  def update
    events = client.events(repo)
    puts events
    # work in progress
  end
  
  private
    attr_reader :client, :source
    def repo
      source_url_path.to_s.sub(/^\//,"")
    end
    def source_url_path
      URI(source.url).path
    end
end
