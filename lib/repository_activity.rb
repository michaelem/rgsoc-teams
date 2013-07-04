require 'github/repository_client'
require 'github/repository_activity_factory'
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
    events = fetch_events(repo)
    events = new_events(events, last_synced_event)
    events.reverse_each do |event|
      activity = Github::RepositoryActivityFactory.build event
    end
  end
  
  private
    attr_reader :client, :source
    def fetch_events(repo)
      client.events(repo)
    end
    def repo
      source_url_path.sub(/^\//,"")
    end

    def source_url_path
      URI(source.url).path
    end 

    def new_events(events, last_event)
      return events if last_event.nil?
      last_index = events.index {|event| event[:type] == last_event[:type] && event[:id] == last_event[:id] }
      return [] if last_index.nil?
      events.slice! 0...last_index
    end
    
    def last_synced_event
      return nil if source.last_synced_event.nil?
      Hash[ [:type, :id].zip(source.last_synced_event.split('#')) ]
    end

    def last_synced_event=(event)
      source.last_synced_event = "#{event[:type]}##{event[:id]}"
      source.save!
    end
end
