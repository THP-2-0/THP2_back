# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :classrooms, except: %i[new edit] do
    resources :lessons, except: %i[new edit]
  end
  match '*path', via: :all, to: "application#no_route"
  match '/', via: :all, to: "application#no_route"
end

# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#          new_user_session GET    /auth/sign_in(.:format)                                                                  devise_token_auth/sessions#new
#              user_session POST   /auth/sign_in(.:format)                                                                  devise_token_auth/sessions#create
#      destroy_user_session DELETE /auth/sign_out(.:format)                                                                 devise_token_auth/sessions#destroy
#         new_user_password GET    /auth/password/new(.:format)                                                             devise_token_auth/passwords#new
#        edit_user_password GET    /auth/password/edit(.:format)                                                            devise_token_auth/passwords#edit
#             user_password PATCH  /auth/password(.:format)                                                                 devise_token_auth/passwords#update
#                           PUT    /auth/password(.:format)                                                                 devise_token_auth/passwords#update
#                           POST   /auth/password(.:format)                                                                 devise_token_auth/passwords#create
#  cancel_user_registration GET    /auth/cancel(.:format)                                                                   devise_token_auth/registrations#cancel
#     new_user_registration GET    /auth/sign_up(.:format)                                                                  devise_token_auth/registrations#new
#    edit_user_registration GET    /auth/edit(.:format)                                                                     devise_token_auth/registrations#edit
#         user_registration PATCH  /auth(.:format)                                                                          devise_token_auth/registrations#update
#                           PUT    /auth(.:format)                                                                          devise_token_auth/registrations#update
#                           DELETE /auth(.:format)                                                                          devise_token_auth/registrations#destroy
#                           POST   /auth(.:format)                                                                          devise_token_auth/registrations#create
#     new_user_confirmation GET    /auth/confirmation/new(.:format)                                                         devise_token_auth/confirmations#new
#         user_confirmation GET    /auth/confirmation(.:format)                                                             devise_token_auth/confirmations#show
#                           POST   /auth/confirmation(.:format)                                                             devise_token_auth/confirmations#create
#       auth_validate_token POST   /auth/validate_token(.:format)                                                           devise_token_auth/token_validations#validate_token
#        auth_password_edit POST   /auth/password/edit(.:format)                                                            devise_token_auth/passwords#edit
#         classroom_lessons GET    /classrooms/:classroom_id/lessons(.:format)                                              lessons#index
#                           POST   /classrooms/:classroom_id/lessons(.:format)                                              lessons#create
#          classroom_lesson GET    /classrooms/:classroom_id/lessons/:id(.:format)                                          lessons#show
#                           PATCH  /classrooms/:classroom_id/lessons/:id(.:format)                                          lessons#update
#                           PUT    /classrooms/:classroom_id/lessons/:id(.:format)                                          lessons#update
#                           DELETE /classrooms/:classroom_id/lessons/:id(.:format)                                          lessons#destroy
#                classrooms GET    /classrooms(.:format)                                                                    classrooms#index
#                           POST   /classrooms(.:format)                                                                    classrooms#create
#                 classroom GET    /classrooms/:id(.:format)                                                                classrooms#show
#                           PATCH  /classrooms/:id(.:format)                                                                classrooms#update
#                           PUT    /classrooms/:id(.:format)                                                                classrooms#update
#                           DELETE /classrooms/:id(.:format)                                                                classrooms#destroy
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
