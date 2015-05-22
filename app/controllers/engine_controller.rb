class EngineController < ApplicationController
  respond_to :html, :js

  def params_entry
    @engine = Engine.new
  end

  def generate
    @engine = Engine.new(stub_out_params) # replace with actual params
    if @engine.valid?
      @engine.run(development: true)
      # Results.new.fill(@engine)
      render file: "engine/results_link.js.erb"
    else
      render 'params_entry'
    end
  end

  def results_performance
    # @output = Results.performance
  end

  def results_positions
    # @output = Results.positions
  end

  private

  def stub_out_params
    result = {}
    result[:market_cap_floor] = 200
    result[:market_cap_ceiling] = 2000
    result[:position_count] = 5
    result[:initial_balance] = 1000000
    result[:start_date] = '2012-12-31'
    result
  end
end
