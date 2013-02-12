class AddRequestsCompensation < ActiveRecord::Migration
  def self.up
    add_column :requests, :volunteer, :boolean
    add_column :requests, :paid, :boolean
    add_column :requests, :trade, :boolean

    reqs = Request.all
    reqs.each do |req|
      req.update_attribute(:paid, true)
      req.update_attribute(:trade, true) if req.requester.provider?
    end
  end

  def self.down
    remove_column :requests, :volunteer
    remove_column :requests, :paid
    remove_column :requests, :trade
  end
end
