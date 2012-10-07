#require 'routing_filter/filter'
module RoutingFilter
  class OtwTranslationLocaleFilter < Filter

    def self.locales_pattern
      locales = Otwtranslation::Language.all_locales
      %r(^/(#{locales.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
    end

    attr_reader :exclude
    def initialize(*args)
      super
      @exclude = options[:exclude]
    end

    def around_recognize(path, env, &block)
      locale = extract_segment!(self.class.locales_pattern, path)
      Otwtranslation::Language.current_locale = locale
      yield.tap do |params|
        params[:locale] = locale if locale
      end
    end

    def around_generate(*args, &block)
      params = args.extract_options!
      locale = params.delete(:locale)
      locale = (locale || Otwtranslation::Language.current_locale ||
                OtwtranslationConfig.DEFAULT_LANGUAGE)
      locale = nil unless Otwtranslation::Language.translation_visible_for?(User.current_user,
                                                                            locale)
      args << params

      yield.tap do |result| 
        url = result.is_a?(Array) ? result.first : result
        if locale && !excluded?(url)
          prepend_segment!(result, locale) if !excluded?(url)
        end
      end
    end

    protected

    def excluded?(url)
      case exclude
      when Regexp
        url =~ exclude
      when Proc
        exclude.call(url)
      end
    end
  end


  class OtwTranslationToolFilter < Filter

    @@tool_pattern = /^\/(translating)/

    attr_reader :exclude
    def initialize(*args)
      super
      @exclude = options[:exclude]
    end

    def around_recognize(path, env, &block)
      tool = extract_segment!(@@tool_pattern, path)
      Otwtranslation::Language.translation_tool_enabled = !!tool
      yield.tap do |params|
        params[:translating] = tool if tool
      end
    end

    def around_generate(*args, &block)
      params = args.extract_options!
      tool = params.delete(:translating)
      if tool == nil
        # might be false, which we want to keep
        tool = Otwtranslation::Language.translation_tool_enabled
      end
      args << params

      yield.tap do |result| 
        url = result.is_a?(Array) ? result.first : result
        if tool && !excluded?(url)
          prepend_segment!(result, 'translating')
        end
      end
    end

    protected

    def excluded?(url)
      case exclude
      when Regexp
        url =~ exclude
      when Proc
        exclude.call(url)
      end
    end
  end

end
