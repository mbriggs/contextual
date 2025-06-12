module ApplicationHelper
  def error_messages_for(object)
    return unless object.errors.any?

    content_tag :div, class: "bg-red-50 border border-red-200 rounded-lg p-4" do
      content_tag(:h3, class: "text-sm font-medium text-red-800 mb-2") do
        "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class.model_name.human.downcase} from being saved:"
      end +
        content_tag(:ul, class: "text-sm text-red-700 list-disc list-inside") do
          object.errors.full_messages.map do |message|
            content_tag(:li, message)
          end.join.html_safe
        end
    end
  end

  def card(padding: :medium, tag: :div, header: nil, header_class: nil, **options, &block)
    padding_class = case padding
    when :small then "p-4"
    when :medium then "p-6"
    when :large then "p-8"
    else padding.to_s
    end

    base_classes = "bg-white rounded-lg shadow-sm border border-gray-200 #{padding_class}"

    # Merge with any existing classes
    if options[:class]
      base_classes = "#{base_classes} #{options[:class]}"
    end

    content_tag(tag, **options, class: base_classes) do
      content = ""

      if header
        default_header_class = "text-3xl font-bold text-gray-900 mb-8"
        final_header_class = header_class || default_header_class
        content += content_tag(:h1, header, class: final_header_class)
      end

      content += capture(&block) if block_given?
      content.html_safe
    end
  end
end
