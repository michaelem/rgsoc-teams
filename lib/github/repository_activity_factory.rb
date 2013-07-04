module Github
  module RepositoryActivityFactory
    def self.build(event)
      case event.type
        when 'IssuesEvent'
          from_issues_event event
      end
    end
    
    def self.from_issues_event(event)
      puts event.type
    end
    
    def self.from_issues_event(event)
      puts event.type
    end
  end
end