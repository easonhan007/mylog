Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/show/:file_name', to: 'posts#show', as: 'detail'
  get 'tags/:tag_name', to: 'posts#tag', as: 'tag'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "posts#index"
end
