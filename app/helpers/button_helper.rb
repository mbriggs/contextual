module ButtonHelper
  def button_link(text, url, variant: :primary, size: :medium, method: nil, confirm: nil, **options)
    css_classes = button_classes(variant: variant, size: size, full_width_mobile: false)

    # Merge with any existing classes
    if options[:class]
      css_classes = "#{css_classes} #{options[:class]}"
    end

    # Convert method to turbo_method data attribute
    if method && method != :get
      options[:data] ||= {}
      options[:data][:turbo_method] = method
    end

    # Convert confirm to turbo_confirm data attribute
    if confirm
      options[:data] ||= {}
      options[:data][:turbo_confirm] = confirm
    end

    link_to(text, url, **options, class: css_classes)
  end

  def button_classes(variant: :primary, size: :medium, full_width_mobile: false)
    base_classes = "font-medium rounded-lg transition-colors inline-block text-center cursor-pointer"
    base_classes += " w-full sm:w-auto" if full_width_mobile

    variant_classes = case variant
    when :primary
      "bg-blue-600 hover:bg-blue-700 text-white"
    when :secondary
      "bg-white text-gray-700 hover:text-gray-900 border border-gray-300 hover:bg-gray-50"
    when :danger
      "bg-red-600 hover:bg-red-700 text-white"
    when :success
      "bg-green-600 hover:bg-green-700 text-white"
    else
      "bg-gray-600 hover:bg-gray-700 text-white"
    end

    size_classes = case size
    when :small
      "px-2 py-1 text-sm"
    when :medium
      "px-3 py-2 text-sm"
    when :large
      "px-4 py-2"
    else
      "px-3 py-2 text-sm"
    end

    "#{base_classes} #{variant_classes} #{size_classes}"
  end
end
