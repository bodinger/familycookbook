MTMD::FamilyCookBook::App.controllers :heartbeat do
  get :index do
    content_type :json
    '{"ok":"true"}'
  end
end
