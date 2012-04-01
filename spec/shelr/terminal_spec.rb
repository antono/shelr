require 'spec_helper'

describe Shelr::Terminal do

  describe "#size" do
    it "returns :width and :height as integers" do
      subject.size[:width].should be_a(Integer)
      subject.size[:height].should be_a(Integer)
    end
  end
end
