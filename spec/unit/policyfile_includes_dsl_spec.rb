require "spec_helper"
require "chef-dk/policyfile_compiler"
require "chef-dk/exceptions"

describe ChefDK::PolicyfileCompiler, "including upstream policy locks" do

  let(:run_list) { ["local::default"] }
  let(:included_policies) { [] }

  let(:policyfile) do
    policyfile = ChefDK::PolicyfileCompiler.new.build do |p|

      p.run_list(*run_list)
      included_policies.each do |policy|
        p.include_policy(policy[0], policy[1])
      end
    end

    policyfile
  end

  describe "when include_policy specifies a policy on disk" do
    describe "and the included policy is correctly configured" do
      let(:included_policies) { [["foo", { local: "./foo.lock.json" }]] }

      it "has a included policy" do
        expect(policyfile.included_policies.length).to eq(1)
      end

      it "uses a local fetcher" do
        expect(policyfile.included_policies[0].fetcher).to be_a(ChefDK::Policyfile::LocalLockFetcher)
      end

      it "has a fetcher with no errors" do
        expect(policyfile.included_policies[0].fetcher.errors).to eq([])
      end

      it "has a fetcher that is valid" do
        expect(policyfile.included_policies[0].fetcher.valid?).to eq(true)
      end
    end

  end

  describe "when include_policy specifies a policy on a chef server" do
    let(:included_policies) { [["foo", { server: "http://example.com", policy_name: "foo" }]] }
    describe "and policy_revision_id is missing" do
      it "has a dsl with errors" do
        expect(policyfile.dsl.errors.length).to eq(1)
        expect(policyfile.dsl.errors[0]).to match(/missing key policy_revision_id/)
      end
    end

    describe "and the policy name is missing" do
      let(:included_policies) { [["foo", { server: "http://example.com", policy_revision_id: "bar" }]] }
      it "has a dsl with errors" do
        expect(policyfile.dsl.errors.length).to eq(1)
        expect(policyfile.dsl.errors[0]).to match(/missing key policy_name/)
      end
    end

    describe "and everything is correctly configured" do
      let(:included_policies) { [["foo", { server: "http://example.com", policy_name: "foo", policy_revision_id: "bar" }]] }
      it "has a dsl with no errors" do
        expect(policyfile.dsl.errors.length).to eq(0)
      end

      it "has a included policy" do
        expect(policyfile.included_policies.length).to eq(1)
      end

      it "uses a local fetcher" do
        expect(policyfile.included_policies[0].fetcher).to be_a(ChefDK::Policyfile::ChefServerLockFetcher)
      end

      it "has a fetcher with no errors" do
        expect(policyfile.included_policies[0].fetcher.errors).to eq([])
      end

      it "has a fetcher that is valid" do
        expect(policyfile.included_policies[0].fetcher.valid?).to eq(true)
      end
    end
  end

  describe "when include_policy specifies a policy fetched with an unknown method" do
    let(:included_policies) { [["foo", { foofetch: "bar" }]] }

    it "has a included policy" do
      expect(policyfile.included_policies.length).to eq(1)
    end

    it "has a dsl with an errors" do
      expect(policyfile.dsl.errors.length).to eq(1)
      expect(policyfile.dsl.errors[0]).to match(/include_policy must use one of the following/)
    end
  end

  describe "when a policy with the same name is specified multiple times" do
    let(:included_policies) do
      [
        ["foo", { local: "./foo.lock.json" }],
        ["foo", { local: "./foo.lock.json" }],
      ]
    end

    it "has a dsl with errors" do
      expect(policyfile.dsl.errors.length).to eq(1)
      expect(policyfile.dsl.errors[0]).to match(/assigned conflicting locations/)
    end
  end

end
