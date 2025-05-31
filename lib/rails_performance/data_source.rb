module RailsPerformance
  class DataSource
    KLASSES = {
      requests: RailsPerformance::Models::RequestRecord,
      sidekiq: RailsPerformance::Models::SidekiqRecord,
      delayed_job: RailsPerformance::Models::DelayedJobRecord,
      grape: RailsPerformance::Models::GrapeRecord,
      rake: RailsPerformance::Models::RakeRecord,
      custom: RailsPerformance::Models::CustomRecord,
      resources: RailsPerformance::Models::ResourceRecord
    }

    attr_reader :q, :klass, :type, :days

    def initialize(type:, q: {}, days: RailsPerformance::Utils.days(RailsPerformance.duration))
      @type = type
      @klass = KLASSES[type]
      q[:on] ||= Date.today
      @q = q
      @days = days
    end

    def db
      result = RailsPerformance::Models::Collection.new
      now = RailsPerformance::Utils.time
      (0..days).to_a.reverse_each do |e|
        RailsPerformance::DataSource.new(q: q.merge({on: (now - e.days).to_date}), type: type).add_to(result)
      end
      result
    end

    def default?
      @q.keys == [:on]
    end

    def add_to(storage = RailsPerformance::Models::Collection.new)
      store do |record|
        storage.add(record)
      end
      storage
    end

    def store
      query_scope.find_each do |record|
        yield record
      end
    end

    private

    def query_scope
      scope = klass.all

      case type
      when :requests
        scope = scope.by_controller(q[:controller])
                    .by_action(q[:action])
                    .by_format(q[:format])
                    .by_status(q[:status])
                    .by_method(q[:method])
                    .by_path(q[:path])
                    .by_date(q[:on])
      when :resources
        scope = scope.by_server(q[:server])
                    .by_context(q[:context])
                    .by_role(q[:role])
                    .by_date(q[:on])
      when :sidekiq
        scope = scope.by_queue(q[:queue])
                    .by_worker(q[:worker])
                    .by_status(q[:status])
                    .by_date(q[:on])
      when :delayed_job
        scope = scope.by_status(q[:status])
                    .by_class_name(q[:class_name])
                    .by_date(q[:on])
      when :grape
        scope = scope.by_status(q[:status])
                    .by_format(q[:format])
                    .by_method(q[:method])
                    .by_path(q[:path])
                    .by_date(q[:on])
      when :rake
        scope = scope.by_status(q[:status])
                    .by_date(q[:on])
      when :custom
        scope = scope.by_tag_name(q[:tag_name])
                    .by_namespace_name(q[:namespace_name])
                    .by_status(q[:status])
                    .by_date(q[:on])
      else
        raise "wrong type: \"#{type}\" for datasource query builder"
      end

      scope
    end
  end
end
