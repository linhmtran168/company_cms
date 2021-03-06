require 'spec_helper'

describe Work do
  before { @work = FactoryGirl.create(:work) }

  subject { @work }

  it { should respond_to(:name) }
  it { should respond_to(:cover_photo) }
  it { should respond_to(:client_name) }
  it { should respond_to(:client_info) }
  it { should respond_to(:client_quote) }
  it { should respond_to(:story) }
  it { should respond_to(:techs) }
  it { should respond_to(:link) }
  it { should respond_to(:tasks) }
  it { should respond_to(:category_id) }
  it { should respond_to(:category) }

  it { should be_valid }

  describe 'when title is not present' do
    before { @work.client_name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name is not present' do
    before { @work.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when description is not present' do
    before { @work.story = ' ' }
    it { should_not be_valid }
  end

  describe 'when image is not present' do
    before { @work.techs = ' ' }
    it { should_not be_valid }
  end

  describe 'when link is not valid' do
    before { @work.link = 'http://abc' }
    it { should_not be_valid }
  end

  describe 'with a valid link' do
    before { @work.link = 'http://abc.com' }
    it { should be_valid }
  end
end
