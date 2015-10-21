module API
  class FailureApp
    def self.call(env)
      [422, {"Content-Type" => "application/json"}, [{"errors" => ["Invalid login credentials"]}.to_json]]
    end
  end
end