class Log < ActiveRecord::Base
  def self.log(message)
    logger.debug(message)
    log = Log.new
    log.message = message
    log.save
  end
end
