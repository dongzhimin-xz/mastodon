# frozen_string_literal: true

class Sanitize
  module Config
    HTTP_PROTOCOLS = %w(
      http
      https
    ).freeze

    LINK_PROTOCOLS = %w(
      http
      https
      dat
      dweb
      ipfs
      ipns
      ssb
      gopher
      xmpp
      magnet
      gemini
    ).freeze

    CLASS_WHITELIST_TRANSFORMER = lambda do |env|
      node = env[:node]
      class_list = node['class']&.split(/[\t\n\f\r ]/)

      return unless class_list

      class_list.keep_if do |e|
        next true if /^(h|p|u|dt|e)-/.match?(e) # microformats classes
        next true if /^(mention|hashtag)$/.match?(e) # semantic classes
        next true if /^(ellipsis|invisible)$/.match?(e) # link formatting classes
      end

      node['class'] = class_list.join(' ')
    end

    TRANSLATE_TRANSFORMER = lambda do |env|
      node = env[:node]
      node.remove_attribute('translate') unless node['translate'] == 'no'
    end

    UNSUPPORTED_HREF_TRANSFORMER = lambda do |env|
      return unless env[:node_name] == 'a'

      current_node = env[:node]

      scheme = if current_node['href'] =~ Sanitize::REGEX_PROTOCOL
                 Regexp.last_match(1).downcase
               else
                 :relative
               end

      current_node.replace(current_node.document.create_text_node(current_node.text)) unless LINK_PROTOCOLS.include?(scheme)
    end

    UNSUPPORTED_ELEMENTS_TRANSFORMER = lambda do |env|
      return unless %w(h1 h2 h3 h4 h5 h6).include?(env[:node_name])

      current_node = env[:node]

      current_node.name = 'strong'
      current_node.wrap('<p></p>')
    end

    MASTODON_STRICT = freeze_config(
      elements: %w(p br span a del s pre blockquote code b strong u i em ul ol li ruby rt rp),

      attributes: {
        'a' => %w(href rel class translate),
        'span' => %w(class translate),
        'ol' => %w(start reversed),
        'li' => %w(value),
      },

      add_attributes: {
        'a' => {
          'rel' => 'nofollow noopener noreferrer',
          'target' => '_blank',
        },
      },

      protocols: {},

      transformers: [
        CLASS_WHITELIST_TRANSFORMER,
        TRANSLATE_TRANSFORMER,
        UNSUPPORTED_ELEMENTS_TRANSFORMER,
        UNSUPPORTED_HREF_TRANSFORMER,
      ]
    )

    MASTODON_OEMBED = freeze_config(
      elements: %w(audio iframe source video),

      attributes: {
        'audio' => %w(controls),
        'iframe' => %w(allowfullscreen frameborder height scrolling src width),
        'source' => %w(src type),
        'video' => %w(controls height loop width),
      },

      protocols: {
        'iframe' => { 'src' => HTTP_PROTOCOLS },
        'source' => { 'src' => HTTP_PROTOCOLS },
      },

      add_attributes: {
        'iframe' => { 'sandbox' => 'allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox allow-forms' },
      }
    )

    LINK_REL_TRANSFORMER = lambda do |env|
      return unless env[:node_name] == 'a' && env[:node]['href']

      node = env[:node]

      rel = (node['rel'] || '').split(' ') & ['tag']
      rel += ['nofollow', 'noopener', 'noreferrer'] unless TagManager.instance.local_url?(node['href'])

      if rel.empty?
        node.remove_attribute('rel')
      else
        node['rel'] = rel.join(' ')
      end
    end

    LINK_TARGET_TRANSFORMER = lambda do |env|
      return unless env[:node_name] == 'a' && env[:node]['href']

      node = env[:node]
      if node['target'] != '_blank' && TagManager.instance.local_url?(node['href'])
        node.remove_attribute('target')
      else
        node['target'] = '_blank'
      end
    end

    MASTODON_OUTGOING ||= freeze_config MASTODON_STRICT.merge(
      attributes: merge(
        MASTODON_STRICT[:attributes],
        'a' => %w(href rel class title target)
      ),

      add_attributes: {},

      transformers: [
        CLASS_WHITELIST_TRANSFORMER,
        UNSUPPORTED_HREF_TRANSFORMER,
        LINK_REL_TRANSFORMER,
        LINK_TARGET_TRANSFORMER,
      ]
    )
  end
end
