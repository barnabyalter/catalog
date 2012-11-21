module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /^the ead page for (.+)/
      catalog_path($1)

    when /^the component page for (.+)/
      params = $1.split(/:/)
      components_path(:ead_id=>params[0], :component_level=>params[1], :parent_ref=>params[2])

    when /^the bib record page for (.+)/
      catalog_path($1)

    when /^the login page$/
      new_user_session_path

    when /^the signup page$/
      new_user_registration_path

    when /^the search results page for (.+)/
      catalog_index_path("q"=>$1, "search_field"=>"all_fields")

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
