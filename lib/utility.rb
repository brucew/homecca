module Utility
#  class Skills
#    attr_accessor :a
#
#    STOP_WORDS = ['an', 'the', 'or', 'and', 'service']
#
#    def initialize(skills)
#      self.a = skills.to_s.gsub(',', ' ').gsub(/[^[:alpha:]|[:space:]]/, '').split(%r{\s+})
#      self.a.delete_if {|s| s.length < 2}
#      self.a = self.a - STOP_WORDS
#    end
#
#    def mod_a
#      self.a.collect {|s| s.end_with?('er') ? s.chomp('er') + 'ing' : s}
#    end
#
#    def tag_list
#      self.mod_a.collect { |skill| skill.stem }
#    end
#
#    def search_tags
#      self.mod_a.collect { |skill| skill.stem.size > 3 ? skill.stem + '%' : skill.stem }
#    end
#
#    def to_s
#      self.a.join(', ')
#    end
#
#    def search_string
#      self.a.join(' ')
#    end
#
#  end

  class FacebookMetadata
    attr_accessor :title, :description, :image_url

    def initialize(attrs)
      self.title = attrs[:title]
      self.description = attrs[:description]
      self.image_url = attrs[:image_url]
    end
  end
  
end