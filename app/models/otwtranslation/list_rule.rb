class Otwtranslation::ListRule < Otwtranslation::ContextRule 

  CONDITIONS = {
    "has less/equal elements than" => "has_le_elements?",
    "has number of elements" => "has_number_elements?",
    "has more elements than" => "has_gt_elements?",
    "matches all" => "matches_all",
  }

  ACTIONS = {
    "replace" => "replace",
    "append" => "append",
    "prepend" => "prepend",
    "list to sentence" => "list_to_sentence"
  }


  ############################################################
  # Definition of conditions:
  

  def self.condition_has_le_elements?(value, params)
    match = false
    params.each do |param|
      begin
        match ||= (value.length <= param.to_i)
      rescue NoMethodError
        match ||= false
      end
    end
    return match
  end

  def self.condition_has_number_elements?(value, params)
    match = false
    params.each do |param|
      begin
        match ||= (value.length == param.to_i) 
      rescue NoMethodError
        match ||= false
      end
    end
    return match
  end

  def self.condition_has_gt_elements?(value, params)
    match = false
    params.each do |param|
      begin
        match ||= (value.length > param.to_i)
      rescue NoMethodError
        match ||= false
      end
    end
    return match
  end

  ############################################################
  # Definition of actions:
  
  def self.action_list_to_sentence(name, value, params)
    begin
      value.to_sentence(:words_connector => params[0].to_s,
                        :two_words_connector => params[1].to_s,
                        :last_word_connector => params[2].to_s)
    rescue NoMethodError
      return value.to_s
    end
  end

  ############################################################

end
