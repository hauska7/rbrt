require "my_spec_helper"
require "./app/cases/post_create"
require "./spec/doubles/persistance_double"

RSpec.describe PostCreate do
  it 'success' do
    persistance = PersistanceDouble.build

    result = PostCreate.call(persistance: persistance, attributes: { title: "Wonder Woman vs Batman" })

    expect(result.post.title).to eq "Wonder Woman vs Batman"
    expect(persistance.persisted_post_count).to eq 1
  end

  it 'failure, no title' do
    persistance = PersistanceDouble.build

    result = PostCreate.call(persistance: persistance, attributes: { title: "" })

    expect(result.errors.empty?).to be false
    expect(persistance.persist_counter).to eq 0
  end
end
