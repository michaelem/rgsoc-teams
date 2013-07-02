require 'octokit'
module Github
  class RepositoryClient
    def initialize(args={})
      opts = {:auto_traversal => true}.merge!(args)
      @client = Octokit::Client.new(opts)
    end
    
    def events(repo)
      client.repository_events(repo)
    end
    
    private
      attr_reader :client
  end
end
