# Helper methods defined here can be accessed in any controller or view in the application

module MTMD
  module FamilyCookBook
      module ApplicationHelper


        def page_header_from_current_route
          singular_actions = [:show, :edit]
          title = route.controller.humanize

          if route.action.in?(singular_actions)
            title.singularize
          else
            title
          end
        end

        def actions(actions)
          html = ''.html_safe
          actions.each do |k,v|
            html << link_to(k, v, :class => 'btn btn-default')
          end
          content_for(:actions) do
            html
          end
        end

        def actions2(actions_array)
          actions_array = Array(actions_array)
          html = ''.html_safe
          actions_array.each do |action|
            html << action
          end
          content_for(:actions) do
            html
          end
        end

        def navigation_item(controller, url, title = controller.to_s.humanize)
          content_tag(:li, :class => active_nav_class_for_controller(controller)) do
            link_to title, url
          end
        end

        def row_class(index)
          return 'even' if index.to_i % 2 == 1
          'odd'
        end

        def get_tabindices
          MTMD::FamilyCookBook::Tabindices.new
        end

        def active_nav_class_for_controller(controller)
          request.controller == controller.to_s ? 'active' : ''
        end

        def form_group(form, attr, opts = {})
          input_type = opts.fetch(:input_type, :text_field)
          tabindex = opts.delete(:tabindex)
          html = ''.html_safe
          html << form.label(opts.fetch(:label, attr), :class => 'col-sm-2')
          html << content_tag(:div, :class => 'col-sm-9') do
            text_field_opts = { :class => 'form-control' }
            text_field_opts.merge!({ :tabindex => tabindex }) if tabindex
            text_field_opts.merge!(opts.slice(:value))
            form.send(input_type, attr, text_field_opts)
          end

          outer_opts = opts.fetch(:form_group, nil)
          outer_opts[:class] = outer_opts[:class] + ' form-group' if outer_opts
          if outer_opts.nil?
            outer_opts = {}
            outer_opts[:class] = 'form-group'
          end

          content_tag(:div, outer_opts) do
            html
          end
        end

        def menu_item_slot_normalized_name(slot_index)
          slot = menu_item_slot_as_string(slot_index)
          parts = slot.split('::')
          parts.last.downcase
        end

        def menu_item_slot_as_string(slot_index)
          return 0 unless MTMD::FamilyCookBook::MenuItem::SLOTS[slot_index]
          MTMD::FamilyCookBook::MenuItem::SLOTS[slot_index]
        end

        def menu_item_slots
          slot_keys = []
          MTMD::FamilyCookBook::MenuItem::SLOTS.map.with_index{ |x, i|
            next if i == 0
            slot_keys << i
          }
          slot_keys
        end

        def parse_date(date)
          DateTime.parse(date.to_s).to_i
        end

        def attribute_row(model, attr, opts = {}, &block)
          attr_value = eval_model_attribute(model, attr, &block)

          cell_options = opts.fetch(:cell, {})
          cell_tag = cell_options.delete(:tag) || :td

          html = content_tag(cell_tag, cell_options) do
            content_tag(:strong) { opts.fetch(:label, attr.to_s.humanize) }
          end

          html << content_tag(cell_tag, cell_options) do
            attr_value
          end

          content_tag(:tr) { html }
        end

        def eval_model_attribute(model, attr, &block)
          attr_value = model.send(attr)
          return attr_value unless block
          block.call(attr_value)
        end

        def error_messages(&block)
          content_tag(:div, :class => 'errors bg-danger') do
            block.call
          end
        end

        def boolean_label(value)
          klass = value ? 'label-success' : 'label-danger'
          content_tag(:span, value, class: "label #{klass}")
        end

        def url_field(value)
          return unless value

          link_to(
            value,
            value.tr('"', ''),
            { :target => '_new' }
          )
        end

        def daterange_field(attribute)
          return unless attribute
          klass = 'label-danger'

          if attribute.begin <= Time.now && attribute.end >= Time.now
            klass = 'label-success'
          end

          content_tag(
            :span,
            "#{attribute.begin} - #{attribute.end}",
            :class => "label #{klass}"
          )
        end

        def flash_messages
          css_class = 'alert-info'
          keys = flash.keys

          return if keys.empty?

          if keys.include?(:success)
            css_class = 'alert-success'
          elsif keys.include?(:error)
            css_class = 'alert-danger'
          end

          content_tag(:div, :class => "alert #{css_class}") do
            flash.map { |k,v| v }.join('\n')
          end
        end

        def space(width = 3)
          ('&nbsp;' * width).html_safe
        end
    end
  end
end

MTMD::FamilyCookBook::App.helpers MTMD::FamilyCookBook::ApplicationHelper
