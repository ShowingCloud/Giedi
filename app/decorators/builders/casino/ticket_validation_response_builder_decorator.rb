CASino::TicketValidationResponseBuilder.class_eval do
  def build_success_xml(service_response, ticket, service_ticket, ticket_granting_ticket, proxies)
    user = ticket_granting_ticket.user
    service_response.cas :authenticationSuccess do |authentication_success|
      authentication_success.cas :user, user.username
      unless user.extra_attributes.blank?
        extra_attributes = ActiveModelSerializers::SerializableResource.new(::User.find(user.extra_attributes[:guid])).as_json
        authentication_success.cas :attributes do |attributes|
          attributes.cas :authenticationDate, ticket_granting_ticket.created_at.iso8601
          attributes.cas :longTermAuthenticationRequestTokenUsed, ticket_granting_ticket.long_term?
          attributes.cas :isFromNewLogin, service_ticket.issued_from_credentials?
          extra_attributes.each do |key, value|
            serialize_extra_attribute(attributes, key, value)
          end
        end
      end
      if options[:proxy_granting_ticket]
        proxy_granting_ticket = options[:proxy_granting_ticket]
        authentication_success.cas :proxyGrantingTicket, proxy_granting_ticket.iou
      end
      if ticket.is_a?(CASino::ProxyTicket)
        authentication_success.cas :proxies do |proxies_container|
          proxies.each do |proxy|
            proxies_container.cas :proxy, proxy
          end
        end
      end
    end
  end

end
