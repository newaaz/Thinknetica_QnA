require 'rails_helper'

RSpec.describe NewAnswerNotifyJob, type: :job do  
  let(:answer)  { create(:answer) }  
  let(:service) { double('NewAnswerNotifyService') }

  before do
    allow(NewAnswerNotifyService).to receive(:new).and_return(service)
  end  

  it 'call NewAnswerNotifyService#send_notify' do
    expect(service).to receive(:send_notify).with(answer)
    NewAnswerNotifyJob.perform_now(answer)
  end
end
