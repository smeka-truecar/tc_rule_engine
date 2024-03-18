Rails.application.routes.draw do
  post '/calculate_quote', to: 'quotes#calculate_quote'

  resources :dealers do
    resources :rules
  end
end
