@site = Site.create(:host  => "unusedfornow.com",
            :title => "Mephisto",
            :subtitle => "Publish With Impunity",
            :email => "email@domain.com",
            :approve_comments => true,
            :comment_age => 30,
            :timezone_name => "UTC",
            :permalink_style => ":year/:month/:day/:permalink",
            :tag_path => "tags",
            :search_path => "search",
            :current_theme_path => "simpla"
)

@site.sections.create(:name => "Home", :path => '', :articles_per_page => 15, :template => 'home.liquid', :archive_path => 'archives')
@site.members.create(:login => 'admin', :email => "admin@changeme.com", :password => "testpassword", :password_confirmation => "testpassword", :admin => true)