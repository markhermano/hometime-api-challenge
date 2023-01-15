require "rails_helper"

describe "#Guest" do
  subject { build(:guest1) }

  shared_examples "returning an error" do |attribute, message|
    it { expect(subject).not_to be_valid }
    it { expect(subject.errors.messages[attribute]).to eq message }
  end

  context "when email format is invalid" do
    before do
      subject.email = "bad.email.com@"
      subject.save
    end

    it_behaves_like "returning an error", :email, ["is invalid"]
  end

  context "when email is missing" do
    before do
      subject.email = ""
      subject.save
    end

    it_behaves_like "returning an error", :email, ["can't be blank", "is invalid"]
  end

  context "when first_name is missing" do
    before do
      subject.first_name = ""
      subject.save
    end

    it_behaves_like "returning an error", :first_name, ["can't be blank"]
  end

  context "when last_name is missing" do
    before do
      subject.last_name = ""
      subject.save
    end

    it_behaves_like "returning an error", :last_name, ["can't be blank"]
  end

  context "when phone is missing" do
    before do
      subject.phone = []
      subject.save
    end

    it_behaves_like "returning an error", :phone, ["can't be blank"]
  end

  context "when already existing email is saved" do
    before do
      cache(:guest1)
      subject.save
    end

    it_behaves_like "returning an error", :email, ["has already been taken"]
  end

  context "when all attributes are valid" do
    it { is_expected.to be_valid }
    it "persists to database" do
      expect{ subject.save }.to change { Guest.count }.by(1)
    end
  end
end
