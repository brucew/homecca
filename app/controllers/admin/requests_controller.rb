class Admin::RequestsController < Admin::AdminController
  active_scaffold :request do |config|
    config.list.columns = [:id, :name, :description, :skills, :requester_id, :location]
    config.columns.exclude :offerers, :provider, :requester,
                           :tags, :taggings, :tag_taggings, :base_tags, :tag_list
    config.update.columns.exclude :accepted_offer
  end
end