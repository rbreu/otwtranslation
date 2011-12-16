require 'autocomplete_source'
class Pseud < ActiveRecord::Base

  NAME_LENGTH_MIN = 1
  NAME_LENGTH_MAX = 40

  belongs_to :user
  has_many :comments

  validates_presence_of :name
  validates_length_of :name,
    :within => NAME_LENGTH_MIN..NAME_LENGTH_MAX,
    :too_short => "is too short",
    :too_long => "is too long"
  validates_uniqueness_of :name, :scope => :user_id, :case_sensitive => false
  validates_format_of :name,
    :with => /\A[\p{Word} -]+\Z/u
  validates_format_of :name,
    :with => /\p{Alnum}/u

  after_update :check_default_pseud

  scope :alphabetical, order(:name)
  scope :starting_with, lambda {|letter| where('SUBSTR(name,1,1) = ?', letter)}

  # Enigel Dec 12 08: added sort method
  # sorting by pseud name or by login name in case of equality
  def <=>(other)
    (self.name.downcase <=> other.name.downcase) == 0 ? (self.user_name.downcase <=> other.user_name.downcase) : (self.name.downcase <=> other.name.downcase)
  end

  # For use with the work and chapter forms
  def user_name
     self.user.login
  end

  def to_param
    name
  end

  # look up by byline
  scope :by_byline, lambda {|byline|
    {
      :conditions => ['users.login = ? AND pseuds.name = ?',
        (byline.include?('(') ? byline.split('(', 2)[1].strip.chop : byline),
        (byline.include?('(') ? byline.split('(', 2)[0].strip : byline)
      ],
      :include => :user
    }
  }

  # Produces a byline that indicates the user's name if pseud is not unique
  def byline
    (name != user_name) ? name + " (" + user_name + ")" : name
  end

  # Parse a string of the "pseud.name (user.login)" format into a pseud
  def self.parse_byline(byline, options = {})
    pseud_name = ""
    user_login = ""
    if byline.include?("(")
      pseud_name, user_login = byline.split('(', 2)
      pseud_name = pseud_name.strip
      user_login = user_login.strip.chop
      conditions = ['users.login = ? AND pseuds.name = ?', user_login, pseud_name]
    else
      pseud_name = byline.strip
      if options[:assume_matching_login]
        conditions = ['users.login = ? AND pseuds.name = ?', pseud_name, pseud_name]
      else
        conditions = ['pseuds.name = ?', pseud_name]
      end
    end
    Pseud.find(:all, :include => :user, :conditions => conditions)
  end

  # Takes a comma-separated list of bylines
  # Returns a hash containing an array of pseuds and an array of bylines that couldn't be found
  def self.parse_bylines(list, options = {})
    valid_pseuds, ambiguous_pseuds, failures = [], {}, []
    bylines = list.split ","
    for byline in bylines
      pseuds = Pseud.parse_byline(byline, options)
      if pseuds.length == 1
        valid_pseuds << pseuds.first
      elsif pseuds.length > 1
        ambiguous_pseuds[pseuds.first.name] = pseuds
      else
        failures << byline.strip
      end
    end
    {:pseuds => valid_pseuds, :ambiguous_pseuds => ambiguous_pseuds, :invalid_pseuds => failures}
  end
  
  def replace_me_with_default
    Comment.update_all("pseud_id = #{self.user.default_pseud.id}", "pseud_id = #{self.id}") unless self.comments.blank?
    self.destroy
  end


  def check_default_pseud
    if !self.is_default? && self.user.pseuds.to_enum.find(&:is_default?) == nil
      default_pseud = self.user.pseuds.select{|ps| ps.name.downcase == self.user_name.downcase}.first
      default_pseud.update_attribute(:is_default, true)
    end
  end

  # Delete current icon (thus reverting to archive default icon)
  def delete_icon=(value)
    @delete_icon = !value.to_i.zero?
  end

  def delete_icon
    !!@delete_icon
  end
  alias_method :delete_icon?, :delete_icon

  def clear_icon
    self.icon = nil if delete_icon? && !icon.dirty?
  end

  ## AUTOCOMPLETE
  # set up autocomplete and override some methods
  include AutocompleteSource
  def autocomplete_prefixes
    [ "autocomplete_pseud" ]
  end

  def autocomplete_value
    "#{id}#{AUTOCOMPLETE_DELIMITER}#{byline}"
  end

  ## END AUTOCOMPLETE


end
