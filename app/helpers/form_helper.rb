module FormHelper
  def styled_form_with(*, **kwargs, &)
    kwargs[:builder] ||= FormBuilder
    form_with(*, **kwargs, &)
  end

  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    include AppendHelper

    # Override standard fields to apply consistent styling
    ["text_field", "email_field", "password_field"].each do |field_method|
      alias_method :"#{field_method}_original", field_method

      define_method field_method do |method, **options|
        if options.delete(:labeled) != false
          render_labeled_field(method, options) do
            apply_field_classes(options, :input)
            send(:"#{field_method}_original", method, **options)
          end
        else
          apply_field_classes(options, :simple)
          send(:"#{field_method}_original", method, **options)
        end
      end
    end

    alias text_area_original text_area
    def text_area(method, **options)
      if options.delete(:labeled) != false
        render_labeled_field(method, options) do
          apply_field_classes(options, :input)
          text_area_original(method, **options)
        end
      else
        apply_field_classes(options, :simple)
        text_area_original(method, **options)
      end
    end

    alias select_original select
    def select(method, choices, options = {}, html_options = {})
      if html_options.delete(:labeled) != false
        render_labeled_field(method, options.merge(html_options)) do
          apply_field_classes(html_options, :input)
          select_original(method, choices, options, html_options)
        end
      else
        apply_field_classes(html_options, :simple)
        select_original(method, choices, options, html_options)
      end
    end

    alias submit_original submit
    def submit(value = nil, **options)
      if options[:class].blank?
        helper = @template
        options[:class] = helper.button_classes
      end
      submit_original(value, **options)
    end

    private def render_labeled_field(method, options, &)
      label = options.delete(:label)
      hint = options.delete(:hint)

      content = []

      # Label
      label_text = label || method.to_s.humanize
      content << @template.label(object_name, method, label_text,
                               class: "block text-sm font-medium text-gray-700 mb-2")

      # Field
      content << yield

      # Hint
      if hint
        content << @template.content_tag(:p, hint,
                                       class: "text-sm text-gray-500 mt-1")
      end

      @template.content_tag(:div, content.join.html_safe)
    end

    private def apply_field_classes(options, style)
      classes = case style
      when :input
        "w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
      when :simple
        "block shadow-sm rounded-md border border-gray-400 focus:outline-solid focus:outline-blue-600 px-3 py-2 mt-2 w-full"
      end

      append_class!(options, classes)
    end
  end
end
