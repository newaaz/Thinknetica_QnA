require 'rails_helper'

RSpec.describe NewAnswerNotifyJob, type: :job do
  let(:answer)    { build(:answer) }

  it 'call NewAnswerNotifyService#send_notify' do
    expect(NewAnswerNotifyService).to receive(:send_notify).with(answer).and_call_original
    NewAnswerNotifyJob.perform_now(answer)
  end
end
