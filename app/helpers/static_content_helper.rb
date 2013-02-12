module StaticContentHelper
	
  def if_current_then_class(link_path,current_class)    
    class_name = current_page?(link_path) ? current_class : ''
    class_name.to_s
  end
end
