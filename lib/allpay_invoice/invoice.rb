require 'net/http'
require 'json'
require 'cgi'
require 'digest'
require 'allpay_invoice/errors'
require 'allpay_invoice/core_ext/hash'

module Allpay
  class Invoice
    PRE_ENCODE_COLUMN = [:CustomerName, :CustomerAddr , :CustomerEmail, :ItemName, :ItemWord, :InvoiceRemark, :InvCreateDate, :NotifyMail, :Reason, :IIS_Customer_Name, :IIS_Customer_Addr]
    BLACK_LIST_COLUMN = [:ItemName, :ItemWord, :InvoiceRemark, :Reason]
    PRODUCTION_API_HOST = 'https://einvoice.allpay.com.tw'.freeze
    TEST_API_HOST = 'http://einvoice-stage.allpay.com.tw'.freeze
    TEST_OPTIONS = {
      merchant_id: '2000132',
      hash_key: 'ejCk326UnaZWKisg',
      hash_iv: 'q9jcZX8Ib9LM8wYk'
    }.freeze

    attr_reader :options

    def initialize(options = {})
      @options = { mode: :production }.merge!(options)
      case @options[:mode]
      when :production
        option_required! :merchant_id, :hash_key, :hash_iv
      when :test
        @options = TEST_OPTIONS.merge(options)
      else
        fail InvalidMode, 'option :mode is either :test or :production'
      end
      @options.freeze
    end

    def api_host
      case @options[:mode]
      when :production then PRODUCTION_API_HOST
      when :test then TEST_API_HOST
      end
    end

    def make_mac(params = {})
      sort_hash = pre_encode(params.clone).sort_by { |x| x.to_s.downcase }
      raw = sort_hash.map! { |k, v| "#{k}=#{v}" }.join('&')
      str = "HashKey=#{@options[:hash_key]}&#{raw}&HashIV=#{@options[:hash_iv]}"
      url_encoded = CGI.escape(str).downcase!
      Digest::MD5.hexdigest(url_encoded).upcase!
    end

    def verify_mac(params = {})
      stringified_keys = params.stringify_keys
      check_mac_value = stringified_keys.delete('CheckMacValue')
      make_mac(stringified_keys) == check_mac_value
    end

    def generate_params(overwrite_params = {})
      result = overwrite_params
      result[:TimeStamp] = Time.now.to_i
      result[:MerchantID] = @options[:merchant_id]
      result[:CheckMacValue] = make_mac(result)
      result
    end

    def request(path, params = {})
      api_url = URI.join(api_host + path)
      Net::HTTP.post_form api_url, params
    end

    # 一般開立發票API
    # url_encode => CustomerAddr / CustomerName / CustomerEmail / ItemName / ItemWord / InvCreateDate / InvoiceRemark
    # 在產生 CheckMacValue 時,須將 ItemName、ItemWord 及 InvoiceRemark 等欄位排除
    def issue(overwrite_params = {})
      res = request '/Invoice/Issue', generate_params(overwrite_params)
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 延遲或觸發開立發票API
    # url_encode => CustomerEmail / CustomerName / CustomerAddr / ItemName / ItemWord / InvoiceRemark
    # 在產生 CheckMacValue 時, 須將 ItemName、ItemWord 及 InvoiceRemark 等欄位排除
    def delay_issue(overwrite_params = {})
      res = request '/Invoice/DelayIssue', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 開立折讓API
    # url_encode => NotifyMail / ItemName / ItemWord
    # 在產生 CheckMacValue 時,須將 ItemName 及 ItemWord 等欄位排除
    def allowance(overwrite_params = {})
      res = request '/Invoice/Allowance', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 發票作廢API
    # url_encode => Reason
    # 在產生 CheckMacValue 時,須將 Reason 欄位排除
    def issue_invalid(overwrite_params = {})
      res = request '/Invoice/IssueInvalid', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 折讓作廢API
    # url_encode => Reason
    # 在產生 CheckMacValue 時,須將 ItemName 及 ItemWord 等欄位排除
    def allowance_invalid(overwrite_params = {})
      res = request '/AllowanceInvalid', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 查詢發票API
    # url_encode => IIS_Customer_Name / IIS_Customer_Addr / ItemName / ItemWord / InvoiceRemark
    # 在產生 CheckMacValue 時,須將 ItemName、ItemWord 及 InvoiceRemark 等欄位排除
    def query_issue(overwrite_params = {})
      res = request '/Query/Issue', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 查詢作廢發票API
    # url_encode => Reason
    # 在產生 CheckMacValue 時,須將 Reason 等欄位排除
    def query_issue_invalid(overwrite_params = {})
      res = request '/Query/IssueInvalid', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 查詢折讓明細API
    # url_encode => ItemName / ItemWord / IIS_Customer_Name
    # 在產生 CheckMacValue 時,須將 ItemName、ItemWord 等欄位排除
    def query_allowance(overwrite_params = {})
      res = request '/Query/Allowance', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 查詢折讓作廢明細API
    # url_encode => Reason
    # 在產生 CheckMacValue 時,須將 Reason 等欄位排除
    def query_allowance_invalid(overwrite_params = {})
      res = request '/Query/AllowanceInvalid', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 發送通知API
    def invoice_notify(overwrite_params = {})
      res = request '/Notify/InvoiceNotify', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    # 付款完成觸發或延遲開立發票API
    def trigger_issue(overwrite_params = {})
      res = request '/Invoice/TriggerIssue', overwrite_params
      Hash[res.body.split('&').map! { |i| i.split('=') }]
    end

    private

    def pre_encode(params)
      PRE_ENCODE_COLUMN.each do |key|
        params[key] = CGI.escape(params[key]) if params.key?(key)
      end
      params.delete_if { |key| BLACK_LIST_COLUMN.find_index(key) }
    end

    def option_required!(*option_names)
      option_names.each do |option_name|
        raise MissingOption, %Q{option "#{option_name}" is required.} if @options[option_name].nil?
      end
    end
  end
end
