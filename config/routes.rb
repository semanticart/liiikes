# Drawing the relevant routes
Liiikes::Application.routes.draw do
  match ':view/sample/:shot_sample/page/:page', :to => "players#index"
  match ':view/page/:page', :to => "players#index"

  resources :about

  # provide constraints to avoid failing on id's with punctuation
  resources :players, :constraints => { :id => %r([^/;,?]+) }

  match 'scouts', :to => "players#index", :view => 'scouts'
  root :to => "players#index", :view => 'players', :page => nil
end
