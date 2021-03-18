class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  Devise.omniauth_configs.keys.each do |provider|
    # omni callback routes us to this action
    # this action will be automatically named as the omni provider [:github, :google_oauth2]
    define_method provider do
      # at this point the omni callback works and we get provider data
      def auth
        @auth ||= request.env["omniauth.auth"]
      end

      if auth.nil?
        redirect_to root_path, alert: "No data received. Please try again"
      elsif auth.info.email.nil?
        redirect_to root_path, alert: "This social account does not have a public email. Try another account."
      else

        # we look for an identity and user that share this oauth data
        identity = User::Identity.find_by(provider: auth.provider, uid: auth.uid)
        user = User.find_by(email: auth.info.email)

        if user.present?
          if identity.present?
            identity.update(identity_params)
          else
            user.identities.create(identity_params)
          end
        else
          user = User.create(
            email: auth.info.email,
            password: Devise.friendly_token[0, 20]
          )
          if user.save?
            user.identities.create(identity_params)
          end
        end

        # confirm account with social login
        user.skip_confirmation!

        # to see from which provider the user is logged in now
        user.provider = auth.provider
        user.image = auth.info.image
        user.name = auth.info.name
        user.save

        if user.persisted?
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: provider
          sign_in_and_redirect user, event: :authentication
        else
          session["devise.github_data"] = auth.except("extra")
          redirect_to new_user_registration_url, alert: user.errors.full_messages.join("\n")
        end
      end
    end
  end

  def failure
    redirect_to root_path, alert: "Something went wrong. Please try again"
  end

  def identity_params
    # to see detailed info from the hash: <%= identity.auth["info"]["nickname"] %>
    # auth_hash = auth.to_hash
    # auth_hash.delete("credentials")
    # auth_hash["extra"]&.delete("access_token")
    {
      provider: auth.provider,
      uid: auth.uid,
      auth: auth.to_hash
    }
  end
end
