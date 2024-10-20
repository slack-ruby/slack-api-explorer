require 'spec_helper'

describe Team do
  describe '#purge!' do
    let!(:active_team) { Fabricate(:team) }
    let!(:inactive_team) { Fabricate(:team, active: false) }
    let!(:inactive_team_a_week_ago) { Fabricate(:team, updated_at: 1.week.ago, active: false) }
    let!(:inactive_team_two_weeks_ago) { Fabricate(:team, updated_at: 2.weeks.ago, active: false) }
    let!(:inactive_team_a_month_ago) { Fabricate(:team, updated_at: 1.month.ago, active: false) }

    it 'destroys teams inactive for two weeks' do
      expect do
        described_class.purge!
      end.to change(described_class, :count).by(-2)
      expect(described_class.find(active_team.id)).to eq active_team
      expect(described_class.find(inactive_team.id)).to eq inactive_team
      expect(described_class.find(inactive_team_a_week_ago.id)).to eq inactive_team_a_week_ago
      expect(described_class.find(inactive_team_two_weeks_ago.id)).to be_nil
      expect(described_class.find(inactive_team_a_month_ago.id)).to be_nil
    end
  end
end
