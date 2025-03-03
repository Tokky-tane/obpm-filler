require_relative 'work_input_page_component/calendar'
require_relative 'work_input_page_component/project'
require_relative 'work_input_page_component/summary'

class WorkInputPage < ObpmWebUi
  def initialize(driver)
    super
    @calender = WorkInputPageComponent::Calendar.new(@driver)
    @summary = WorkInputPageComponent::Summary.new(@driver)
    @project = WorkInputPageComponent::Project.new(@driver)
  end

  def input(date, project, process, hour)
    @calender.set(date)
    @project.select(project, process)
    @project.input(hour)
  end

  def today_diff
    @summary.today_diff
  end
end
