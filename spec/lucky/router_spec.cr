require "../spec_helper"

describe Lucky::Router do
  it "routes based on the method name and path" do
    Lucky::Router.add :get, "/test", Lucky::Action

    Lucky::Router.find_action(:get, "/test").found?.should eq(true)
    Lucky::Router.find_action("get", "/test").found?.should eq(true)
    Lucky::Router.find_action(:post, "/test").found?.should eq(false)
  end

  it "routes based on the method name and path" do
    Lucky::Router.add :post, "/test2", Lucky::Action

    Lucky::Router.find_action(:get, "/test2").found?.should eq(false)
    Lucky::Router.find_action("get", "/test2").found?.should eq(false)
    Lucky::Router.find_action(:post, "/test2").found?.should eq(true)
  end

  it "finds the associated get route by a head method" do
    Lucky::Router.add :get, "/test", Lucky::Action

    Lucky::Router.find_action(:head, "/test").should_not be_nil
    Lucky::Router.find_action("head", "/test").should_not be_nil
  end
end
