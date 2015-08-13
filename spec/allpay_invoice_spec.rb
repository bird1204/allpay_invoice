require 'spec_helper'
require 'securerandom'
describe AllpayInvoice::Invoice do
  before :all do
    @client = AllpayInvoice::Invoice.new(mode: :test)
  end

  it 'has a version number' do
    expect(AllpayInvoice::VERSION).not_to be nil
  end

  xit '#api /Invoice/Issue with default' do
    res = @client.issue(TimeStamp: Time.now.to_i,
                        RelateNumber: SecureRandom.hex(6),
                        CustomerIdentifier: '',
                        CustomerName: 'bird的rspec',
                        CustomerAddr: 'bird的rspec_address',
                        CustomerPhone: '',
                        CustomerEmail: 'bird1204@gmail.com',
                        ClearanceMark: '',
                        Print: '1',
                        Donation: '2',
                        CarruerType: '',
                        CarruerNum: '',
                        TaxType: '1',
                        SalesAmount: 200,
                        InvoiceRemark: 'remark備註',
                        ItemName: '車子1|item2',
                        ItemCount: '1|1',
                        ItemWord: '個|份',
                        ItemPrice: '100|100',
                        ItemTaxType: '1|1',
                        ItemAmount: '100|100',
                        InvType: '07',
                        InvCreateDate: Time.now.strftime('%Y-%m-%d %H:%M:%S'))
    expect(res['RtnCode']).to eq '1'
  end

  xit '#api /Invoice/Issue with CustomerIdentifier' do
    res = @client.issue(TimeStamp: Time.now.to_i,
                        RelateNumber: SecureRandom.hex(6),
                        CustomerIdentifier: '12312312',
                        CustomerName: 'bird的rspec',
                        CustomerAddr: 'bird的rspec_address',
                        CustomerPhone: '',
                        CustomerEmail: 'bird1204@gmail.com',
                        ClearanceMark: '',
                        Print: '1',
                        Donation: '2',
                        CarruerType: '',
                        CarruerNum: '',
                        TaxType: '1',
                        SalesAmount: 200,
                        InvoiceRemark: 'remark備註',
                        ItemName: '車子1|item2',
                        ItemCount: '1|1',
                        ItemWord: '個|份',
                        ItemPrice: '100|100',
                        ItemTaxType: '1|1',
                        ItemAmount: '100|100',
                        InvType: '07',
                        InvCreateDate: Time.now.strftime('%Y-%m-%d %H:%M:%S'))
    expect(res['RtnCode']).to eq '1'
  end

  it '#api /Invoice/DelayIssue' do
    res = @client.delay_issue(TimeStamp: Time.now.to_i,
                              TimeStamp: Time.now.to_i,
                              RelateNumber: SecureRandom.hex(6),
                              CustomerIdentifier: '',
                              CustomerName: 'bird的rspec',
                              CustomerAddr: 'bird的rspec_address',
                              CustomerPhone: '',
                              CustomerEmail: 'bird1204@gmail.com',
                              ClearanceMark: '',
                              Print: '1',
                              Donation: '2',
                              CarruerType: '',
                              CarruerNum: '',
                              TaxType: '1',
                              SalesAmount: 200,
                              InvoiceRemark: 'remark備註',
                              ItemName: '車子1|item2',
                              ItemCount: '1|1',
                              ItemWord: '個|份',
                              ItemPrice: '100|100',
                              ItemTaxType: '1|1',
                              ItemAmount: '100|100',
                              InvType: '07',
                              InvCreateDate: Time.now.strftime('%Y-%m-%d %H:%M:%S'))
    expect(res.keys.first.dup.force_encoding('utf-8')).to eq 'MerchantID錯誤'
  end

  it '#make_mac' do
    mac = @client.make_mac(TimeStamp: 143_945_483_6,
                           RelateNumber: 'c99cf54aa259',
                           CustomerIdentifier: '',
                           CustomerName: 'bird的rspec',
                           CustomerAddr: 'bird的rspec_address',
                           CustomerPhone: '',
                           CustomerEmail: 'bird1204@gmail.com',
                           ClearanceMark: '',
                           Print: '1',
                           Donation: '2',
                           CarruerType: '',
                           CarruerNum: '',
                           TaxType: '1',
                           SalesAmount: 200,
                           InvoiceRemark: 'remark備註',
                           ItemName: '車子1|item2',
                           ItemCount: '1|1',
                           ItemWord: '個|份',
                           ItemPrice: '100|100',
                           ItemTaxType: '1|1',
                           ItemAmount: '100|100',
                           InvType: '07',
                           InvCreateDate: '2015-08-13 16:33:56',
                           MerchantID: '2000132')
    expect(mac).to eq 'AE9671942FD17113A8D97C52390B00BC'
  end

  it '#verify_mac' do
    result = @client.verify_mac(InvoiceDate: '2015-08-13 16:33:56',
                                InvoiceNumber: 'XN00001156',
                                RandomNumber: '8090',
                                RtnCode: '1',
                                RtnMsg: '開立發票成功',
                                CheckMacValue: 'AAAEFE6BB54BC670044B962FD0F6679D')
    expect(result).to eq true
  end
end
