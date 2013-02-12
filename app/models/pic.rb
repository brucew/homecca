class Pic < ActiveRecord::Base

  belongs_to :picable, :polymorphic => true

  S3_CREDENTIALS = "#{RAILS_ROOT}/config/amazon_s3.yml"

  DEFAULT_SIZES = {:thumb => '120x90#', :original => '640x480>'}

  has_attached_file :pic,
                    :styles => lambda { |a| a.instance.styles },
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS,
                    :s3_options => PAPERCLIP_S3_OPTS,
                    :path => 'pics/:id/:style.:extension'

  acts_as_list :scope => :picable

  validates_attachment_presence :pic

  after_create :process

  def process
    # Rename the image on s3 (more of a move)
    s3config = YAML::load(ERB.new(File.read(S3_CREDENTIALS)).result).stringify_keys
    s3config = (s3config[Rails.env] || s3config).symbolize_keys
    AWS::S3::Base.establish_connection!(:access_key_id => s3config[:access_key_id], :secret_access_key => s3config[:secret_access_key])
    new_name = self.pic.path
    old_name = "tmp/#{self.pic_file_name}"
    (1..5).each do |try|
      begin
        # Copy the file
        AWS::S3::S3Object.rename(old_name, new_name, s3config[:bucket], :copy_acl => :true)
        break
      rescue Exception => e
        sleep 1
      end
    end
    self.pic.reprocess!
  end

  def sizes
    defined?(self.picable.class::PIC_SIZES) ? self.picable.class::PIC_SIZES : DEFAULT_SIZES
  end

  def styles
    styles = {}
    self.sizes.each_pair do |key, value|
      styles[key] = [value, :jpg]
    end
    return styles
  end

  def size(size = :original)
    self.sizes[size].split(/\D/).join('x')
  end

  def width(size = :original)
    self.sizes[size].split(/\D/)[0]
  end

  def height(size = :original)
    self.sizes[size].split(/\D/)[1]
  end

  def url(size = nil)
    self.pic.url(size)
  end

end