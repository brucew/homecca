class AddOffersRead < ActiveRecord::Migration
  def self.up
    add_column :offers, :read, :boolean
    offers = Offer.all
    offers.each do |offer|
      offer.update_attribute(:state, offer.state.to_sym)
    end
    offers = Offer.all
    offers.each do |offer|
      if offer.state == :unread
        offer.read = false
        offer.state = :open
        offer.save(false)
      else
        offer.read = true
        offer.state = :open if offer.state == :read
        offer.save(false)
      end
    end
  end

  def self.down
    remove_column :offers, :read
  end
end
