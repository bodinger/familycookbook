# Helper methods defined here can be accessed in any controller or view in the application

module MTMD
  module FamilyCookBook
    module IconHelper

      def icon(css_name, text, opts)
        html = ''.html_safe
        content_tag(:span, opts) do
          html << content_tag(:span, :class => "glyphicon glyphicon-#{css_name} pull-left") {}
          html << text
        end
      end

      def link(css_name, text, opts)
        html = ''.html_safe
        direction = opts.delete(:direction) || 'right'
        content_tag(:a, opts) do
          if direction == 'right'
            html << text + ' '
          end
          html << content_tag(:span, :class => "glyphicon glyphicon-#{css_name}") {}
          if direction == 'left'
            html << ' ' + text
          end
          html
        end
      end

      def last_link(text, opts = {})
        link('fast-forward', text, opts.merge({:direction => 'right'}))
      end

      def next_link(text, opts = {})
        link('step-forward', text, opts.merge({:direction => 'right'}))
      end

      def previous_link(text, opts = {})
        link('step-backward', text, opts.merge({:direction => 'left'}))
      end

      def first_link(text, opts = {})
        link('fast-backward', text, opts.merge({:direction => 'left'}))
      end

      def remove_link(text, opts = {})
        link('remove', text, opts.merge({:direction => 'left'}))
      end

      def list_link(text, opts = {})
        link('list-alt', text, opts.merge({:direction => 'left'}))
      end

      def eye_closed_link(text, opts = {})
        link('eye-close', text, opts.merge({:direction => 'left'}))
      end

      def eye_open_link(text, opts = {})
        link('eye-open', text, opts.merge({:direction => 'left'}))
      end

      def trash_link(text, opts = {})
        link('trash', text, opts.merge({:direction => 'left'}))
      end

      def checked_link(text, opts = {})
        link('ok', text, opts.merge({:direction => 'left'}))
      end

      def edit_link(text, opts = {})
        link('pencil', text, opts.merge({:direction => 'left'}))
      end

      def plus_link(text, opts = {})
        link('plus', text, opts.merge({:direction => 'left'}))
      end

      def minus_link(text, opts = {})
        link('minus', text, opts.merge({:direction => 'left'}))
      end

      def exclamation_link(text, opts = {})
        link('exclamation-sign', text, opts.merge({:direction => 'left'}))
      end

      def menu_link(text, opts = {})
        link('exclamation-sign', text, opts.merge({:direction => 'left'}))
      end

      def search_link(text, opts = {})
        link('search', text, opts.merge({:direction => 'left'}))
      end



      # def remove_icon(text, opts = {})
      #   icon('remove', text, opts)
      # end

      # def checked_icon(text, opts = {})
      #   icon('ok', text, opts)
      # end

      def clock_icon(text, opts = {})
        icon('time', text, opts)
      end

      def cutlery_icon(text, opts = {})
        icon('cutlery', text, opts)
      end

      def scale_icon(text, opts = {})
        icon('scale', text, opts)
      end

      def heartempty_icon(text, opts = {})
        icon('heart-empty', text, opts)
      end

      # def eye_open_icon(text, opts = {})
      #   icon('eye-open', text, opts)
      # end

      def plus_icon(text, opts = {})
        icon('plus', text, opts)
      end

      def minus_icon(text, opts = {})
        icon('minus', text, opts)
      end

      def edit_icon(text, opts = {})
        icon('pencil', text, opts)
      end

      # def eye_closed_icon(text, opts = {})
      #   icon('eye-close', text, opts)
      # end

      def menu_icon(text, opts = {})
        icon('exclamation-sign', text, opts)
      end

      def star_icon(text, opts = {})
        icon('star', text, opts)
      end

      def emptystar_icon(text, opts = {})
        icon('star-empty', text, opts)
      end

      def shopping_cart_icon(text, opts = {})
        icon('shopping-cart', text, opts)
      end

      # def trash_icon(text, opts = {})
      #   icon('trash', text, opts)
      # end

      def exclamation_icon(text, opts = {})
        icon('exclamation-sign', text, opts)
      end

    end
  end
end

MTMD::FamilyCookBook::App.helpers MTMD::FamilyCookBook::IconHelper
