# frozen_string_literal: true

Rails.application.routes.draw do
  resources :lessons, except: %i[new edit]
end

# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#                   lessons GET    /lessons(.:format)                                                                       lessons#index
#                           POST   /lessons(.:format)                                                                       lessons#create
#                    lesson GET    /lessons/:id(.:format)                                                                   lessons#show
#                           PATCH  /lessons/:id(.:format)                                                                   lessons#update
#                           PUT    /lessons/:id(.:format)                                                                   lessons#update
#                           DELETE /lessons/:id(.:format)                                                                   lessons#destroy
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
