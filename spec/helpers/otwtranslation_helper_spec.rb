require 'spec_helper'
#include OtwtranslationHelper

describe OtwtranslationHelper do

  describe "ts" do
    it "should return the original phrase" do
      ts("Good day!").should == "Good day!"
    end
  end

  describe "t" do
    it "should return the original phrase" do
      t("home.greeting", :default => "Good day!").should == "Good day!"
    end

    it "should insert variables" do
      t("home.greeting", :default => "Good day, %{name}!", :name => "Abby")
        .should == "Good day, Abby!"
    end
  end
end
