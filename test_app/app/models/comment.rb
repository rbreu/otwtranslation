require 'html_cleaner'

class Comment < ActiveRecord::Base

  include HtmlCleaner

  attr_protected :content_sanitizer_version

  belongs_to :pseud
  belongs_to :commentable, :polymorphic => true
  belongs_to :parent, :polymorphic => true

  validates_presence_of :content
  validates_length_of :content,
    :maximum => ArchiveConfig.COMMENT_MAX,
    :too_long => 'invalid_content_length', :count => ArchiveConfig.COMMENT_MAX


  scope :recent, lambda { |*args| {:conditions => ["created_at > ?", (args.first || 1.week.ago.to_date)]} }
  scope :limited, lambda {|limit| {:limit => limit.kind_of?(Fixnum) ? limit : 5} }
  scope :ordered_by_date, :order => "created_at DESC"
  scope :top_level, :conditions => ["commentable_type in (?)", ["Chapter", "Bookmark"]]
  scope :include_pseud, :include => :user
  scope :not_deleted, :conditions => {:is_deleted => false}

  # Gets methods and associations from acts_as_commentable plugin
  acts_as_commentable
  has_comment_methods


  before_create :set_depth
  before_create :set_thread_for_replies
  before_create :set_parent
  after_create :update_thread
  before_create :adjust_threading, :if => :reply_comment?

  # Set the depth of the comment: 0 for a first-class comment, increasing with each level of nesting
  def set_depth
    self.depth = self.reply_comment? ? self.commentable.depth + 1 : 0
  end

  # The thread value for a reply comment should be the same as its parent comment
  def set_thread_for_replies
    self.thread = self.commentable.thread if self.reply_comment?
  end

  # Save the ultimate parent
  def set_parent
    self.parent = self.reply_comment? ? self.commentable.parent : self.commentable
  end

  # We need a unique thread id for replies, so we'll make use of the fact
  # that ids are unique
  def update_thread
    self.update_attribute(:thread, self.id) unless self.thread
  end

  def adjust_threading
    self.commentable.add_child(self)
  end

  # Is this a first-class comment?
  def top_level?
    !self.reply_comment?
  end

  def comment_owner
    self.pseud.try(:user)
  end

  def comment_owner_name
    self.pseud.try(:name)
  end

  def comment_owner_email
    comment_owner.try(:email)
  end

  # override this method from commentable_entity.rb
  # to return the name of the ultimate parent this is on
  # we have to do this somewhat roundabout because until the comment is
  # set and saved, the ultimate_parent method will not work (the thread is not set)
  # and this is being called from before then.
  def commentable_name
    self.reply_comment? ? self.commentable.ultimate_parent.commentable_name : self.commentable.commentable_name
  end

  # override this method from comment_methods.rb to return ultimate
  alias :original_ultimate_parent :ultimate_parent
  def ultimate_parent
    myparent = self.original_ultimate_parent
    myparent
  end

  def self.commentable_object(commentable)
    commentable
  end

  def find_all_comments
    self.all_children
  end

  def count_all_comments
    self.children_count
  end

  def count_visible_comments
    self.children_count #FIXME
  end

  def sanitized_content
    sanitize_field self, :content
  end


  def visible?
    true
  end
end
