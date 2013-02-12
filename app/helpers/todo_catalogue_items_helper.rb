module TodoCatalogueItemsHelper
  def fields_for_vid(vid, &block)
    prefix = vid.new_record? ? 'new' : 'existing'
    fields_for("todo_catalogue_item[#{prefix}_vid_attributes][]", vid, &block)
  end

  def add_vid_button(name)
    button_to_function name, :class => 'button' do |page|
      page.insert_html :bottom, :vids, :partial => 'vid', :object => Vid.new
    end
  end

end
