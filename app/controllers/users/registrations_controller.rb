# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: %i[create]
end
