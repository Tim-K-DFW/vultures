class EngineController < ApplicationController
  respond_to :html, :js

  def params_entry
    @engine = Engine.new
  end

  def generate
    @engine = Engine.new(stub_out_params) # replace with actual params
    if @engine.valid?
      @results = @engine.run.to_json
      render file: "engine/results_link.js.erb"
    else
      render 'params_entry'
    end
  end

  def results_performance
    @source = params[:results]
    respond_to do |format|
      format.html { render 'results_performance' }
      format.js { render 'results_performance', formats: [:html] }
    end

    # http://stackoverflow.com/questions/7303550/render-html-instead-of-js-for-an-ajax-request-in-rails
    
    # render :template => 'engine/results_performance', :formats => [:html]
  end

  def results_positions
  end

  private

  def stub_out_params
    result = {}
    result[:market_cap_floor] = 200
    result[:market_cap_ceiling] = 2000
    result[:position_count] = 5
    result[:initial_balance] = 1000000
    result[:start_date] = '1952-12-31'
    result
  end
end
