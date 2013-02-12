ActionController::Routing::Routes.draw do |map|
  map.resources :forums

  map.resources :topics


  map.namespace :admin do |admin|
    admin.resources :users, :active_scaffold => true
    admin.resources :requests, :active_scaffold => true
    admin.resources :jobs, :active_scaffold => true
    admin.resources :logs, :active_scaffold => true
  end

  map.resources :articles do |articles|
    articles.resources :pics
  end

  map.resources :offers, :member => {:accept => :post, :reject => :post}, :has_many => :offer_comments

  map.resources :passwords, :only => [:new, :create]

  map.resources :pics

  map.resources :providers do |providers|
    providers.resources :pics
  end

  map.resources :ratings

  map.resources :requests, :member => {:close => :get, :complete => :post}

  map.resources :requests do |requests|
    requests.resources :ratings
    requests.resources :offers
    requests.resources :pics
  end

  map.resource :session, :controller => 'sessions'

  map.resources :shares

  map.resources :todo_catalogue_items do |todo_catalogue_items|
    todo_catalogue_items.resources :pics
  end

  map.resources :todo_items, :collection => {:history => :get},:member=>{:history_edit=>:get,:history_update=>:put}

  map.resources :users, :collection => {:wizard_update => [:post,:put]} do |users|
    users.resources :requests
    users.resource :confirmation,
      :controller => 'confirmations',
      :only       => [:new, :create]
  end

  map.resources :checklists

  map.home '/home', :controller => 'home', :action => 'home'
  map.settings '/settings', :controller => 'home', :action => 'settings'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.s3_uploads '/s3_uploads.xml', :controller => 's3_uploads', :action => 'index'
  map.discussions '/discussions', :controller => 'discussions', :action => 'index'
  map.admin '/admin', :controller => 'admin/admin', :action => 'index'

  map.fb_connect 'fb_connect',
                 :controller => 'sessions',
                 :action => 'create'

  # Static content pages
  map.welcome '/', :controller => 'static_content', :action => 'welcome'
  map.start_here '/border', :controller => 'static_content', :action => 'border'
  map.faq '/faq', :controller => 'static_content', :action => 'faq'
  map.how_to '/how_to', :controller => 'static_content', :action => 'how_to'
  map.learn_more '/learn_more', :controller => 'static_content', :action => 'learn_more'
  map.opportunities '/opportunities', :controller => 'static_content', :action => 'opportunities'
  map.start_here '/start_here', :controller => 'static_content', :action => 'start_here'

  map.root :controller => 'static_content', :action => 'welcome'

  BlueLightSpecial::Routes.draw(map)

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
