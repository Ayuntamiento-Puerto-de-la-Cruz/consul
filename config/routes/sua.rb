namespace :sua do
  resources :goals, param: :code, only: [:index, :show]
end
