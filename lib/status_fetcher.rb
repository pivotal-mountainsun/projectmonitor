module StatusFetcher
  class Job < Struct.new(:project)
    def perform
      retrieve_status
      retrieve_velocity

      project.set_next_poll!
    end

    private

    def retrieve_status
      StatusFetcher.retrieve_status_for(project)
    end

    def retrieve_velocity
      StatusFetcher.retrieve_velocity_for(project)
    end
  end

  class << self
    def fetch_all
      projects = Project.all.select(&:needs_poll?)
      projects.each do |project|
        Delayed::Job.enqueue StatusFetcher::Job.new(project)
      end
    end

    def retrieve_status_for(project)
      payload = ProjectContentFetcher.new(project).fetch
      if payload
        ProjectPayloadProcessor.new(project, payload).perform
      end
    end

    def retrieve_velocity_for(project)
      return unless project.tracker_project?

      begin
        tracker = TrackerApi.new(project)
        project.current_velocity = tracker.current_velocity
        project.last_ten_velocities = tracker.last_ten_velocities
        project.tracker_online = true
      rescue RestClient::Exception
        project.tracker_online = false
      end

      project.save!
    end
  end
end

