module ProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def show_issues_info?(project)
      ActiveRecord::Type::Boolean.new.type_cast_from_user(project.custom_field_values.select{|e| e.custom_field.name == "Показывать сводные данные"}.first.try(:value))
    end

    def issues_count_info(project)
     "#{ project.issues.where(status: IssueStatus.where.not(name: ["Закрыта"]).ids).count } /
    #{ project.issues.where(status: IssueStatus.where.not(name: ["Решена"]).ids).count } /
     #{ project.issues.where(assigned_to_id: nil).count }"
    end

    def render_project_hierarchy_with_issues_info(projects)
      render_project_nested_lists_with_issues_info(projects) do |project|
        s = link_to_project(project, {}, :class => "#{project.css_classes} #{User.current.member_of?(project) ? 'icon icon-fav my-project' : nil}")
        if project.description.present?
          s << content_tag('div', textilizable(project.short_description, :project => project), :class => 'wiki description')
        end
        s
      end
    end

    def render_project_nested_lists_with_issues_info(projects, &block)
      s = ''
      if projects.any?
        ancestors = []
        original_project = @project

        projects.sort_by(&:lft).each do |project|
          # set the project environment to please macros.
          @project = project
          if (ancestors.empty? || project.is_descendant_of?(ancestors.last))
            s << "<ul class='projects #{ ancestors.empty? ? 'root' : nil}'>\n"
          else
            ancestors.pop
            s << "</li>"
            while (ancestors.any? && !project.is_descendant_of?(ancestors.last))
              ancestors.pop
              s << "</ul></li>\n"
            end
          end
          classes = (ancestors.empty? ? 'root' : 'child')
          s << "<li class='#{classes}'><div class='#{classes}'>"
          s << h(block_given? ? capture(project, &block) : project.name)
          s << "</div>\n"
          ancestors << project
        end
        s << ("</li></ul>\n" * ancestors.size)
        @project = original_project
      end
      s.html_safe
    end

  end
end
