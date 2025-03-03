require 'yaml'
require 'date'
require_relative 'obpm_web'

class OBPMUpdator
  CWDAY = {
    mon: 1,
    tue: 2,
    wed: 3,
    thu: 4,
    fri: 5,
  }.freeze

  def initialize(definition_file)
    f = load_file(definition_file)
    @man_hours = f['man_hours']
    @default = f['default']
    @obpm = ObpmWeb.new(
      id: ENV.fetch('OBPM_ID'),
      password: ENV.fetch('OBPM_PASSWORD'),
      company_id: ENV.fetch('OBPM_COMPANY_ID')
    )
  end

  def execute
    @man_hours.each do |year, month_data|
      month_data.each do |month, week_data|
        week_data.each do |week_idx, day_data|
          day_data.each do |day, man_hours_in_day|
            date = date_of(year, month, week_idx, day)
            next if date.year != year
            next if date.month != month

            man_hours_in_day&.each do |man_hour|
              @obpm.input(date, man_hour['project'], man_hour['process'], man_hour['hour'])
            end
            @obpm.input(date, @default['project'], @default['process'])
          end
        end
      end
    end
  end

  private

  def date_of(year, month, week_idx, day)
    first_day = Date.new(year, month, 1)
    first_day + (week_idx - 1) * 7 + (CWDAY[day.to_sym] - first_day.wday)
  end

  def load_file(definition_file)
    YAML.load_file(definition_file)
  end
end
