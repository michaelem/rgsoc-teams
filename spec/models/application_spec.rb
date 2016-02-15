require 'spec_helper'

describe Application do
  subject { FactoryGirl.build_stubbed(:application) }

  it { is_expected.to validate_presence_of(:application_data) }
  it { is_expected.to validate_presence_of(:team) }

  context 'with associations' do
    it { is_expected.to belong_to(:team) }
    it { is_expected.to belong_to(:application_draft) }
  end

  describe '#average_skill_level' do
    subject { super().average_skill_level }
    it { is_expected.to be_present }
  end

  describe '#total_picks' do
    subject { super().total_picks }
    it { is_expected.to be_present }
  end

  describe '#name' do
    it 'returns an empty string' do
      subject.team = nil
      subject.application_data['project_name'] = nil
      expect(subject.name).to eql ''
    end

    it 'derives its name from its team and project name' do
      subject.team = build_stubbed(:team, name: 'Foobar')
      subject.application_data['project_name'] = 'Hello World'

      expect(subject.name).to eql 'Foobar - Hello World'
    end
  end

  it { is_expected.to respond_to(:sponsor_pick?) }

  it_behaves_like 'HasSeason'

  describe 'scopes' do
    describe '.hidden' do
      it 'returns only hidden applications' do
        expect(Application.hidden.where_values).to eq(
          ["applications.hidden IS NOT NULL and applications.hidden = 't'"]
        )
      end
    end

    describe '.visible' do
      it 'returns only visible applications' do
        expect(Application.visible.where_values).to eq(
          ["applications.hidden IS NULL or applications.hidden = 'f'"]
        )
      end
    end
  end

  describe 'flags' do
    flags = Application::FLAGS

    flags.each do |flag|
      it { is_expected.to respond_to("#{flag}?") }
      it { is_expected.to respond_to("#{flag}=") }
    end

    it 'adds the flag if the value is > 0' do
      flag = flags.sample.to_sym
      expect(subject.flags).not_to include(flag)

      subject.send("#{flag}=", '1')
      expect(subject.flags).to include(flag)
    end

    it 'removes the flag if the value is 0' do
      flag = flags.sample.to_sym
      subject.send("#{flag}=".to_sym, '1')
      expect(subject.flags).to include(flag)
      subject.send("#{flag}=".to_sym, '0')
      expect(subject.flags).not_to include(flag)
    end
  end

  describe 'student_name' do
    let(:team)    { FactoryGirl.build(:team, students: [student]) }
    let(:student) { FactoryGirl.build(:student) }

    before { allow(subject).to receive(:team).and_return(team) }

    it { expect(subject.student_name).to eq student.name }
  end

  describe 'proxy methods' do
    proxy_methods = %w(location minimum_money)

    proxy_methods.each do |key|
      describe key do
        it { expect(subject.send(key)).to be_present }
        it { expect(subject.send(key)).to eq subject.application_data[key] }
      end
    end
  end

  describe 'rating defaults' do
    describe '#rating_defaults' do
      subject { super().rating_defaults }
      it { is_expected.to be_present }
    end

    default_methods = %w(women_priority skill_level practice_time project_time)

    default_methods.each do |key|
      describe "estimated_#{key}" do
        subject { super().send("estimated_#{key}") }
        it { is_expected.to be_present }
      end
    end
  end

  describe 'sponsor pick' do
    application = FactoryGirl.create(:application)
    it 'does not have a sponsor' do
      expect(application.sponsor_pick?).to eql false
    end
  end
end
