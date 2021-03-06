require 'spec_helper'

describe "Admin::WorkPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "List work pages" do
    before { visit works_path }

    it { should have_title(dashboard_title('Work List')) }
    it { should have_selector('h1', text: 'Work List') }
    it { should have_link('Add New Work', href: new_work_path) }

    describe "list of services" do
      before(:all) { 30.times { FactoryGirl.create(:work) } }
      before(:all) { Work.delete_all }

      it "should have pagination and list each service" do
        Work.paginate(page: 1) do |service|
          expect(page).to have_selector 'ul.pagination'
          expect(page).to have_selector 'p', text: work.name
          expect(page).to have_selector 'p', text: work.client
        end
      end
    end

  end

  describe "add new work page" do
    before(:all) { 5.times { FactoryGirl.create(:work_category) } }
    after(:all) { WorkCategory.delete_all }
    before do
      visit works_path
      click_link 'Add New Work'
    end

    it { should have_title(dashboard_title('Add New Work')) }
    it { should have_selector('h1', text: 'Add New Work') }

    it 'should have categories selection box' do
      page.all("option").count.should eql(6)
    end

    let(:submit) { 'Submit' }

    describe 'add new work' do
      describe "with invalid information" do
        it "should not create a new work" do
          expect { click_button submit }.not_to change(Work, :count)
        end
      end

      describe 'with valid information' do
        before do
          fill_in "Name", with: "Super Dragon Project"
          attach_file "work_cover_photo", "#{Rails.root}/spec/fixtures/files/placeholder.jpg"
          fill_in "work_client_name", with: "Superman"
          fill_in "Story", with: "Aloha cana banh da"
          fill_in "Techs", with: "Mind manipulation"
        end

        it "should create a new work" do
          expect { click_button submit }.to change(Work, :count).by(1)
        end
      end

      describe 'with invalid link' do
        before do
          fill_in "Name", with: "Super Dragon Project"
          attach_file "work_cover_photo", "#{Rails.root}/spec/fixtures/files/placeholder.jpg"
          fill_in "work_client_name", with: "Superman"
          fill_in "Story", with: "Aloha cana banh da"
          fill_in "Techs", with: "Mind manipulation"
          fill_in "Link", with: 'adsfcdef'
        end

        it "should create a new work" do
          expect { click_button submit }.not_to change(Work, :count)
        end
      end

      describe 'with valid link' do
        before do
          fill_in "Name", with: "Super Dragon Project"
          attach_file "work_cover_photo", "#{Rails.root}/spec/fixtures/files/placeholder.jpg"
          fill_in "work_client_name", with: "Superman"
          fill_in "Story", with: "Aloha cana banh da"
          fill_in "Techs", with: "Mind manipulation"
          fill_in "Link", with: 'adsfcdef'
        end

        it "should create a new work" do
          expect { click_button submit }.not_to change(Work, :count)
        end
      end
    end

    describe 'show work' do
      let(:work) { FactoryGirl.create(:work) }
      before do
        5.times do |i|
          work.tasks.create!(title: "ABC 123 #{i}", description: "ALOHA #{i}")
        end

        visit work_path(work)
      end

      it { should have_title(dashboard_title(work.name)) }
      it { should have_content(work.name) }
      it { should have_content(work.client_name) }
      it { should have_content(work.techs) }
      it { should have_content(work.story) }
      it { should have_content(work.link) }
      it { should have_link('Delete This Work', href: work_path(work)) }
      it { should have_link('Edit', href: edit_work_path(work)) }
      it { should have_link('Add Task', href: new_work_task_path(work)) }

      describe 'list of tasks' do
        it { should have_selector('h2', text: 'Tasks') }

        describe 'list all of the work task' do

          it 'should have list of tasks' do
            work.tasks.each do |task|
              expect(page).to have_content task.title
            end
          end
        end

        describe 'delete a task' do
          specify do
            expect do
              page.first('.task-delete').click()
            end.to change(work.tasks, :count).by(-1)
          end
        end
      end

      describe 'when click delete link' do
        specify do
          expect{ click_link 'Delete This Work' }.to change(Work, :count).by(-1)
        end
      end

      describe "edit work general info" do
        before { click_link 'Edit' }

        it { should have_title(dashboard_title('Edit Work')) }
        it { should have_selector('h1', text: "Edit #{work.name}") }

        describe "update with no new information" do
          before { click_button 'Submit' }
          describe "should redirect to info page with success message" do
            it { should have_title(dashboard_title(work.name)) }
            it { should have_selector('div.alert.alert-success') }
          end
        end

        describe 'with invalid information' do
          before do
            fill_in "Name", with: ""
            click_button 'Submit'
          end

          describe "should still in edit page and show error" do
            it { should_not have_title(dashboard_title(work.name)) }
            it { should have_selector('span.error-help') }
          end
        end
      end

    end
  end
end
