require 'spec_helper'

describe 'Sending report' do
  it '' do
    mail = double('Mail')
    allow(Mail).to receive(:new).with('boo'){ mail }
    expect(mail).to receive(:send!).exactly(3).times
    Report.send!('boo')
  end
end
