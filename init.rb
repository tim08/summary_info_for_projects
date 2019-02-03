Rails.configuration.to_prepare do
  require_relative 'lib/projects_helper_path'
  ProjectsHelper.send :include, ProjectsHelperPatch
end
Redmine::Plugin.register :summary_info_for_projects do
  name 'Summary Info For Projects plugin'
  author 'Dmitry Batmanov'
  description 'Show summary information about issues on projects page'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  settings :default => {'empty' => true}, :partial => 'settings/roles'
end
