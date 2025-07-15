namespace :sua_management do
  root to: "goals#index"

  resources :goals, only: [:index]
  resources :targets, only: [:index]
  resource :homepage, controller: :homepage, only: [:show]

  resources :phases, only: [], as: :sua_phases do
    resources :cards, except: [:index, :show], as: :widget_cards
  end

  types = SUA::Related::RELATABLE_TYPES.map(&:tableize)
  types_constraint = /#{types.join("|")}/

  get "*relatable_type", to: "relations#index", as: "relations", relatable_type: types_constraint
  get "*relatable_type/:id/edit", to: "relations#edit", as: "edit_relation", relatable_type: types_constraint
  patch "*relatable_type/:id", to: "relations#update", as: "relation", relatable_type: types_constraint

  types.each do |type|
    get type, to: "relations#index", as: type
    get "#{type}/:id/edit", to: "relations#edit", as: "edit_#{type.singularize}"
  end
end
