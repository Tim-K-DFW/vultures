class EngineController < ApplicationController
  respond_to :html, :js

  def params_entry
    @engine = Engine.new
  end

  def generate
    engine = Engine.new(stub_out_params) # replace with actual params
    if engine.valid?
      @results = ReportGenerator.new(engine.run).generate
      # all data assigned correctly for all periods
      # @source passed fully to results_link.js.erb
      render file: "engine/results_link.js.erb"
    else
      render 'params_entry'
    end
  end

  def results_performance
    @source = params[:results]
    respond_to do |format|
      format.html { render 'results_performance' }
      format.js { render 'results_performance' }
    end
  end

  def results_positions
   @source = params[:results]
    respond_to do |format|
      format.html { render 'results_positions' }
      format.js { render 'results_positions' }
    end
  end

  private

  def stub_out_params
    result = {}
    result[:market_cap_floor] = 200
    result[:market_cap_ceiling] = 2000
    result[:position_count] = 5
    result[:initial_balance] = 1000000
    result[:start_date] = '1952-12-31'
    result[:rebalance_frequency] = 'annual'
    result
  end
end
