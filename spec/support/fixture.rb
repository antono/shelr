module Fixture
  def self.load(name)
    file = File.join(File.expand_path("../../fixtures/#{name}", __FILE__))
    JSON.parse(File.read(file))
  end
end
