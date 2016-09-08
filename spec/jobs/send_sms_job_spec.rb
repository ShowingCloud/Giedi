require 'rails_helper'

RSpec.describe SendSmsJob, type: :job do
   subject(:job) { described_class.perform_later("18035243428")}
   it 'queues the job' do
   expect { job }
     .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
 end

 it 'is in urgent queue' do
   expect(SendSmsJob.new.queue_name).to eq('default')
 end

 it 'executes perform' do
   WebMock::stub_request(:post, "https://api.submail.cn/message/xsend.json")
   perform_enqueued_jobs { job }
 end

 after do
   clear_enqueued_jobs
   clear_performed_jobs
 end
end
