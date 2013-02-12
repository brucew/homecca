module TodoItemsHelper
  def todo_item_date_tag(date)
    unless date.nil?
      if (date.year == Date.today.year)
        return date.strftime('%b %d')
      else
        return date.strftime('%b %Y')
      end
    end
  end

  def todo_item_done_on_tag(todo_item)
    done_on = todo_item.done_on
    unless done_on.nil?
      if (done_on >= (Date.today + 1.year)) or (done_on <= (Date.today - 1.year))
        return done_on.strftime('%b %Y')
      else
        return done_on.strftime('%b %d')
      end
    end
  end

  def todo_item_update_tag(label, todo_item, attributes={})
    html = link_to_remote(label,
                          :url => todo_item_path(:id => todo_item.id, :todo_item => attributes),
                          :method => :put)
  end
  def todo_item_history_update_tag(label, todo_item, attributes={})
    html = link_to_remote(label,
                          :url => history_update_todo_item_path(:id => todo_item.id, :todo_item => attributes),
                          :method => :put)
  end

  def increment_row
    page << "$('row').value = $('row').value + 1"
  end

  def print_events(todo_items)
    calendar = {}
    todo_items.each do |todo_item|
      unless todo_item.due_on.nil?
        date = todo_item.due_on.strftime('%Y, %m-1, %d')
        if calendar[date].nil?
          calendar[date] = 1
        else
          calendar[date] += 1
        end
      end
    end
    todo_items_js = ''
    calendar.each_pair do |date, todo_item_count|
      todo_items_js += "{ title:'#{todo_item_count}', start:new Date(#{date})},"
    end
    todo_items_js = todo_items_js.chop
    return todo_items_js
  end

  def refresh_todo_list(page)
    unless @todo_items.empty?
      page.replace_html :todo_list, :partial => @todo_items
      page.call :tint_even_todo_items
      #page[:todo_item_due_on].value = @todo_items.last.due_on
    end
  end

  def current_priority(priority)
    priority_text = ""
    priorities = {1=>"High",2=>'Medium',3=>'Normal'}
    if priorities.has_key?(priority)
      priority_text = priorities[priority]
    end
    return priority_text
  end

  def content_for_title_tooltip(item)
    if item.name.length > 40
      return item.name 
    end
  end

end
