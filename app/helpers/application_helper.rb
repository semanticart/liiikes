module ApplicationHelper
  # terrible case statement to determine what meta data to show
  # TODO: improve this
  def meta
    page_id = [params[:controller], params[:action], params[:view] || ''].map(&:downcase)
    @meta ||= case page_id
              when ["players", "index", "players"]
                {:title => "Liiikes: Top Players"}
              when ["players", "index", "scouts"]
                {:title => "Liiikes: Top Scouts"}
              when ["players", "show", ""]
                {:title => "Liiikes: #{@player.name}"}
              when ["about", "index", ""]
                {:title => "Liiikes: About"}
              else
                {}
              end.reverse_merge({ # fall over to these defaults
                :title => "Liiikes: Using statistics to find the best content on Dribbble.",
                :description => "Liiikes.com:  Using statistics to find the best content on Dribbble.",
                :keywords => "liiikes, dribbble, scouts"
              })
  end
end
