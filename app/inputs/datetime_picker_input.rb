# frozen_string_literal: true

# Datetime Picker for simple_form
class DatetimePickerInput < DatePickerInput
  private

  def display_pattern
    date = "#{I18n.t('datepicker.dformat', default: '%d/%m/%Y')}"
    time = "#{I18n.t('timepicker.dformat', default: '%R')}"
    "#{date} #{time}"
  end

  def picker_pattern
    date = "#{I18n.t('datepicker.pformat', default: 'DD/MM/YYYY')}"
    time = "#{I18n.t('timepicker.pformat', default: 'HH:mm')}"
    "#{date} #{time}"
  end
end
