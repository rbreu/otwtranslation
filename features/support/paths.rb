module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
      
    when /the translation home\s?page/
      otwtranslation_home_path

    when 'the phrase table'
      otwtranslation_phrases_path
      
    when 'the source table'
      otwtranslation_sources_path
      
    when 'the language table'
      otwtranslation_languages_path
      
    when 'the hello world page'
      "/hello/world"

    when 'the phrase page'
      otwtranslation_phrase_path(@phrase)
      
    when 'the language page'
      otwtranslation_language_path(@language)
      
    when 'the assignment table'
      otwtranslation_assignments_path
      

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

