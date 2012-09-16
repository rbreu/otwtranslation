#require 'routing_filter/filter'
module RoutingFilter
  class OtwTranslation < Filter
    def self.locales
      %w(en de nl)
    end

    def self.locales_pattern
      @@locales_pattern ||= %r(^/(#{self.locales.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
    end

    attr_reader :exclude
    def initialize(*args)
      super
      @exclude = options[:exclude]
    end


    def around_recognize(path, env, &block)
      locale = extract_segment!(self.class.locales_pattern, path)
      @locale = locale
      yield.tap do |params|
        params[:locale] = locale if locale
      end
    end

    def around_generate(*args, &block)
      params = args.extract_options!
      locale = params.delete(:locale)
      locale = locale || @locale || OtwtranslationConfig.DEFAULT_LANGUAGE
      locale = nil unless valid_locale?(locale)

      args << params

      yield.tap do |result|        
        url = result.is_a?(Array) ? result.first : result
        prepend_segment!(result, locale) if !excluded?(url)
      end
    end

    protected

    def valid_locale?(locale)
      self.class.locales.include?(locale)
    end

    def default_locale?(locale)
      locale == OtwtranslationConfig.DEFAULT_LANGUAGE
    end

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
