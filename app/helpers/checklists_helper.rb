module ChecklistsHelper
  def print_tabs(tabs)
    tabs.tab_list.to_s.gsub(/[,]/, '').downcase
  end
end
