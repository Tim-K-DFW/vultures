class EngineController < ApplicationController
  respond_to :html, :js

  def params_entry
    @engine = Engine.new
  end

  def generate
    engine = Engine.new(get_params)
    if engine.valid?
      pusher_channel = 100
      engine.perform(get_params, pusher_channel)
      render file: "engine/results_link.js.erb"
    else
      render 'params_entry'
    end
  end

  def results_performance
    @source = JSON.parse(Result.last.result_string)
    respond_to do |format|
      format.html { render 'results_performance' }
      format.js { render 'results_performance' }
    end
  end

  def results_positions
   @source = JSON.parse(Result.last.result_string)
    respond_to do |format|
      format.html { render 'results_positions' }
      format.js { render 'results_positions' }
    end
  end

  private

  def get_params
    result = params.require(:engine).permit(:market_cap_floor, :market_cap_ceiling, :position_count, :initial_balance, :background, :rebalance_frequency, :test_run, :start_date, :single_period)
    result[:rebalance_frequency] = 'annual'
    result[:market_cap_floor] = nil if params[:engine][:market_cap_floor] == ''
    result[:market_cap_ceiling] = nil if params[:engine][:market_cap_ceiling] == ''
    result[:start_date] = params[:engine][:start_date] || '1993-12-31'
    result[:initial_balance] = params[:engine][:initial_balance].to_f
    result[:position_count] = params[:engine][:position_count].to_i
    result
  end
end
