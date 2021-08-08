# -*- encoding: utf-8 -*-
# stub: fxruby 1.6.44 ruby lib
# stub: ext/fox16_c/extconf.rb

Gem::Specification.new do |s|
  s.name = "fxruby".freeze
  s.version = "1.6.44"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "msys2_mingw_dependencies" => "fox" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lyle Johnson".freeze, "Lars Kanis".freeze]
  s.bindir = "exe".freeze
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDPDCCAiSgAwIBAgIBBTANBgkqhkiG9w0BAQsFADBEMQ0wCwYDVQQDDARsYXJz\nMR8wHQYKCZImiZPyLGQBGRYPZ3JlaXotcmVpbnNkb3JmMRIwEAYKCZImiZPyLGQB\nGRYCZGUwHhcNMjAxMjI2MTgzMzUyWhcNMjExMjI2MTgzMzUyWjBEMQ0wCwYDVQQD\nDARsYXJzMR8wHQYKCZImiZPyLGQBGRYPZ3JlaXotcmVpbnNkb3JmMRIwEAYKCZIm\niZPyLGQBGRYCZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDZb4Uv\nRFJfRu/VEWiy3psh2jinETjiuBrL0NeRFGf8H7iU9+gx/DI/FFhfHGLrDeIskrJx\nYIWDMmEjVO10UUdj7wu4ZhmU++0Cd7Kq9/TyP/shIP3IjqHjVLCnJ3P6f1cl5rxZ\ngqo+d3BAoDrmPk0rtaf6QopwUw9RBiF8V4HqvpiY+ruJotP5UQDP4/lVOKvA8PI9\nP0GmVbFBrbc7Zt5h78N3UyOK0u+nvOC23BvyHXzCtcFsXCoEkt+Wwh0RFqVZdnjM\nLMO2vULHKKHDdX54K/sbVCj9pN9h1aotNzrEyo55zxn0G9PHg/G3P8nMvAXPkUTe\nbrhXrfCwWRvOXA4TAgMBAAGjOTA3MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0G\nA1UdDgQWBBRAHK81igrXodaDj8a8/BIKsaZrETANBgkqhkiG9w0BAQsFAAOCAQEA\nDT6QoI7WEM1wivGn5BBHv3hJa2vGgmAxSPy7QM5iQX7U2ROfOeXYIHIRxsIv/cQl\n+F568J6v3GAcFePi4Is9S7b8KWQkm+IjrPjL863hds6WVG8KyJZ758oczbviXNEV\nvzna4S8Ra0m7LqGYGZW9B8ZIVdfhzKAF6V6iVlQtEFP7GQp17SjpNPd/gCbictIw\n+jwual4DCn3p1X+Vgyl/AXPwU1NBAuuYUijOr7dVIoW2QNUh2d7jCwGe2mNi7Dbu\nCqyDIUe+OuWLEpvgupYpVKQKx4+pa0s2ccLokMXYGFp1Z36heaYApV92yDjks8Sq\nXtSi3zpLl4JPGBoeuZj97Q==\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2020-12-31"
  s.email = ["lyle@lylejohnson.name".freeze, "lars@greiz-reinsdorf.de".freeze]
  s.extensions = ["ext/fox16_c/extconf.rb".freeze]
  s.files = ["ext/fox16_c/extconf.rb".freeze]
  s.homepage = "https://github.com/larskanis/fxruby".freeze
  s.licenses = ["LGPL-2.1".freeze]
  s.required_ruby_version = Gem::Requirement.new([">= 2.3".freeze, "< 4".freeze])
  s.rubygems_version = "3.1.4".freeze
  s.summary = "FXRuby is the Ruby binding to the FOX GUI toolkit.".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<mini_portile2>.freeze, ["~> 2.1"])
  else
    s.add_dependency(%q<mini_portile2>.freeze, ["~> 2.1"])
  end
end
