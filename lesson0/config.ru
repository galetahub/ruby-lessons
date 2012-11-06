# -*- encoding: utf-8 -*-
$:.push File.expand_path('../', __FILE__)

require "server"

use Lesson0::SomeMiddleware

run Lesson0::Server.new