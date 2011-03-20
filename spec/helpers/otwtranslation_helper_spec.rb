require 'spec_helper'

describe OtwtranslationHelper do

  describe "ts" do
    it "should return the original phrase" do
      helper.stub(:logged_in?).and_return(false)
      helper.ts("Good day!").should == "Good day!"
    end
  end

  describe "t" do
    it "should return the original phrase" do
      helper.t("home.greeting", :default => "Good day!").should == "Good day!"
    end

    it "should insert variables" do
      helper.t("home.greeting", :default => "Good day, %{name}!",
               :name => "Abby").should == "Good day, Abby!"
    end
  end
end
