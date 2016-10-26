class PusherController < ApplicationController
  skip_before_action :verify_authenticity_token

  def auth
    if current_user
      response = Pusher.authenticate(params[:channel_name], params[:socket_id], {
        user_id: current_user["id"], # => required
        user_info: { # => optional - for example
          login: current_user["login"],
          dname: current_user["dname"]
        }
      })
      render json: response
    else
      render text: 'Forbidden', status: '403'
    end
  end


  def current_user
    client = Panoptes::Client.new(
      env: :staging,
      auth: {token: request.headers["Authorization"]},
      public_key_path: Rails.root.join("config/panoptes_signing_key.pub"), # TODO: Support production key too
    )

    client.current_user
  end
end
