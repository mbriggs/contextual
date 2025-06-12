module AppendHelper
  def append_data!(name, value, kwargs)
    data = kwargs[:data] ||= {}
    data[name] = value.to_s
    data
  end

  def append_value!(name, value, kwargs)
    append_data!("#{name.to_s.dasherize}-value", value, kwargs)
  end

  def append_class!(kwargs, *)
    kwargs[:class] = classnames(kwargs[:class], *)
  end

  def disable_prefetch!(kwargs)
    append_data!("turbo_prefetch", false, kwargs)
  end

  def append_confirm!(kwargs, confirm)
    if !confirm
      return
    end

    append_controller!("confirm", kwargs)
    disable_prefetch!(kwargs)

    if [true, false].include?(confirm)
      return
    end

    append_value!(:confirm_message, confirm, kwargs)
  end

  def append_controller!(ctrl, kwargs)
    kwargs[:data] ||= {}
    controller = kwargs[:data].delete(:controller)
    case controller
    when String
      controller = [controller, ctrl]
    when Array
      controller << ctrl
    else
      controller = ctrl
    end

    kwargs[:data][:controller] = controller
    kwargs
  end

  private def classnames(*classes)
    classes.flatten.compact.compact_blank.join(" ")
  end
end
