require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'password' do
      it 'does not require a password unless there is an email' do
        user = User.new
        expect(user).to be_valid
        user.email = "foo@example.com"
        expect(user).to_not be_valid
        user.password = "my-very-super-secret-password"
        expect(user).to be_valid
      end
    end
    describe 'name' do
      let(:user) { User.new(name: user_name) }
      context 'with no name' do
        let(:user_name) { nil }
        it { expect(user).to be_valid }
      end
      context 'with less than 4 characters' do
        let(:user_name) { 'abc' }
        it { expect(user).not_to be_valid }
      end
      context 'with more than 16 characters' do
        let(:user_name) { 'abcdefghijklmnopq' }
        it { expect(user).not_to be_valid }
      end
      context 'between 4 and 16 characters' do
        let(:user_name) { 'abcdefghijklmno' }
        it { expect(user).to be_valid }
      end
    end
  end

  describe '#name' do
    let(:user) { User.new(name: user_name).tap { |u| u.id = 2 } }
    context 'without a name set' do
      let(:user_name) { nil }
      it 'defaults to user+id' do
        expect(user.name).to eq('User #2')
      end
    end
    context 'with a name set' do
      let(:user_name) { 'Juan' }
      it 'uses the specified name' do
        expect(user.name).to eq('Juan')
      end
    end
  end

  describe '#compute_score' do
    context 'with some score transactions' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:score_transaction, user: user, amount: 11)
        FactoryGirl.create(:score_transaction, user: user, amount: 4)
      end

      it 'should compute the score' do
        user.update_attribute(:score, 0)
        user.compute_score
        expect(user.score).to eq(15)
      end
    end
  end
end
