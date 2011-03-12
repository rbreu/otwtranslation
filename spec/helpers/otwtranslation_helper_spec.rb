require 'spec_helper'
#include OtwtranslationHelper

describe OtwtranslationHelper do

  describe "ts" do
    it "should return the original phrase" do
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
