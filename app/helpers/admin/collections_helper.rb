module Admin::CollectionsHelper

  # Collection helpers for dropdowns used in Helpy
  
  def agents_for_select
    User.agents.all.map { |user| [user.name, user.id] }
  end

  def channels_collection
    [
      [t('activerecord.attributes.user.email'), 'email'],
      [t('activerecord.attributes.user.home_phone'), 'phone'],
      [t(:channel_in_person, default: 'In Person'), 'person']
    ]
  end

  def statuses_collection
    statuses = []
    ['new','open','pending','closed'].each do |s|
      statuses << [t(s.to_sym), s]
    end
    statuses
  end

  def ticket_types_collection
    [
      [t('customer_conversation', default: "Customer Conversation"), 'ticket'],
      [t('internal_ticket', default: "Internal Ticket"), 'internal']
    ]
  end

  def ticket_priority_collection
    Topic.priorities.keys.map { |priority| [t("#{priority}_priority"), priority] }
  end

  def ticket_tag_collection
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'tags', taggable_type: 'Topic').includes(:tag).pluck('DISTINCT name').map{|name| name.capitalize}.sort 
  end

  def categories_collection
    Category.with_translations(I18n.locale).order(name: :asc).map {|c| [ c.name, c.id ] }
  end

  def i18n_reply_grouped_options
    grouped_options = {}
    AppSettings['i18n.available_locales'].each do |locale|
      Globalize.with_locale(locale) do
        # TODO THIS IS A HACK because there appears to be no difference in language files for chinese simple and traditional
        # This could be changed to display the language names in english fairly easily
        # but in another language we are missing the translations

        key = if ['zh-cn', 'zh-tw'].include? locale
                I18n.translate("i18n_languages.zh")
              else
                I18n.translate("i18n_languages.#{locale}")
              end
        val = []
        Doc.replies.with_translations(locale).all.each do |doc|
            body = ((doc.body))#.gsub(/\'/, '&#39;')
            val.push([doc.title, body])
        end
        grouped_options[key] = val
      end
    end
    grouped_options
  end

end