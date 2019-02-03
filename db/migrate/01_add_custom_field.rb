#!/usr/bin/env ruby
class AddCustomField < ActiveRecord::Migration
  # class CustomField < ActiveRecord::Base; end

  def self.up
      c = CustomField.new_subclass_instance('ProjectCustomField')
      c.safe_attributes = {field_format: 'bool',
               name: 'Показывать сводные данные',
               default_value: '1',
               is_required: '1',
               visible: '1'}
      c.save
  end

  # method called when installing the plugin
  def self.down
    CustomField.find_by_name('Показывать сводные данные').destroy unless CustomField.find_by_name('Показывать сводные данные').nil?
  end
end