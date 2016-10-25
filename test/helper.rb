require "rubygems"
require "jekyll"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/profile"

require_relative "../lib/jekyll-data.rb"

Jekyll.logger = Logger.new(StringIO.new)

require "kramdown"
require "shoulda"

# Report with color.
Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(
    :color => true
  )
]

module Minitest::Assertions
  def assert_exist(filename, msg = nil)
    msg = message(msg) { "Expected '#{filename}' to exist" }
    assert File.exist?(filename), msg
  end

  def refute_exist(filename, msg = nil)
    msg = message(msg) { "Expected '#{filename}' not to exist" }
    refute File.exist?(filename), msg
  end
end

module DirectoryHelpers
  def fixture_dir(*subdirs)
    test_dir("fixtures", *subdirs)
  end

  def dest_dir(*subdirs)
    test_dir("dest", *subdirs)
  end

  def source_dir(*subdirs)
    test_dir("source", *subdirs)
  end

  def test_dir(*subdirs)
    File.join(File.dirname(__FILE__), *subdirs)
  end
end

class JekyllDataTest < Minitest::Test
  include Jekyll
  include DirectoryHelpers

  def fixture_site(overrides = {})
    Jekyll::Site.new(site_configuration(overrides))
  end

  def default_configuration
    Marshal.load(Marshal.dump(Jekyll::Configuration::DEFAULTS))
  end

  def build_configs(overrides, base_hash = default_configuration)
    Utils.deep_merge_hashes(base_hash, overrides)
  end

  def site_configuration(overrides = {})
    full_overrides = build_configs(overrides, build_configs({
      "incremental" => false
    }))
    Configuration.from(full_overrides.merge({
      "theme" => "test-theme",
      "lang"  => "en"
    }))
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
    FileUtils.rm_rf(source_dir(".jekyll-metadata"))
  end

  def capture_output
    stderr = StringIO.new
    Jekyll.logger = Logger.new stderr
    yield
    stderr.rewind
    return stderr.string.to_s
  end
  alias_method :capture_stdout, :capture_output
  alias_method :capture_stderr, :capture_output
end