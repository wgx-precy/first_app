class SectionsController < ApplicationController
  # require "happymapper"
  def index
    #@assessment = Assessment.find(params[:assessment_id])
    assessment = File.open("/Users/guoxuwang/Desktop/quiz6.xml", "rb") {|io| io.read}
    xml = Nokogiri.XML(assessment)
    assessment = Assessment.from_xml(xml,1)
    render :text => @assessment
    #@sections = @assessment.sections
  end

  def show
    @section = Section.find(params[:id])
  end
end