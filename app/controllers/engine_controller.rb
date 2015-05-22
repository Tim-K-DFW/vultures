class EngineController < ApplicationController
  respond_to :html, :js

  def params_entry
    @engine = Engine.new
  end

  def generate
    binding.pry
    @engine = Engine.new(engine_params)
    if @engine.valid?
      @engine.run
      render '_results_link', locals: { data: @engine }
    else
      render 'params_entry'
    end
  end

  private

  def stub_out_params
    # replace with actual params later
    result = {}
    result[:market_cap_floor] = 200
    result[:market_cap_ceiling] = 2000
    result[:position_count] = 5
    result[:initial_balance] = 1000000
    result[:start_date] = '2012-12-31'
    result
  end
end
