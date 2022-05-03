require "./spec_helper"

describe Crutter::Widget do
  it "generates the widgets from 'out/' correctly" do
    scaffold = Crutter::Widget.new("scaffold")
    app_bar = Crutter::Widget.new("app_bar")
    text = Crutter::Widget.new("text")
    center = Crutter::Widget.new("center")

    circular_progress_indicator = Crutter::Widget.new("circular_progress_indicator")
    circular_progress_indicator.args["valueColor"] = "#f00"
    center.children << circular_progress_indicator

    scaffold.args["body"] = center
    text.args["text"] = "Center"
    app_bar.args["title"] = text
    scaffold.args["appBar"] = app_bar

    JSON.parse(scaffold.to_json).as_h.should eq(JSON.parse(File.read(Path[".", "spec", "out", "center.json"])).as_h)
  end
end
