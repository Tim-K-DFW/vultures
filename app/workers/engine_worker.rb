class EngineWorker
  include ActiveModel::Model
  require 'date'

  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: false

  attr_reader :parameters, :portfolio
  attr_accessor :rebalance_frequency, :market_cap_floor, :market_cap_ceiling, :initial_balance, :use_dual_momentum

  def initialize(parameters=nil)
    @parameters = parameters
  end

  def perform(parameters=nil, pusher_channel)
    @parameters = parameters
    @portfolio = Portfolio.new(
      position_count: parameters["position_count"],
      initial_balance: parameters["initial_balance"],
      start_date: parameters["start_date"],
      rebalance_frequency: parameters["rebalance_frequency"]
    )

    PricePoint.all_periods(development: true).each do |period|
      period = period.to_s

      binding.pry
      
      Pusher.trigger(pusher_channel, 'update', {message: "Processing #{period}" })
      # store current_status: "Processing #{period}"
      
      current_market_data = ScoreCalculator.new(
        market_cap_floor: parameters["market_cap_floor"], 
        market_cap_ceiling: parameters["market_cap_ceiling"],
        period: period
      ).assign_scores

      @portfolio.carry_forward(period) unless period == parameters["start_date"]

      target_portfolio = TargetPortfolio.new(
        current_portfolio_balance: @portfolio.as_of(period)[:total_market_value],
        position_count: @portfolio.position_count,
        current_market_data: current_market_data,
        parameters: parameters
        ).build
      @portfolio.rebalance(new_period: period, target: target_portfolio, parameters: parameters)
    end

    # store current_status: 'Building output'
    binding.pry
    Pusher.trigger(pusher_channel, 'update', {message: 'Building reports' })
    output = ReportGenerator.new(self).generate
    # store results: output.to_json
    # output.to_json
    binding.pry
    Pusher.trigger(pusher_channel, 'update', { progress: 100, message: output })
  end
end
