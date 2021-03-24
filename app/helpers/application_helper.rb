module ApplicationHelper
  def dark_mode_helper
    if cookies[:theme] == "light"
      link_to root_path(theme: "dark"), class: "btn btn-outline-secondary" do
        "<i class='fa fa-moon text-light'></i>".html_safe
      end
    else
      link_to root_path(theme: "light"), class: "btn btn-outline-secondary" do
        "<i class='far fa-moon text-light'></i>".html_safe
      end
    end
  end

  # boolean green or red
  def boolean_label(value)
    case value
      when true
        # content_tag(:span, "Yes", class: "badge bg-success")
        content_tag(:span, value, class: "badge bg-success")
      when false
        content_tag(:span, value, class: "badge bg-danger")
    end
  end

  # icons for omniauth
  def social_icon(provider)
    case provider
      when :google_oauth2
        content_tag(:i, nil, class: "fab fa-google")
      when :github
        content_tag(:i, nil, class: "fab fa-github")
      when :twitter
        content_tag(:i, nil, class: "fab fa-twitter")
      when :facebook
        content_tag(:i, nil, class: "fab fa-facebook")
      when :gitlab
        content_tag(:i, nil, class: "fab fa-gitlab")
    end
  end

  def social_color(provider)
    case provider
      when :google_oauth2
        "danger"
      when :github
        "dark"
      when :twitter
        "info"
      when :facebook
        "primary"
      when :gitlab
        "warning"
    end
  end

  # link_to "homepage", root_path
  def active_link_to(name, path)
    content_tag(:li, class: "#{"active font-weight-bold" if current_page?(path)} nav-item") do
      link_to name, path, class: "nav-link"
    end
  end

  # link_to root_path do "homepage"
  def long_active_link_to(path)
    content_tag(:li, class: "#{"active font-weight-bold" if current_page?(path)} nav-item") do
      link_to path, class: "nav-link" do
        yield
      end
    end
  end

  # link_to root_path do "homepage"
  def sidebar_long_active_link_to(path)
    content_tag(:li, class: "#{"active font-weight-bold bg-light shadow rounded" if current_page?(path)} nav-item") do
      link_to path, class: "nav-link" do
        yield
      end
    end
  end

end