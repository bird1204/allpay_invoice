require 'spec_helper'
require 'securerandom'
describe Allpay::Invoice do
  before :all do
    @client = Allpay::Invoice.new(mode: :test)
  end

  it 'has a version number' do
    expect(AllpayInvoice::VERSION).not_to be nil
  end

  it '#api /Invoice/Issue with default' do
    res = @client.issue TimeStamp: Time.now.to_i,
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
      InvCreateDate: Time.now.strftime('%Y-%m-%d %H:%M:%S')
    expect(res['RtnCode']).to eq '1'
  end

  it '#api /Invoice/Issue with CustomerIdentifier' do
    res = @client.issue TimeStamp: Time.now.to_i,
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
      InvCreateDate: Time.now.strftime('%Y-%m-%d %H:%M:%S')
    expect(res['RtnCode']).to eq '1'
  end

  it '#api /Invoice/DelayIssue' do
    res = @client.request '/Invoice/DelayIssue', TimeStamp: Time.now.to_i,
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
      InvCreateDate: Time.now.strftime('%Y-%m-%d %H:%M:%S')
    expect(res.code).to eq '200'
  end


  it '#make_mac' do 
    mac = @client.make_mac(
      TimeStamp: '1439265869',
      RelateNumber: '1007e8d8f567',
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
      InvCreateDate: '2015-08-11 12:04:29'
    )
    expect(mac).to eq '85B54A3A72AD5CD86F3D9ADF0D5140CB'
  end

  it '#verify_mac' do
    result = @client.verify_mac RtnCode: '1',
      TimeStamp: '1439265869',
      RelateNumber: '1007e8d8f567',
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
      InvCreateDate: '2015-08-11 12:04:29',
      CheckMacValue: '26467B59DFBBED078BA362C14FD5A8E4'
    expect(result).to eq true
  end
end
