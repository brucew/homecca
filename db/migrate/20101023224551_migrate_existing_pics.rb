class MigrateExistingPics < ActiveRecord::Migration
  def self.up
    requests = Request.all
    requests.each do |request|
      if request.pic1_file_name
        pic = Pic.new
        pic.pic = request.pic1
        request.pics << pic
      end
      if request.pic2_file_name
        pic = Pic.new
        pic.pic = request.pic2
        request.pics << pic
      end
      if request.pic3_file_name
        pic = Pic.new
        pic.pic = request.pic3
        request.pics << pic
      end
      if request.pic4_file_name
        pic = Pic.new
        pic.pic = request.pic4
        request.pics << pic
      end
      request.save if request.changed?
    end
  end

  def self.down
  end
end
