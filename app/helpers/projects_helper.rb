module ProjectsHelper
  PROJECT_TYPE_NAMES = [CruiseControlProject, JenkinsProject, TeamCityRestProject, TeamCityProject, TeamCityChainedProject, TravisProject]

  def project_types
    PROJECT_TYPE_NAMES.map do |type_class|
      [type_class.name.titleize, type_class.name]
    end
  end

  def project_specific_fields project_class
    project_column_prefix = project_class.name.match(/(.*)Project/)[1].underscore
    project_class.columns.map(&:name).grep(/#{project_column_prefix}_/)
  end

end
