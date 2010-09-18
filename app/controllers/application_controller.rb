class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_shot_sample

  def set_shot_sample
    @shot_sample = ![1,10,50,100].include?(params['shot-sample'].to_i) ? 10 : params['shot-sample'].to_i
  end
end
