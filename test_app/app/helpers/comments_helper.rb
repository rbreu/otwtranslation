module CommentsHelper
  
  def value_for_comment_form(commentable, comment)
    [commentable, comment]
  end
  
  def title_for_comment_page(commentable)
    if commentable.commentable_name.blank?
      title = ""
    else
      title = link_to(commentable.commentable_name, commentable)
    end
    h(ts('Reading Comments on ')) + title
  end
  
  def last_reply_by(comment)
    if comment.count_all_comments > 0
      c = Comment.find(:first, :conditions => {:thread => comment.id}, :order => 'created_at DESC')
      if c.pseud
        link_to c.pseud.name, [c.pseud.user, c.pseud]
      else
        h(c.name)
      end
    end    
  end

  def link_to_comment_ultimate_parent(comment)
    ultimate = comment.ultimate_parent
    case ultimate.class.to_s 
    when 'Work' then 
      link_to ultimate.title, ultimate
    when 'Pseud' then
      link_to ultimate.name, ultimate
    when 'AdminPost' then 
      link_to ultimate.title, ultimate
    else
      link_to 'Something Interesting', ultimate
    end
  end

  # return pseudname or name for comment
  def get_commenter_pseud_or_name(comment)
    if comment.pseud_id
      if comment.pseud.nil?
        'Account Deleted'
      else
        comment.pseud.byline
      end
    else
      comment.name
    end
  end 

  ####
  ## Mar 4 2009 Enigel: the below shouldn't happen anymore, please test
  ####
  ## Note: there is a small but interesting bug here. If you first use javascript to open
  ## up the comments, the various url_for(:overwrite_params) arguments used below as the
  ## non-javascript fallbacks will end up with the wrong code, and so if you then turn
  ## off Javascript and try to use the links, you will get weirdo results. I think this
  ## is a bug we can live with for the moment; someone consistently browsing without
  ## javascript shouldn't have problems.
  ## -- Naomi, 9/2/2008
  ####
  
  #### Helpers for _commentable.html.erb ####

  # return link to show or hide comments
  def show_hide_comments_link(commentable)
    if params[:show_comments]
      hide_comments_link(commentable)
    else
      show_comments_link(commentable)
    end 
  end
  
  def show_comments_link(commentable)
    if commentable.count_visible_comments > 0
      if commentable.is_a?(Otwtranslation::Translation)
        commentable_id = :translation_id
        commentable_value = commentable.id
      else
        commentable_id = "#{commentable.class.to_s.underscore}_id".to_sym
        commentable_value = commentable.id
      end
      link_to("Comments #{commentable.count_visible_comments.to_s}",
              url_for(:controller => "/comments", #:comments, 
                      :action => :show_comments, 
                      commentable_id => commentable_value,
                      :view_full_work => params[:view_full_work]), 
              :remote => true)
    end
  end
    
  def hide_comments_link(commentable)
    if commentable.is_a?(Otwtranslation::Translation)
      commentable_id = :translation_id
      commentable_value = commentable.id
    else
      commentable_id = "#{commentable.class.to_s.underscore}_id".to_sym
      commentable_value = commentable.id
    end
    link_to("Hide Comments #{commentable.count_visible_comments.to_s}", 
            url_for(:controller => :comments, 
                    :action => :hide_comments, 
                    commentable_id => commentable_value),
            :remote => true)
  end
  
  # return the appropriate link to add or cancel adding a new comment (note: ONLY in _commentable.html.erb!)
  def add_cancel_comment_link(commentable)  
    if params[:add_comment]
      cancel_comment_link(commentable)
    else
      add_comment_link(commentable)
    end     
  end
  
  # return html link to add new comment on a commentable object
  def add_comment_link(commentable)
    commentable_id = "#{commentable.class.to_s.underscore}_id".to_sym
    commentable_value = commentable.id
    link_to(
      "Comment",
      url_for(:controller => :comments, :action => :add_comment, commentable_id => commentable_value),
      :remote => true) 
  end
      
  def cancel_comment_link(commentable)
    commentable_id = "#{commentable.class.to_s.underscore}_id".to_sym
    commentable_value = commentable.id
    link_to(
      "Cancel Comment",
      url_for(:controller => :comments, 
              :action => :cancel_comment, 
              commentable_id => commentable_value),
      :remote => true)
  end
      
  #### HELPERS FOR REPLYING TO COMMENTS #####

  def add_cancel_comment_reply_link(comment)
    if params[:add_comment_reply_id] && params[:add_comment_reply_id] == comment.id.to_s
      cancel_comment_reply_link(comment)
    else
      add_comment_reply_link(comment)
    end     
  end
  
  # return link to add new reply to a comment
  def add_comment_reply_link(comment)
    commentable_id = "#{comment.ultimate_parent.class.to_s.underscore}_id".to_sym
    commentable_value = comment.ultimate_parent.id
    link_to( 
      "Reply", 
      url_for(:controller => :comments, 
              :action => :add_comment_reply, 
              :id => comment.id, 
              :comment_id => params[:comment_id], 
              commentable_id => commentable_value),
      :remote => true)
  end  
  
  # return link to cancel new reply to a comment
  def cancel_comment_reply_link(comment)
    commentable_id = "#{comment.ultimate_parent.class.to_s.underscore}_id".to_sym
    commentable_value = comment.ultimate_parent.id
    link_to( 
      "Cancel", 
      url_for(:controller => :comments, 
              :action => :cancel_comment_reply, 
              :id => comment.id, 
              :comment_id => params[:comment_id], 
              commentable_id => commentable_value), 
      :remote => true)
  end  

  # TO DO: create fallbacks to support non-JavaScript requests!
  # return button to cancel adding a comment. kind of ugly because we want it
  # to work for the comment form no matter where it appears, but oh well
  def cancel_comment_button(comment, commentable)
    if comment.new_record?
      if commentable.class == comment.class
        # canceling a reply to a comment
        commentable_id = "#{commentable.ultimate_parent.class.to_s.underscore}_id".to_sym
        commentable_value = commentable.ultimate_parent.id
        link_to( 
          "Cancel", 
          url_for(:controller => :comments, 
                  :action => :cancel_comment_reply, 
                  :id => commentable.id, 
                  :comment_id => params[:comment_id], 
                  commentable_id => commentable_value),
          :remote => true) 
       else
        # canceling a reply to a different commentable thingy
        commentable_id = "#{commentable.class.to_s.underscore}_id".to_sym
        commentable_value = commentable.id        
        link_to(
          "Cancel", 
          url_for(:controller => :comments, 
                  :action => :cancel_comment, 
                  commentable_id => commentable_value),
          :remote => true)
      end
    else
      # canceling an edit
      link_to(
        "Cancel", 
        url_for(:controller => :comments, 
                :action => :cancel_comment_edit, 
                :id => (comment.id), 
                :comment_id => params[:comment_id]),
        :remote => true)
    end
  end  
    
  # return html link to edit comment
  def edit_comment_link(comment)
    link_to("Edit", 
            url_for(:controller => :comments, 
                    :action => :edit, 
                    :id => comment, 
                    :comment_id => params[:comment_id]),
            :remote => true)
  end
  
  def do_cancel_delete_comment_link(comment)
    if params[:delete_comment_id] && params[:delete_comment_id] == comment.id.to_s
      cancel_delete_comment_link(comment)
    else
      delete_comment_link(comment)
    end
  end
  
  # return html link to delete comments
  def delete_comment_link(comment)
    link_to( 
      "Delete", 
      url_for(:controller => :comments, 
              :action => :delete_comment, 
              :id => comment, 
              :comment_id => params[:comment_id]), 
      :remote => true)
  end

  # return link to cancel new reply to a comment
  def cancel_delete_comment_link(comment)
    link_to( 
      "Cancel", 
      url_for(:controller => :comments, 
              :action => :cancel_comment_delete, 
              :id => comment, 
              :comment_id => params[:comment_id]), 
      :remote => true)
  end    
  
  # return html link to mark/unmark comment as spam
  def tag_comment_as_spam_link(comment)    
    if comment.approved
      link_to('Spam', reject_comment_path(comment), :method => :put)
    else
      link_to('Not Spam', approve_comment_path(comment), :method => :put)
    end
  end

  # non-JavaScript fallbacks for great justice!
  
  def fallback_url_for_top_level(commentable, options = {})    
    default_options = {:anchor => "comments"}
    default_options[:controller] = commentable.class.to_s.underscore.pluralize
    default_options[:action] = "show"
    default_options[:id] = commentable.id
    default_options[:add_comment] = params[:add_comment] if params[:add_comment]
    default_options[:show_comments] = params[:show_comments] if params[:show_comments]
    
    options = default_options.merge(options)
    url_for(options)
  end
  
  def fallback_url_for_comment(comment, options = {})
    default_options = {:anchor => "comment_#{comment.id}"}
    default_options[:action] = "show"
    default_options[:show_comments] = true
    
    options = default_options.merge(options)
    
    if @thread_view # hopefully means we're on a Thread page
      options[:id] = @thread_root if @thread_root
      url_for(options)
    else # Top Level Commentable
      fallback_url_for_top_level(comment.ultimate_parent, options)
    end
    
  end

end
