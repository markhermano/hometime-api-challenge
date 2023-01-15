require "rails_helper"

describe "#Reservation" do
  subject { build(:reservation1) }

  shared_examples "returning an error" do |attribute, message|
    it { expect(subject).not_to be_valid }
    it { expect(subject.errors.messages[attribute]).to eq message }
  end

  context "when code is missing" do
    before do
      subject.code = ""
      subject.save
    end

    it_behaves_like "returning an error", :code, ["can't be blank"]
  end

  context "when already existing code is saved" do
    before do
      cache(:reservation1)
      subject.save
    end

    it_behaves_like "returning an error", :code, ["has already been taken"]
  end

  context "when guest details are not set" do
    let(:subject) { build(:reservation1, code: "new_code", guest_attributes: {}) }
    
    before { subject.save}

    it_behaves_like "returning an error", :guest, ["must exist"]
  end

  context "when all attributes are valid" do
    it { is_expected.to be_valid }
    it "persists to database" do
      expect{ subject.save }.to change { Reservation.count }.by(1)
    end
  end
end
