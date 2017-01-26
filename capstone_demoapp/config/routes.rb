Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    resources :foos, except: [:new, :edit]
    resources :bars, except: [:new, :edit]
  end

  get "/client-assets/:name.:format", :to => redirect("/client/client-assets/%{name}.%{format}")

  # this is another way how we can redirect all requests to the main index page (the first one was commented out in ui_controller's index method)
  get "/", :to => redirect("/client/index.html")

  # get '/ui' => 'ui#index'
  # get '/ui#' => 'ui#index'
  # root 'ui#index'
end
