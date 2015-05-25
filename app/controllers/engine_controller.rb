class EngineController < ApplicationController
  respond_to :html, :js

  def params_entry
    @engine = Engine.new
  end

  def generate
    engine = Engine.new(get_params)
    if engine.valid?
      @results = ReportGenerator.new(engine.run).generate
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

  def get_params
    result = params.require(:engine).permit(:market_cap_floor, :market_cap_ceiling, :position_count, :initial_balance, :start_date)
    result[:rebalance_frequency] = 'annual'
    result[:market_cap_floor] = nil if params[:engine][:market_cap_floor] == ''
    result[:market_cap_ceiling] = nil if params[:engine][:market_cap_ceiling] == ''
    result[:start_date] = '1952-12-31'
    result[:initial_balance] = params[:engine][:initial_balance].to_f
    result[:position_count] = params[:engine][:position_count].to_i
    result
  end
end
