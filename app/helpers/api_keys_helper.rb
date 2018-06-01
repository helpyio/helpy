# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  user_id      :integer
#  name         :string
#  date_expired :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

module ApiKeysHelper

  def qrmodal(key, endpoint)
    target_div = 'modal' + key.name;

    content_tag(:div, class: 'qr') do
      content_tag(:div) do
        content_tag(:span, key.access_token).html_safe
      end.html_safe +
      content_tag(:button, '', class: ['btn', 'btn-primary', 'glyphicon', 'glyphicon-qrcode'], data: { toggle: 'modal', target: '#' + target_div }, type: 'button') +
      content_tag(:div, class: ['modal', 'fade'], id: target_div, tabindex: -1, role: 'dialog', aria: { labelledby: target_div + '_label'}) do
        content_tag(:div, class: 'modal-dialog', role: 'document') do
          content_tag(:div, class: 'modal-content') do
            mh = modal_header(key.name, target_div)
            concat(mh) +
            concat(modal_body(key.qrcode(endpoint))) +
            concat(modal_footer)
          end.html_safe
        end.html_safe
      end.html_safe
    end.html_safe
  end

  private

  def modal_header(key_name, name)
    content_tag(:div, class: 'modal-header') do
      content_tag(:h5, 'QR Code for ' + key_name, class: 'modal-title', id: name + '_label') +
      content_tag(:button, class: 'close', data: { dismiss: 'modal' }, aria: { label: 'Close' }) do
        content_tag(:span, '', aria: { hidden: "true" })
      end.html_safe
    end.html_safe
  end

  def modal_body(qr)
    content_tag(:div, class: 'modal-body') do
      content_tag(:div, qr.html_safe, class: 'qr')
      raw qr.html_safe
    end.html_safe
  end

  def modal_footer
    content_tag(:div, class: 'modal-footer') do
      content_tag(:button, 'Close', class: ['btn', 'btn-primary'], data: { dismiss: 'modal' })
    end.html_safe
  end
end
