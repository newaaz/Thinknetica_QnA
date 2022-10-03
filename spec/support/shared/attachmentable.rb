shared_examples_for 'Attachmentable' do
  it 'have many attached files' do
    expect(subject.class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
