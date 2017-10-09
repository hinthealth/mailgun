module Mailgun

  # Interface to manage domains
  class Domain
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end

    # List all domains on the account
    def list(options={})
      Mailgun.submit(:get, domain_url, options)["items"] || []
    end

    # Find domain by name
    def find(domain)
      Mailgun.submit :get, domain_url(domain)
    end

    # Add domain to account
    def create(domain, options = {})
      options = {name: domain}.merge(options)
      Mailgun.submit :post, domain_url, options
    end

    # Remves a domain from account
    def delete(domain)
      Mailgun.submit :delete, domain_url(domain)
    end

    # Verifies a domain from account (Check DNS Records Now from Mailgun Web UI)
    # The method is still in beta and you will need
    # access from Mailgun to use it
    def verify(domain)
      Mailgun.submit :put, "#{domain_url(domain)}/verify"
    end

    # Updates unsubscribe tracking settings for a domain
    def update_unsubscribe_tracking(domain, options = {})
      Mailgun.submit :put, "#{domain_url(domain)}/tracking/unsubscribe", options
    end

    private

    # Helper method to generate the proper url for Mailgun domain API calls
    def domain_url(domain = nil)
      "#{@mailgun.base_url}/domains#{'/' + domain if domain}"
    end
  end
end
