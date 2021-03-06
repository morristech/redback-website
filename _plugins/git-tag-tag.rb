require 'git'

module Jekyll

  class GitInfoTag < Liquid::Tag
    def git()
      git_dir = File.expand_path File.dirname(File.dirname(__FILE__))
      Git.open(git_dir)
    end
  end

  #
  # Show the latest tag.
  # If the current commit is the latest tag, then show just the tag name.
  # If not, show the latest tag, how many commits we are in front, and the hash of HEAD.
  #
  class GitTag < GitInfoTag
    include Jekyll::LiquidExtensions
    @@descr = ''
    def render(context)
      if @@descr == ''
        @@descr = git().describe('HEAD', :always => true)
      end
      return @@descr
    end
  end

  #
  # Show the hash of HEAD.
  #
  class GitHash < GitInfoTag
    include Jekyll::LiquidExtensions
    @@sha = ''
    def render(context)
      if @@sha == ''
        @@sha = git().object('HEAD').sha[0..9]
      end
      return @@sha
    end
  end
end

Liquid::Template.register_tag('git_tag', Jekyll::GitTag)
Liquid::Template.register_tag('git_hash', Jekyll::GitHash)
