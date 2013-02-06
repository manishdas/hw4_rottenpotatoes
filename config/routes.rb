Rottenpotatoes::Application.routes.draw do
  
  match ':controller/:id/:action'
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
end
