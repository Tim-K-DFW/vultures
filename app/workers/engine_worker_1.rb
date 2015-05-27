class EngineWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  
  def perform(args)
    engine = Engine.new(args)
    ReportGenerator.new(engine.run).generate
  end
end
