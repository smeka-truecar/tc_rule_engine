Rails.application.routes.draw do
  post '/calculate_quote', to: 'quotes#calculate_quote'
end
