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
        badge_color = "badge bg-success"
      when false
        badge_color = "badge bg-danger"
    end
    content_tag(:span, value, class: badge_color)
  end

  # icons for omniauth
  def social_icon(provider)
    case provider
      when :google_oauth2
        social_image = "fab fa-google"
      when :github
        social_image = "fab fa-github"
      when :twitter
        social_image = "fab fa-twitter"
      when :facebook
        social_image = "fab fa-facebook"
      when :gitlab
        social_image = "fab fa-gitlab"
    end
    content_tag(:i, nil, class: social_image)
  end

  def status_label(status)
    case status
      when "planned"
        badge_color = "badge bg-danger"
      when "progress"
        badge_color = "badge bg-warning"
      when "done"
        badge_color = "badge bg-success"
    end
    content_tag(:span, status.titleize, class: badge_color)
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
    content_tag(:li, class: "#{"active fw-bold" if current_page?(path)} nav-item") do
      link_to name, path, class: "nav-link"
    end
  end

  # link_to root_path do "homepage"
  def long_active_link_to(path)
    content_tag(:li, class: "#{"active fw-bold" if current_page?(path)} nav-item") do
      link_to path, class: "nav-link" do
        yield
      end
    end
  end

  # link_to root_path do "homepage"
  def sidebar_long_active_link_to(path)
    content_tag(:li, class: "#{"active fw-bold bg-light shadow rounded" if current_page?(path)} nav-item") do
      link_to path, class: "nav-link" do
        yield
      end
    end
  end

end