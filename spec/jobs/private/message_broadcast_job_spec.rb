require 'rails_helper'

RSpec.describe Private::MessageBroadcastJob, type: :job do
  let(:conversation) { create(:private_conversation) }
  let(:sender)       { create(:user) }
  let(:message)      { create(:private_message, conversation: conversation, sender: sender, body: "hello!") }

  it "enqueues with perform_later" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      described_class.perform_later(message)
    }.to have_enqueued_job(described_class).with(message).on_queue("default")
  end

  it "broadcasts the rendered message to the conversation stream" do
    # Μην κάνουμε πραγματικό render στο test: stub-άρουμε το renderer
    html_stub = %(<li id="message-#{message.id}" data-message-id="#{message.id}">hello!</li>)
    allow(ApplicationController.renderer).to receive(:render).and_return(html_stub)

    expect(ActionCable.server).to receive(:broadcast).with(
      "private_conversation_#{conversation.id}",
      hash_including(
        html: include(%(data-message-id="#{message.id}")),
        message_id: message.id,
        conversation_id: conversation.id
      )
    )

    described_class.perform_now(message)
  end
end
