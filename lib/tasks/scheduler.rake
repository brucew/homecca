desc "Send out daily reminders"
task :send_reminders => :environment do
  users_with_reminders = User.find(:all, :include => :todo_items,
                                   :conditions => ['todo_items.reminder_on = ? AND todo_items.done = ?', Date.today, false])
  users_with_reminders.each do |user|
    p 'Reminding ' + user.name
    Notify.remind user, user.todo_items
  end
end

desc "Send out past due summaries"
task :send_past_due_summaries => :environment do
  # Only run on Fridays.
  # This is because Heroku scheduler will not allow once a week scheduled tasks
  if Date.today.wday == 5
    users_with_past_dues = User.find(:all, :include => :todo_items,
                                     :conditions => ['todo_items.due_on < ? AND todo_items.done = ?', Date.today, false])
    users_with_past_dues.each do |user|
      p 'Sending past due summary to ' + user.name
      Notify.past_due user, user.todo_items
    end
  end
end