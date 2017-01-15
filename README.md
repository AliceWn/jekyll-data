# JekyllData

[![Gem Version](https://img.shields.io/gem/v/jekyll-data.svg)](https://rubygems.org/gems/jekyll-data)
[![Build Status](https://img.shields.io/travis/ashmaroli/jekyll-data/master.svg?label=Build%20Status)][travis]

[travis]: https://travis-ci.org/ashmaroli/jekyll-data

Introducing a plugin that reads data files within **jekyll theme-gems** and adds the resulting hash to the site's internal data hash. If a **`_config.yml`** is present at the root of the theme-gem, it will be read as well.

## Installation

Simply add the plugin to your site's Gemfile and config file like every other jekyll plugin gems..
```ruby
# Gemfile

group :jekyll_plugins do
  gem "jekyll-data"
end
```
```yaml
# _config.yml

gems:
  - jekyll-data

```
..and run 
```
bundle install
```

## Usage

**Note:** *This plugin will only run in conjunction with a gem-based Jekyll-theme.*

As long as the plugin gem has been installed properly, and is included in both the Gemfile & the config file, data-files supported by Jekyll and present in the `_data` directory at the root of your theme gem will be read. Their contents will be added to the site's internal data hash, provided, an identical data hash doesn't already exist at the site-source.

If the theme-gem also includes a `_config.yml` at its root, then it will be read as well. The resulting config hash will be mixed into the site's existing config hash, filling in where the *keys* are not already defined. In other words, the site's config hash without this plugin, will override the conflicting config hash generated by this plugin from reading the included `_config.yml`

### Theme Configuration

Jekyll themes (built prior to Jekyll 3.2) usually ship with configuration settings defined in the config file, which are then used within the theme's template files directly under the `site` namespace (e.g. `{{ site.myvariable }}`). This is not possible with theme gems as a config file and data-files within gems are not natively read (as of Jekyll 3.3), and hence require end-users to inspect a *demo* or *example* directory to source those files.

This plugin provides a solution to that hurdle:

JekyllData now reads the config file (at present only `_config.yml`) present within the theme-gem and uses the data to modify the site's config hash. This allows the theme-gem to continue using `{{ site.myvariable }}` within its templates and work out-of-the-box as intended, with minimal user intervention.

#### The `theme` namespace

From v0.5, JekyllData no longer supports reading theme configuration provided as a `[theme-name].***` file within the `_data` directory and instead the `theme` namespace points to a certain key in the bundled `_config.yml`.

For `{{ theme.variable }}` to work, the config file should nest all such key-value pairs under the `[theme-name]` key, as outlined in the example below for a theme-gem called `solitude`:

```yaml
# <solitude-0.1.0>/_config.yml

# the settings below have been used in this theme's templates via the
# `theme` namespace. e.g. `{{ theme.recent_posts.style }}` instead of
# using `{{ site.solitude.recent_posts.style }}` though both are
# functionally the same.
#
solitude:
  sidebar: true # enter 'false' to enable horizontal navbar instead.
  theme_variant: Charcoal # choose from 'Ocean', 'Grass', 'Charcoal'
  recent_posts:
    style: list # choose from 'list' and 'grid'.
    quantity: '4' # either '4' or '6'

```

### Data-files

Data files may be used to supplement theme templates (e.g. locales and translated UI text) and can be named as desired. Either use a sub-directory to house related data-files or declare all of them as a mapped data block within a single file.

```yaml
# <theme-gem>/_data/apparel.yml

shirts:
  - color: white
    size: large
    image: s_w_lg.jpg
  - color: black
    size: large
    image: s_b_lg.jpg

jeans:
  - color: khaki
    waist: 34
    image: j_kh_34.jpg
  - color: blue
    waist: 32
    image: j_bu_32.jpg
```
is the same as:
```yaml
# <theme-gem>/_data/apparel/shirts.yml

- color: white
  size: large
  image: s_w_lg.jpg
- color: black
  size: large
  image: s_b_lg.jpg
```
```yaml
# <theme-gem>/_data/apparel/jeans.yml

- color: khaki
  waist: 34
  image: j_kh_34.jpg
- color: blue
  waist: 32
  image: j_bu_32.jpg
```

### User-overrides

To override directives shipped with a theme gem, simply have an identical hash at the site-source.  
e.g.
```yaml
# <site_source_dir>/_data/navigation.yml

mainmenu:
  - title: Home
    url: /
  - title: Kitchen Diaries
    url: /kitchen-diaries/
  - title: Tips & Tricks
    url: /tips-n-tricks/
  - title: Health Facts
    url: /health/
  - title: About Me
    url: /about/ 
 ```
 would have overridden the following:
 ```yaml
# <theme-gem>/_data/navigation/mainmenu.yml

- title: Link Item 1
  url: /link-one/
- title: Link Item 2
  url: /link-two/
- title: Link Item 3
  url: /link-three/
```

## Contributing

Bug reports and pull requests are welcome at the [GitHub Repo](https://github.com/ashmaroli/jekyll-data). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
