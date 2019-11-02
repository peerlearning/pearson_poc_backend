Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/test/:id/start', to: 'test#start'
  post '/test/:id/next-problem', to: 'test#next_problem'
  get '/test/:id/start-test', to: 'test#start'

  resources :test, except: [:new,:index, :edit, :destroy, :show] do
    get :summary
  end

end
