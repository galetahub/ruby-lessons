# use Timer
#
class Timer
  def initialize(app)
    @app = app
  end

  def call(env)
    before = Time.now
    status, headers, body = @app.call(env)

    headers['X-Timing'] = (Time.now - before).to_i.to_s

    [status, headers, body]
  end
end