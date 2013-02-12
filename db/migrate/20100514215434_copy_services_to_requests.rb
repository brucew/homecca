class CopyServicesToRequests < ActiveRecord::Migration
  def self.up
    services = Request.all
    services.each do |service|
      request = Request.new(service.attributes)
      request.save
    end
  end

  def self.down
  end
end
