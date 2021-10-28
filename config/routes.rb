Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users
      resources :colleges
      post '/schedule', to: 'exam_schedules#create_schedule'
      get '/schedule/:user_id', to: 'exam_schedules#get_schedule'
    end
  end

end
