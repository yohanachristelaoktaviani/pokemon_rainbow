Rails.application.routes.draw do
  root 'mains#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :pokedexes do
    get :search, on: :member
  end

  resources :skills

  resources :pokemons do
    get :heal, on: :collection
    post :healer, on: :member
    post :healshow, on: :member
    delete :destroyskill, on: :member
  end

  resources :pokemon_battles do
    post :attack, on: :member
    post :pokemon1_win, on: :member
    post :pokemon2_win, on: :member
    post :calculate_exp1, on: :member
    post :calculate_exp2, on: :member
    get :surrender1, on: :member
    get :surrender2, on: :member
    post :level_up1, on: :member
    post :level_up2, on: :member
  end


end
