class EngineController < ApplicationController
  respond_to :html, :js
  require 'net/http'

  def params_entry
    @engine = EngineWorker.new
  end

  def generate
    engine = EngineWorker.new(get_params)
    if engine.valid?
      pusher_channel = 100
      engine.perform(get_params, pusher_channel)
      redirect_to results_link_path
    else
      render 'params_entry'
    end
  end

  def results_link
    binding.pry
    @results = JSON.parse(Result.last.result_string)['engine']
    render file: "engine/results_link.js.erb"
  end

  def results_performance
    binding.pry
    @source = JSON.parse(Result.last.result_string)['engine']
    respond_to do |format|
      format.html { render 'results_performance' }
      format.js { render 'results_performance' }
    end
  end

  def results_positions
   @source = JSON.parse(Result.last.result_string)['engine']
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

  def get_params
    result = params.require(:engine_worker).permit(:market_cap_floor, :market_cap_ceiling, :position_count, :initial_balance, :start_date)
    result[:rebalance_frequency] = 'annual'
    result[:market_cap_floor] = nil if params[:engine_worker][:market_cap_floor] == ''
    result[:market_cap_ceiling] = nil if params[:engine_worker][:market_cap_ceiling] == ''
    result[:start_date] = '1993-12-31'
    result[:initial_balance] = params[:engine_worker][:initial_balance].to_f
    result[:position_count] = params[:engine_worker][:position_count].to_i
    result
  end
end
