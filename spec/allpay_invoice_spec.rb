require 'spec_helper'
require 'securerandom'
describe AllpayInvoice::Invoice do
  before :all do
    @client = AllpayInvoice::Invoice.new(mode: :test)
    @invoice_number_1 = SecureRandom.hex(6)
    @invoice_number_2 = SecureRandom.hex(6)
    @invoice_number_3 = SecureRandom.hex(6)
  end

  it 'has a version number' do
    expect(AllpayInvoice::VERSION).not_to be nil
  end

  it '#api /Invoice/Issue with default' do
    res = @client.issue(TimeStamp: Time.now.to_i,
                        RelateNumber: @invoice_number_1,
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

  it '#api /Invoice/Issue with CustomerIdentifier' do
    res = @client.issue(TimeStamp: Time.now.to_i,
                        RelateNumber: @invoice_number_2,
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
                              DelayFlag: '2',
                              DelayDay: '0',
                              ECBankID: '',
                              Tsr: SecureRandom.hex(6),
                              PayType: '3',
                              PayAct: '3',
                              NotifyURL: 'bird1204@gmail.com',
                              RelateNumber: @invoice_number_3,
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
     expect(res.keys).to match_array(%w(CheckMacValue OrderNumber RtnCode RtnMsg))
  end

  it '#api /Query/Issue' do
    res = @client.query_issue(RelateNumber: @invoice_number_1)
    expect(res.keys).to match_array(%w(CheckMacValue IIS_Award_Flag IIS_Award_Type IIS_Carruer_Num IIS_Carruer_Type
                                       IIS_Category IIS_Check_Number IIS_Clearance_Mark IIS_Create_Date
                                       IIS_Customer_Addr IIS_Customer_Email IIS_Customer_ID IIS_Customer_Name
                                       IIS_Customer_Phone IIS_IP IIS_Identifier IIS_Invalid_Status IIS_Issue_Status
                                       IIS_Love_Code IIS_Mer_ID IIS_Number IIS_Print_Flag IIS_Random_Number IIS_Relate_Number
                                       IIS_Remain_Allowance_Amt IIS_Sales_Amount IIS_Tax_Amount IIS_Tax_Rate IIS_Tax_Type
                                       IIS_Turnkey_Status IIS_Type IIS_Upload_Date IIS_Upload_Status InvoiceRemark
                                       ItemAmount ItemCount ItemName ItemPrice ItemTaxType ItemWord RtnCode RtnMsg))
  end

  it '#api /Invoice/IssueInvalid' do
    res = @client.issue_invalid(TimeStamp: Time.now.to_i,
                                InvoiceNumber: @client.query_issue(RelateNumber: @invoice_number_1)['IIS_Number'],
                                Reason: '我爽'
                               )
    expect(res.keys).to match_array(%w(CheckMacValue InvoiceNumber RtnCode RtnMsg))
  end

  it '#api /Query/IssueInvalid' do
    res = @client.query_issue_invalid(TimeStamp: Time.now.to_i,
                                      RelateNumber: @invoice_number_1
                                     )
    expect(res.keys).to match_array(%w(CheckMacValue II_Buyer_Identifier II_Date II_Invoice_No II_Mer_ID II_Seller_Identifier II_Upload_Date II_Upload_Status Reason RtnCode RtnMsg))
  end

  it '#api /Invoice/Allowance' do
    res = @client.allowance(TimeStamp: Time.now.to_i,
                            InvoiceNo: @client.query_issue(RelateNumber: @invoice_number_2)['IIS_Number'],
                            AllowanceNotify: 'E',
                            CustomerName: '我爽',
                            NotifyMail: 'bird1204@gmail.com',
                            NotifyPhone: '',
                            AllowanceAmount: '100',
                            ItemName: 'item2',
                            ItemCount: '1',
                            ItemWord: '份',
                            ItemPrice: '100',
                            ItemTaxType: '1',
                            ItemAmount: '100'
                           )
    expect(res.keys).to match_array(%w(RtnCode RtnMsg IA_Allow_No IA_Invoice_No IA_Date IA_Remain_Allowance_Amt CheckMacValue))
  end

  it '#api /Query/Allowance' do
    res = @client.query_allowance(TimeStamp: Time.now.to_i,
                                  InvoiceNo: @client.query_issue(RelateNumber: @invoice_number_2)['IIS_Number'],
                                  AllowanceNo: ''
                                 )
    expect(res.keys).to match_array(%w(CheckMacValue RtnCode RtnMsg))
  end

  it '#api /Query/AllowanceInvalid' do
    res = @client.query_allowance_invalid(TimeStamp: Time.now.to_i,
                                          InvoiceNo: @client.query_issue(RelateNumber: @invoice_number_2)['IIS_Number'],
                                          AllowanceNo: ''
                                         )
    expect(res.keys).to match_array(%w(CheckMacValue RtnCode RtnMsg))
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
